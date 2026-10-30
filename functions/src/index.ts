import {setGlobalOptions} from "firebase-functions";
import {onDocumentCreated} from "firebase-functions/v2/firestore";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as admin from "firebase-admin";

if (admin.apps.length === 0) {
  admin.initializeApp();
}

setGlobalOptions({maxInstances: 10});

/**
 * Triggered when a new nudge document is created in:
 * /users/{userId}/nudges/{nudgeId}.
 * Sends an FCM push notification to the recipient user.
 */
export const onStreakNudgeCreated = onDocumentCreated(
  "/users/{userId}/nudges/{nudgeId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const recipientUserId = event.params.userId;
    const data = snapshot.data();
    const senderName = data?.senderName || "Một phi hành gia";
    const senderAstroId = data?.senderAstroId || "";
    const nudgeBody = `${senderName} (${senderAstroId}) vừa gửi tín hiệu ` +
      "nhắc bạn ghi nhật ký hôm nay để không mất chuỗi!";

    try {
      const userDoc = await admin
        .firestore()
        .collection("users")
        .doc(recipientUserId)
        .get();

      if (!userDoc.exists) {
        logger.warn(`User ${recipientUserId} does not exist`);
        return;
      }

      const fcmToken = userDoc.data()?.fcmToken;
      if (!fcmToken) {
        logger.info(`User ${recipientUserId} has no FCM token registered`);
        return;
      }

      await admin.messaging().send({
        token: fcmToken,
        notification: {
          title: "🚨 Tín hiệu cứu Streak!",
          body: nudgeBody,
        },
        data: {
          type: "streak_nudge",
          senderId: data?.senderId || "",
          senderAstroId: senderAstroId,
          timestamp: String(Date.now()),
        },
        android: {
          priority: "high",
          notification: {
            sound: "default",
            channelId: "streak_channel",
          },
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            },
          },
        },
      });

      logger.info(
        `Successfully sent streak nudge to user ${recipientUserId}`
      );
    } catch (error) {
      logger.error("Error sending streak nudge push notification:", error);
    }
  }
);

/**
 * Callable function to directly send a streak nudge with validation
 * and anti-spam check.
 */
export const sendStreakNudge = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Yêu cầu đăng nhập.");
  }

  const {targetUserId, senderName, senderAstroId} = request.data;
  if (!targetUserId) {
    throw new HttpsError(
      "invalid-argument",
      "targetUserId không được để trống."
    );
  }

  const senderId = request.auth.uid;
  if (senderId === targetUserId) {
    throw new HttpsError("invalid-argument", "Không thể tự nhắc chính mình.");
  }

  const now = new Date();
  const startOfDay = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate()
  ).getTime();

  // Check anti-spam: 1 nudge per friend per day
  const recentNudges = await admin
    .firestore()
    .collection("users")
    .doc(targetUserId)
    .collection("nudges")
    .where("senderId", "==", senderId)
    .where("timestamp", ">=", startOfDay)
    .limit(1)
    .get();

  if (!recentNudges.empty) {
    throw new HttpsError(
      "already-exists",
      "Hôm nay bạn đã gửi nhắc nhở cho người bạn này rồi."
    );
  }

  // Create nudge record in Firestore (which triggers onStreakNudgeCreated)
  const nudgeRef = await admin
    .firestore()
    .collection("users")
    .doc(targetUserId)
    .collection("nudges")
    .add({
      senderId,
      senderName: senderName || "Bạn bè",
      senderAstroId: senderAstroId || "",
      timestamp: Date.now(),
    });

  return {success: true, nudgeId: nudgeRef.id};
});

/**
 * Callable function to proxy Gemini AI requests securely
 * from backend (ASTRO-005).
 * Prevents embedding sensitive GEMINI_API_KEY in the mobile client binary.
 */
export const geminiProxy = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Yêu cầu đăng nhập.");
  }

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new HttpsError(
      "failed-precondition",
      "Server-side GEMINI_API_KEY chưa được cấu hình."
    );
  }

  const {prompt, base64Image, mimeType, model = "gemini-2.0-flash"} =
    request.data;

  if (!prompt && !base64Image) {
    throw new HttpsError(
      "invalid-argument",
      "Thiếu nội dung prompt hoặc ảnh."
    );
  }

  const userId = request.auth.uid;
  const today = new Date().toISOString().split("T")[0];

  // Daily quota check: max 10 requests per user per day
  const usageRef = admin
    .firestore()
    .collection("users")
    .doc(userId)
    .collection("aiUsage")
    .doc(today);

  const usageDoc = await usageRef.get();
  const currentCount = usageDoc.data()?.scanCount || 0;

  if (currentCount >= 10) {
    throw new HttpsError(
      "resource-exhausted",
      "Bạn đã dùng hết hạn mức 10 lượt quét AI hôm nay."
    );
  }

  // Build Gemini request body
  const parts: Array<Record<string, unknown>> = [];
  if (base64Image) {
    parts.push({
      inlineData: {
        data: base64Image,
        mimeType: mimeType || "image/jpeg",
      },
    });
  }
  if (prompt) {
    parts.push({text: prompt});
  }

  const url = "https://generativelanguage.googleapis.com/v1beta/models/" +
    `${model}:generateContent?key=${apiKey}`;

  const response = await fetch(url, {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({
      contents: [{parts}],
      generationConfig: {
        temperature: 0.2,
        maxOutputTokens: 2048,
        responseMimeType: "application/json",
      },
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    logger.error("Gemini API error:", errorText);
    throw new HttpsError("internal", `Gemini API error: ${response.status}`);
  }

  const data = await response.json() as {
    candidates?: Array<{
      content?: {
        parts?: Array<{text?: string}>;
      };
    }>;
  };

  const candidateText =
    data?.candidates?.[0]?.content?.parts?.[0]?.text || "";

  // Increment usage count
  await usageRef.set(
    {
      scanCount: admin.firestore.FieldValue.increment(1),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    {merge: true}
  );

  return {text: candidateText};
});
