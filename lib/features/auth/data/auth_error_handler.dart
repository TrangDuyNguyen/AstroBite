import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

/// Chuyển đổi mã lỗi từ Firebase Authentication và Google Sign-In sang thông điệp tiếng Việt thân thiện.
abstract final class AuthErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'user-not-found' => 'Tài khoản không tồn tại. Vui lòng kiểm tra lại email hoặc đăng ký.',
        'wrong-password' => 'Mật khẩu không chính xác. Vui lòng thử lại.',
        'invalid-credential' => 'Email hoặc mật khẩu không chính xác.',
        'invalid-email' => 'Địa chỉ email không đúng định dạng.',
        'email-already-in-use' => 'Email này đã được sử dụng. Vui lòng đăng nhập hoặc dùng email khác.',
        'weak-password' => 'Mật khẩu quá yếu. Vui lòng đặt mật khẩu tối thiểu 6 ký tự.',
        'user-disabled' => 'Tài khoản đã bị tạm khóa. Vui lòng liên hệ hỗ trợ.',
        'too-many-requests' => 'Quá nhiều yêu cầu thất bại. Vui lòng thử lại sau ít phút.',
        'network-request-failed' => 'Lỗi kết nối mạng. Vui lòng kiểm tra lại Internet.',
        'popup-closed-by-user' => 'Thao tác đăng nhập đã được hủy.',
        _ => error.message ?? 'Đã xảy ra lỗi xác thực. Vui lòng thử lại.',
      };
    }
    if (error is PlatformException) {
      if (error.code == 'sign_in_canceled' || error.message?.contains('canceled') == true) {
        return 'Thao tác đăng nhập Google đã được hủy.';
      }
      if (error.code == 'network_error') {
        return 'Lỗi kết nối mạng khi xác thực với Google. Vui lòng thử lại.';
      }
      if (error.code == 'sign_in_failed' || error.message?.contains('10') == true) {
        return 'Đăng nhập Google thất bại. Vui lòng kiểm tra cấu hình tài khoản Google hoặc mạng.';
      }
      return error.message ?? 'Lỗi xác thực hệ thống (${error.code}).';
    }
    if (error is Exception) {
      final msg = error.toString();
      if (msg.startsWith('Exception: ')) {
        return msg.substring(11);
      }
      return msg;
    }
    return error?.toString() ?? 'Đã xảy ra lỗi không xác định.';
  }
}
