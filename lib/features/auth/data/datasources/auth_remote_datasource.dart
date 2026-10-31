import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _providedAuth = auth,
        _providedGoogleSignIn = googleSignIn;

  final FirebaseAuth? _providedAuth;
  final GoogleSignIn? _providedGoogleSignIn;

  FirebaseAuth? get _auth {
    if (_providedAuth != null) return _providedAuth;
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  GoogleSignIn get _googleSignIn =>
      _providedGoogleSignIn ??
      GoogleSignIn(
        clientId: (!kIsWeb && Platform.isIOS)
            ? '925552313324-he3hov1bd7o5u3h2egigtmhfd4t8s5cd.apps.googleusercontent.com'
            : null,
        serverClientId:
            '925552313324-nge0ljq0ug1attkt02k49o7vqfvdeujd.apps.googleusercontent.com',
      );

  Stream<User?> get authStateChanges =>
      _auth?.authStateChanges() ?? const Stream.empty();
  User? get currentUser {
    try {
      return _auth?.currentUser;
    } catch (_) {
      return null;
    }
  }

  FirebaseAuth get _client {
    final client = _auth;
    if (client == null) {
      throw FirebaseException(
        plugin: 'auth',
        code: 'no-app',
        message: 'Firebase Auth is not initialized or unavailable',
      );
    }
    return client;
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null && googleAuth.accessToken == null) {
        throw Exception('Không nhận được token xác thực từ Google. Vui lòng thử lại.');
      }
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _client.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('sign_in_canceled') || e.toString().contains('canceled')) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _client.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await Future.wait([
      _client.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
