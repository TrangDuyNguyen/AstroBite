# User Stories & Acceptance Criteria: User Profile & Goals

## US-08: Cập Nhật Mục Tiêu Calo & Tỷ Lệ Macro Tùy Chỉnh
- **As a**: Người dùng có chế độ ăn kiêng đặc biệt (Keto hoặc High Protein)
- **I want to**: Điều chỉnh mục tiêu calo và thanh trượt tỷ lệ Carbs/Fat/Protein
- **So that**: Kế hoạch theo dõi calo phù hợp chính xác với phác đồ dinh dưỡng của tôi

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Tùy chỉnh tỷ lệ Macro hợp lệ**
  - **Given**: Tôi đang ở màn hình "Cài đặt Mục tiêu Dinh dưỡng"
  - **When**: Tôi chọn chế độ "High Protein" (Carbs: 35%, Protein: 40%, Fat: 25%)
  - **And**: Nhấn "Lưu thay đổi"
  - **Then**: Hệ thống lưu cấu hình vào Firestore `users/{uid}/goals`
  - **And**: Dashboard lập tức cập nhật lại các thanh MacroBar theo tỷ lệ mới

- **Scenario 2: Báo lỗi khi tổng tỷ lệ khác 100%**
  - **Given**: Tôi nhập thủ công Carbs: 50%, Protein: 40%, Fat: 20% (Tổng = 110%)
  - **When**: Tôi cố gắng nhấn "Lưu thay đổi"
  - **Then**: Nút lưu bị vô hiệu hóa (disabled) và hiển thị cảnh báo: *"Tổng tỷ lệ 3 chất phải bằng 100% (Hiện tại: 110%)"*

---

## US-09: Đăng Xuất An Toàn
- **As a**: Người dùng AstroBite
- **I want to**: Đăng xuất khỏi tài khoản trên thiết bị này
- **So that**: Bảo vệ quyền riêng tư cá nhân khi người khác dùng máy

### Acceptance Criteria (Given - When - Then)
- **Given**: Tôi đang ở màn hình Cài đặt Profile
- **When**: Tôi nhấn nút "Đăng xuất" và xác nhận trên hộp thoại cảnh báo
- **Then**: Firebase Auth thực hiện `signOut()`, xóa cache phiên làm việc trên máy
- **And**: Ứng dụng điều hướng về WelcomeScreen
