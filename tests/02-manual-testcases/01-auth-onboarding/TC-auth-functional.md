# Testcases Chức Năng Xác Thực (Auth Functional Testcases)

- **Module**: `01-auth-onboarding`
- **Tham chiếu BA**: `docs/03-prd-features/01-auth-onboarding/user-stories.md` (US-01)
- **Người thực hiện**: QA Team

---

### TC-AUTH-001: Đăng ký tài khoản mới bằng Email hợp lệ
- **Preconditions**: Thiết bị có kết nối Internet, email `qa_test_01@astrobite.io` chưa từng đăng ký.
- **Test Steps**:
  1. Mở app AstroBite, tại WelcomeScreen nhấn "Bắt đầu ngay".
  2. Nhập Email: `qa_test_01@astrobite.io`.
  3. Nhập Password: `AstroBite@2026` (Đạt chuẩn 8 ký tự, có hoa, thường, số, ký tự đặc biệt).
  4. Nhập Confirm Password: `AstroBite@2026`.
  5. Nhấn nút "Tạo tài khoản".
- **Expected Result**:
  - Hệ thống tạo tài khoản thành công trên Firebase Authentication.
  - Hiển thị thông báo chào mừng và điều hướng mượt mà sang bước Onboarding 1 (Chọn giới tính).
- **Severity**: S1 (Blocker)

---

### TC-AUTH-002: Đăng nhập thất bại khi sai mật khẩu
- **Preconditions**: Tài khoản `qa_test_01@astrobite.io` đã tồn tại trên hệ thống.
- **Test Steps**:
  1. Tại màn hình Đăng nhập, nhập Email: `qa_test_01@astrobite.io`.
  2. Nhập Password sai: `WrongPass123`.
  3. Nhấn "Đăng nhập".
- **Expected Result**:
  - Ứng dụng không bị crash.
  - Hiển thị SnackBar lỗi màu đỏ: *"Email hoặc mật khẩu không chính xác. Vui lòng thử lại."*
- **Severity**: S2 (Critical)
