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
