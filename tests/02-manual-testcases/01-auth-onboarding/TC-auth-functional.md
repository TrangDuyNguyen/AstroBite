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
  - Hiển thị SnackBar lỗi: *"Email hoặc mật khẩu không chính xác."*
- **Severity**: S2 (Critical)

---

### TC-AUTH-003: Đăng nhập thành công với Email & Password hợp lệ
- **Preconditions**: Tài khoản `qa_test_01@astrobite.io` với mật khẩu `AstroBite@2026` đã được tạo trên hệ thống.
- **Test Steps**:
  1. Tại màn hình Đăng nhập, nhập Email: `qa_test_01@astrobite.io`.
  2. Nhập Password: `AstroBite@2026`.
  3. Nhấn icon con mắt trên trường Password để kiểm tra hiển thị/ẩn mật khẩu.
  4. Nhấn nút "Đăng nhập".
- **Expected Result**:
  - Icon con mắt chuyển đổi trạng thái hiển thị mật khẩu chính xác.
  - Nút Đăng nhập hiển thị vòng xoay loading trong thời gian xử lý.
  - Đăng nhập thành công và điều hướng sang `ShellRoute` (màn hình Dashboard chính).
- **Severity**: S1 (Blocker)

---

### TC-AUTH-004: Đăng nhập thất bại do Email chưa đăng ký (user-not-found)
- **Preconditions**: Email `unregistered_user@astrobite.io` chưa từng đăng ký.
- **Test Steps**:
  1. Nhập Email: `unregistered_user@astrobite.io`.
  2. Nhập Password: `AnyPassword123`.
  3. Nhấn "Đăng nhập".
- **Expected Result**:
  - Hệ thống bắt mã lỗi Firebase và hiển thị SnackBar: *"Tài khoản không tồn tại. Vui lòng kiểm tra lại email hoặc đăng ký mới."* (hoặc thông báo thông tin không chính xác).
- **Severity**: S2 (Critical)

---

### TC-AUTH-005: Đăng nhập thành công bằng Google Sign-In
- **Preconditions**: Thiết bị có Google Play Services hoặc đã đăng nhập tài khoản Google trên hệ thống.
- **Test Steps**:
  1. Tại màn hình Đăng nhập, nhấn nút "Tiếp tục với Google".
  2. Chọn tài khoản Google từ hộp thoại hệ thống.
- **Expected Result**:
  - Quá trình xác thực Google diễn ra thành công.
  - Token được chuyển tiếp vào Firebase Auth `signInWithCredential`.
  - Ứng dụng điều hướng sang màn hình chính.
- **Severity**: S1 (Blocker)

---

### TC-AUTH-006: Người dùng hủy đăng nhập Google (User Cancelled)
- **Preconditions**: Người dùng đang ở màn hình Đăng nhập.
- **Test Steps**:
  1. Nhấn nút "Tiếp tục với Google".
  2. Khi hộp thoại chọn tài khoản hiện lên, nhấn nút back hoặc bấm ra ngoài để hủy.
- **Expected Result**:
  - Ứng dụng không bị crash.
  - Không xuất hiện SnackBar lỗi gây khó chịu cho người dùng.
  - Trạng thái màn hình Đăng nhập vẫn tương tác bình thường.
- **Severity**: S3 (Major)

---

### TC-AUTH-007: Gửi yêu cầu đặt lại mật khẩu thành công (Password Reset)
- **Preconditions**: Email `qa_test_01@astrobite.io` đã tồn tại.
- **Test Steps**:
  1. Nhấn link "Quên mật khẩu?".
  2. Trong hộp thoại hiển thị, nhập email `qa_test_01@astrobite.io`.
  3. Nhấn "Gửi liên kết".
- **Expected Result**:
  - Hộp thoại đóng lại.
  - Hiển thị SnackBar thông báo: *"Đã gửi liên kết đặt lại mật khẩu về email của bạn. Vui lòng kiểm tra hộp thư."*
- **Severity**: S2 (Critical)

