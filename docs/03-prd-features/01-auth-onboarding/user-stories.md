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
- **Scenario 1: Đăng nhập thành công với tài khoản đã hoàn thành onboarding**
  - **Given**: Tôi đang ở màn hình Đăng nhập và tài khoản của tôi đã có `is_onboarding_completed = true`
  - **When**: Tôi nhập email hợp lệ đã đăng ký và mật khẩu chính xác
  - **And**: Nhấn nút "Đăng nhập"
  - **Then**: Hệ thống xác thực thành công qua Firebase Auth và điều hướng tôi đến màn hình chính (Dashboard/ShellRoute)

- **Scenario 2: Đăng nhập thành công với tài khoản chưa hoàn thành onboarding**
  - **Given**: Tôi đang ở màn hình Đăng nhập và tài khoản của tôi có `is_onboarding_completed = false`
  - **When**: Tôi nhập email hợp lệ và mật khẩu chính xác
  - **And**: Nhấn nút "Đăng nhập"
  - **Then**: Hệ thống xác thực thành công và điều hướng tôi đến màn hình khảo sát `/onboarding`

- **Scenario 3: Đăng nhập thất bại do sai mật khẩu hoặc tài khoản không tồn tại**
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
- **Scenario 1: Đăng nhập Google thành công với người dùng mới**
  - **Given**: Tôi chưa có hồ sơ người dùng trong Firestore
  - **When**: Tôi nhấn nút "Tiếp tục với Google" và cấp quyền
  - **Then**: Hệ thống xác thực Firebase Auth, khởi tạo tài khoản và điều hướng tôi đến màn hình `/onboarding` (Bước 1)

- **Scenario 2: Đăng nhập Google thành công với người dùng cũ**
  - **Given**: Tôi đã từng hoàn thành khảo sát với `is_onboarding_completed = true`
  - **When**: Tôi nhấn nút "Tiếp tục với Google" và cấp quyền
  - **Then**: Hệ thống xác thực thành công và điều hướng tôi vào thẳng Dashboard (ShellRoute)

- **Scenario 3: Người dùng hủy luồng đăng nhập Google**
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

---

## US-06: Hoàn Tất Khảo Sát & Khôi Phục Phiên Bỏ Dở (Onboarding Persistence & Drop-off Recovery)
- **As a**: Người dùng đang thực hiện khảo sát thể trạng
- **I want to**: Tiến trình khảo sát được lưu tạm và dữ liệu tính toán được kích hoạt khi hoàn thành
- **So that**: Tôi không bị mất thông tin nếu bị ngắt quãng và nhận được mục tiêu dinh dưỡng cá nhân chuẩn y khoa

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Khôi phục phiên khảo sát dở dang sau khi đăng nhập lại**
  - **Given**: Tôi đã hoàn thành tới Bước 3 nhưng tắt ứng dụng
  - **When**: Tôi mở lại ứng dụng và đăng nhập thành công
  - **Then**: Hệ thống tự động mở lại màn hình `/onboarding` tại Bước 3 với các dữ liệu trước đó được giữ nguyên

- **Scenario 2: Hoàn tất khảo sát và kích hoạt tài khoản thành công**
  - **Given**: Tôi đang ở màn hình tóm tắt mục tiêu `/onboarding/summary`
  - **When**: Tôi nhấn nút "Bắt đầu hành trình"
  - **Then**: Hệ thống ghi đè thông tin hồ sơ lên Firestore với `is_onboarding_completed = true`
  - **And**: Chuyển hướng toàn bộ sang Dashboard (ShellRoute) và hiển thị chỉ số Calorie Target chính xác

