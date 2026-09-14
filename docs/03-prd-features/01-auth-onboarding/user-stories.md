# User Stories & Acceptance Criteria: Auth & Onboarding

## US-01: Đăng Ký Tài Khoản Bằng Email & Mật Khẩu
- **As a**: Người dùng mới
- **I want to**: Đăng ký tài khoản AstroBite bằng địa chỉ email và mật khẩu bảo mật
- **So that**: Tôi có thể lưu trữ và đồng bộ hóa dữ liệu dinh dưỡng cá nhân trên đám mây

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Đăng ký thành công với dữ liệu hợp lệ**
  - **Given**: Tôi đang ở màn hình Đăng ký
  - **When**: Tôi nhập email hợp lệ `user@example.com` và mật khẩu chứa tối thiểu 8 ký tự gồm cả chữ và số
  - **And**: Nhấn nút "Tạo tài khoản"
  - **Then**: Hệ thống tạo tài khoản qua Firebase Auth, gửi email xác thực và chuyển hướng tôi đến màn hình Onboarding Khảo Sát

- **Scenario 2: Đăng ký thất bại do email đã tồn tại**
  - **Given**: Tôi đang ở màn hình Đăng ký
  - **When**: Tôi nhập email đã được đăng ký trước đó
  - **And**: Nhấn nút "Tạo tài khoản"
  - **Then**: Hệ thống hiển thị thông báo lỗi: *"Email này đã được sử dụng. Vui lòng đăng nhập hoặc dùng email khác."*

---

## US-02: Hoàn Thành Khảo Sát Tính Calo & Macro Cá Nhân
- **As a**: Người dùng vừa tạo tài khoản
- **I want to**: Trả lời các câu hỏi khảo sát về chỉ số cơ thể và mức độ vận động
- **So that**: AstroBite tự động tính toán chính xác BMR, TDEE và mục tiêu Calo/Macro hàng ngày cho tôi

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Tính toán mục tiêu giảm cân thành công**
  - **Given**: Tôi là Nam, 28 tuổi, cao 175cm, nặng 80kg, mức vận động "Lightly Active" (PAL 1.375)
  - **When**: Tôi chọn mục tiêu "Giảm cân" và nhấn "Hoàn thành"
  - **Then**: Hệ thống tính BMR = 1774 kcal, TDEE = 2439 kcal, Calorie Target = 1939 kcal (-500 kcal)
  - **And**: Phân bổ Carbs: 218g (45%), Protein: 145g (30%), Fat: 54g (25%)
  - **And**: Lưu trữ hồ sơ vào Firestore `users/{uid}` và chuyển tôi vào Dashboard

---

## US-03: Đăng Nhập Bằng Email & Mật Khẩu
- **As a**: Người dùng đã có tài khoản
- **I want to**: Đăng nhập ứng dụng bằng địa chỉ email và mật khẩu của mình
- **So that**: Tôi có thể truy cập nhật ký dinh dưỡng và dữ liệu cá nhân của mình

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Đăng nhập thành công với thông tin chính xác**
  - **Given**: Tôi đang ở màn hình Đăng nhập
  - **When**: Tôi nhập email hợp lệ đã đăng ký và mật khẩu chính xác
  - **And**: Nhấn nút "Đăng nhập"
  - **Then**: Hệ thống xác thực thành công qua Firebase Auth và điều hướng tôi đến màn hình chính (Dashboard/ShellRoute)

- **Scenario 2: Đăng nhập thất bại do sai mật khẩu hoặc tài khoản không tồn tại**
  - **Given**: Tôi đang ở màn hình Đăng nhập
  - **When**: Tôi nhập sai mật khẩu hoặc nhập email chưa đăng ký
  - **And**: Nhấn nút "Đăng nhập"
  - **Then**: Hệ thống không crash và hiển thị thông báo lỗi tiếng Việt dễ hiểu trên SnackBar: *"Email hoặc mật khẩu không chính xác."*

---

## US-04: Đăng Nhập Nhanh Bằng Tài Khoản Google
- **As a**: Người dùng muốn tiết kiệm thời gian
- **I want to**: Đăng nhập nhanh bằng tài khoản Google (Google Sign-In)
- **So that**: Tôi không cần nhập email và ghi nhớ mật khẩu thủ công

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Đăng nhập Google thành công**
  - **Given**: Tôi đang ở màn hình Đăng nhập
  - **When**: Tôi nhấn nút "Tiếp tục với Google"
  - **And**: Tôi chọn tài khoản Google hợp lệ và cấp quyền
  - **Then**: Hệ thống tạo credential GoogleAuthProvider, đăng nhập vào Firebase Auth và chuyển hướng tôi đến màn hình chính

- **Scenario 2: Người dùng hủy luồng đăng nhập Google**
  - **Given**: Hộp thoại chọn tài khoản Google đang hiển thị
  - **When**: Tôi bấm nút hủy hoặc đóng popup
  - **Then**: Hệ thống giữ nguyên trạng thái tại màn hình Đăng nhập, không phát sinh lỗi crash

---

## US-05: Quên Mật Khẩu & Khôi Phục Tài Khoản Qua Email
- **As a**: Người dùng quên mật khẩu tài khoản
- **I want to**: Yêu cầu liên kết đặt lại mật khẩu gửi về địa chỉ email của mình
- **So that**: Tôi có thể thiết lập mật khẩu mới và tiếp tục sử dụng ứng dụng

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Gửi email đặt lại mật khẩu thành công**
  - **Given**: Tôi đang ở màn hình Đăng nhập
  - **When**: Tôi nhấn "Quên mật khẩu?"
  - **And**: Nhập email `user@example.com` vào hộp thoại và nhấn "Gửi liên kết"
  - **Then**: Hệ thống gọi Firebase Auth gửi email reset password và hiển thị SnackBar thành công: *"Đã gửi liên kết đặt lại mật khẩu về email của bạn. Vui lòng kiểm tra hộp thư."*
