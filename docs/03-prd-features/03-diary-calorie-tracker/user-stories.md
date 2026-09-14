# User Stories & Acceptance Criteria: Diary & Calorie Tracker

## US-04: Xem Dashboard Tiến Trình Calo Trong Ngày
- **As a**: Người dùng AstroBite
- **I want to**: Xem vòng cung tiến trình calo và thanh tỷ lệ dinh dưỡng trên màn hình chính
- **So that**: Tôi biết mình còn được nạp bao nhiêu calo trước khi kết thúc ngày

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Hiển thị tiến trình calo bình thường**
  - **Given**: Mục tiêu calo của tôi là 2000 kcal
  - **When**: Tôi đã ghi nhận Bữa Sáng (500 kcal) và Bữa Trưa (700 kcal)
  - **Then**: Vòng cung tiến trình hiển thị tiêu thụ 1200 / 2000 kcal (60%)
  - **And**: Con số trung tâm hiển thị: *"Còn lại: 800 kcal"* với màu xanh Primary `#1A73E8`

- **Scenario 2: Cảnh báo khi vượt calo tiêu thụ**
  - **Given**: Tôi đã nạp 2150 kcal trên hạn mức 2000 kcal
  - **When**: Tôi mở Dashboard
  - **Then**: Con số hiển thị: *"+150 kcal vượt mục tiêu"*
  - **And**: Vòng cung tiến trình và viền thẻ chuyển sang màu cảnh báo Vàng Tertiary `#FFD700`

---

## US-05: Xóa Món Ăn Đã Ghi Nhận Trong Nhật Ký
- **As a**: Người dùng
- **I want to**: Vuốt để xóa một món ăn tôi ghi nhận nhầm
- **So that**: Số calo trong ngày không bị sai lệch

### Acceptance Criteria (Given - When - Then)
- **Given**: Món "Bánh mì ốp la" (350 kcal) đang nằm trong Bữa Sáng
- **When**: Tôi vuốt món ăn sang trái (Swipe-to-delete) và xác nhận xóa
- **Then**: Món ăn biến mất khỏi danh sách Bữa Sáng
- **And**: Tổng calo bữa sáng giảm 350 kcal, calo còn lại trong ngày tăng thêm 350 kcal ngay lập tức mà không cần tải lại màn hình
