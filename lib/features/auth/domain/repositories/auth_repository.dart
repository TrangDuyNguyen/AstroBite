import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  });

  Future<UserCredential?> signInWithGoogle();

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();
}

