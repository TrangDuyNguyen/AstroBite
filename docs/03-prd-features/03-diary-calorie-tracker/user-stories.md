# User Stories & Acceptance Criteria: Diary & Calorie Tracker

## US-04: Xem Dashboard Tiến Trình Calo Trong Ngày
- **As a**: Người dùng AstroBite
- **I want to**: Xem vòng cung tiến trình calo và thanh tỷ lệ dinh dưỡng trên màn hình chính
- **So that**: Tôi biết mình còn được nạp bao nhiêu calo trước khi kết thúc ngày

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Hiển thị tiến trình calo bình thường**
  - **Given**: Mục tiêu calo trong hồ sơ của tôi là 2000 kcal
  - **When**: Tôi đã ghi nhận Bữa Sáng (500 kcal) và Bữa Trưa (700 kcal)
  - **Then**: Vòng cung tiến trình hiển thị tiêu thụ 1200 / 2000 kcal (60%)
  - **And**: Con số trung tâm hiển thị: `800 kcal` và nhãn `còn lại` với màu xanh Primary `#1A73E8`
  - **And**: Viền thẻ `DailySummaryCard` không kích hoạt viền cảnh báo

- **Scenario 2: Cảnh báo khi vượt calo tiêu thụ**
  - **Given**: Tôi đã nạp 2150 kcal trên hạn mức 2000 kcal
  - **When**: Tôi mở Dashboard Tổng quan hôm nay
  - **Then**: Con số trung tâm hiển thị: `+150 kcal` và nhãn `vượt mục tiêu`
  - **And**: Vòng cung tiến trình và viền ngoài thẻ `DailySummaryCard` chuyển sang màu cảnh báo Vàng Tertiary `#FFD700`

---

## US-05: Xóa Món Ăn Đã Ghi Nhận Trong Nhật Ký
- **As a**: Người dùng
- **I want to**: Vuốt sang trái để xóa một món ăn tôi ghi nhận nhầm
- **So that**: Số calo trong ngày không bị sai lệch

### Acceptance Criteria (Given - When - Then)
- **Given**: Món "Bánh mì ốp la" (350 kcal) đang nằm trong Bữa Sáng
- **When**: Tôi vuốt món ăn sang trái (Swipe-to-delete)
- **Then**: Một hộp thoại xác nhận hiển thị với câu hỏi: *"Bạn có chắc muốn xóa món này khỏi bữa ăn?"*
- **When**: Tôi nhấn nút "Xóa" trên hộp thoại
- **Then**: Món ăn biến mất khỏi danh sách Bữa Sáng
- **And**: Tổng calo bữa sáng giảm 350 kcal, calo còn lại trong ngày tăng thêm 350 kcal ngay lập tức mà không cần tải lại màn hình
- **And**: Một thông báo SnackBar hiển thị: *"Đã xóa món Bánh mì ốp la"*

---

## US-06: Chuyển Đổi Ngày Trên Thanh Lịch (Date Picker Strip)
- **As a**: Người dùng
- **I want to**: Chọn các ngày khác nhau trên thanh lịch cuộn ngang
- **So that**: Tôi xem lại lịch sử ăn uống của các ngày trước hoặc chuẩn bị cho ngày sau

### Acceptance Criteria (Given - When - Then)
- **Given**: Tôi đang ở màn hình Tổng quan hôm nay
- **When**: Tôi quan sát thanh Date Picker Strip ở phía trên cùng
- **Then**: Ngày hiện tại hiển thị nhãn phụ *"Hôm nay"* và được highlight nổi bật
- **When**: Tôi nhấn vào một ngày khác trong quá khứ
- **Then**: Ngày đó được đánh dấu là đang chọn với nền phát sáng `AppColors.primary`
- **And**: Dữ liệu calo và danh sách 4 bữa ăn lập tức chuyển sang dữ liệu của ngày được chọn
