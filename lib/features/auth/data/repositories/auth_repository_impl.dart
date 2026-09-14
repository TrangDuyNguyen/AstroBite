import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({AuthRemoteDatasource? remoteDatasource})
      : _remoteDatasource = remoteDatasource ?? AuthRemoteDatasource();

  final AuthRemoteDatasource _remoteDatasource;

  @override
  Stream<User?> get authStateChanges => _remoteDatasource.authStateChanges;

  @override
  User? get currentUser => _remoteDatasource.currentUser;

  @override
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _remoteDatasource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) {
    return _remoteDatasource.registerWithEmail(email: email, password: password);
  }

  @override
  Future<UserCredential?> signInWithGoogle() {
    return _remoteDatasource.signInWithGoogle();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _remoteDatasource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() {
    return _remoteDatasource.signOut();
  }
}
