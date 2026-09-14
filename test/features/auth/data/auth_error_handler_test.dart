import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/auth/data/auth_error_handler.dart';

void main() {
  group('AuthErrorHandler', () {
    test('maps user-not-found to friendly Vietnamese message', () {
      final error = FirebaseAuthException(code: 'user-not-found');
      final msg = AuthErrorHandler.getErrorMessage(error);
      expect(msg, contains('Tài khoản không tồn tại'));
    });

    test('maps wrong-password to friendly Vietnamese message', () {
      final error = FirebaseAuthException(code: 'wrong-password');
      final msg = AuthErrorHandler.getErrorMessage(error);
      expect(msg, contains('Mật khẩu không chính xác'));
    });

    test('maps invalid-credential to friendly Vietnamese message', () {
      final error = FirebaseAuthException(code: 'invalid-credential');
      final msg = AuthErrorHandler.getErrorMessage(error);
      expect(msg, contains('Email hoặc mật khẩu không chính xác'));
    });

    test('maps too-many-requests to friendly Vietnamese message', () {
      final error = FirebaseAuthException(code: 'too-many-requests');
      final msg = AuthErrorHandler.getErrorMessage(error);
      expect(msg, contains('Quá nhiều yêu cầu'));
    });

    test('maps network-request-failed to friendly Vietnamese message', () {
      final error = FirebaseAuthException(code: 'network-request-failed');
      final msg = AuthErrorHandler.getErrorMessage(error);
      expect(msg, contains('Lỗi kết nối mạng'));
    });

    test('maps popup-closed-by-user to friendly Vietnamese message', () {
      final error = FirebaseAuthException(code: 'popup-closed-by-user');
      final msg = AuthErrorHandler.getErrorMessage(error);
      expect(msg, contains('đã được hủy'));
    });

    test('handles standard Exception gracefully', () {
      final error = Exception('Lỗi hệ thống');
      final msg = AuthErrorHandler.getErrorMessage(error);
      expect(msg, equals('Lỗi hệ thống'));
    });

    test('handles unknown error string', () {
      final msg = AuthErrorHandler.getErrorMessage('Lỗi ngẫu nhiên');
      expect(msg, equals('Lỗi ngẫu nhiên'));
    });
  });
}
