import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Dịch vụ quản lý thông báo đẩy Firebase Cloud Messaging (FCM) — ASTRO-021
class PushNotificationService {
  final FirebaseMessaging? _messaging;
  final FirebaseFirestore? _firestore;

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;

  PushNotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? _safeGetMessaging(),
        _firestore = firestore ?? _safeGetFirestore();

  static FirebaseMessaging? _safeGetMessaging() {
    try {
      return FirebaseMessaging.instance;
    } catch (e) {
      debugPrint('[PushNotificationService] FirebaseMessaging not available: $e');
      return null;
    }
  }

  static FirebaseFirestore? _safeGetFirestore() {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      debugPrint('[PushNotificationService] FirebaseFirestore not available: $e');
      return null;
    }
  }

  /// Khởi tạo FCM: xin quyền thông báo, lấy token và đồng bộ lên Firestore
  Future<String?> initialize({required String userId}) async {
    final messaging = _messaging;
    if (messaging == null) return null;

    try {
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[PushNotificationService] Permission denied by user');
        return null;
      }

      final token = await messaging.getToken();
      if (token != null && userId.isNotEmpty) {
        await syncTokenToFirestore(userId: userId, token: token);
      }

      _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = messaging.onTokenRefresh.listen((newToken) {
        if (userId.isNotEmpty) {
          syncTokenToFirestore(userId: userId, token: newToken);
        }
      });

      _messageSubscription?.cancel();
      _messageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[PushNotificationService] Foreground message received: ${message.notification?.title}');
      });

      return token;
    } catch (e) {
      debugPrint('[PushNotificationService] Initialization error: $e');
      return null;
    }
  }

  /// Lưu token vào Firestore document của user
  Future<void> syncTokenToFirestore({
    required String userId,
    required String token,
  }) async {
    final firestore = _firestore;
    if (firestore == null || userId.isEmpty || token.isEmpty) return;

    try {
      await firestore.collection('users').doc(userId).set({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[PushNotificationService] Failed to sync token to Firestore: $e');
    }
  }

  void dispose() {
    _tokenRefreshSubscription?.cancel();
    _messageSubscription?.cancel();
  }
}

