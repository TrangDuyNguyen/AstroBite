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
