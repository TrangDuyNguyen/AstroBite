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

---

## US-07: Tra Cứu & Ghi Nhận Món Ăn Có Sẵn Trong Danh Bạ
- **As a**: Người dùng AstroBite
- **I want to**: Tìm kiếm món ăn Việt Nam quen thuộc và ghi nhận nhanh vào nhật ký
- **So that**: Tôi không mất thời gian tự nhập lại các thông số calo và dinh dưỡng cơ bản

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Tìm kiếm món ăn thành công qua từ khóa**
  - **Given**: Tôi đang ở màn hình "Nhập tay" và đã chọn bữa ăn "Bữa trưa"
  - **When**: Tôi nhập từ khóa "phở" vào ô tìm kiếm
  - **Then**: Danh sách hiển thị các món chứa từ khóa như "Phở bò", "Phở gà"
  - **And**: Mỗi thẻ hiển thị tên món, khối lượng mặc định và lượng calo tương ứng

- **Scenario 2: Lưu món ăn từ danh sách vào bữa ăn**
  - **Given**: Tôi chọn món "Phở bò" (350g, 450 kcal)
  - **When**: Tôi nhấn nút "Lưu vào Bữa trưa"
  - **Then**: Hệ thống tạo bản ghi mới trên Firestore với `mealType: "lunch"`, `source: "manual_entry"`
  - **And**: SnackBar thông báo hiển thị: *"Đã lưu Phở bò vào Bữa trưa"*
  - **And**: Màn hình chính Dashboard cập nhật tổng calo Bữa trưa tăng thêm 450 kcal

---

## US-08: Điều Chỉnh Khẩu Phần Gram Tự Động Tính Macro
- **As a**: Người dùng đang theo dõi chế độ ăn nghiêm ngặt
- **I want to**: Kéo thanh trượt để thay đổi số gram món ăn tôi thực tế nạp vào
- **So that**: Lượng calo, tinh bột, chất đạm và chất béo được tính toán chính xác theo tỷ lệ

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Tăng giảm số gram theo thanh trượt**
  - **Given**: Tôi đã chọn món "Ức gà áp chảo" (gốc 100g, 165 kcal, 31g protein, 0g carbs, 3.6g fat)
  - **When**: Tôi kéo slider khẩu phần từ 100g lên 200g
  - **Then**: Khối lượng hiển thị cập nhật là 200g
  - **And**: Calo hiển thị tự động tăng lên 330 kcal
  - **And**: Đạm (Protein) tăng lên 62g, Chất béo (Fat) tăng lên 7.2g (hoặc 7g làm tròn)
  - **And**: Nhãn nút lưu hiển thị: *"Lưu vào Bữa ăn (330 kcal)"*

---

## US-09: Thêm Món Ăn Mới Tùy Chỉnh (Custom Food)
- **As a**: Người dùng tự nấu ăn hoặc ăn món lạ không có trong danh bạ
- **I want to**: Tự nhập tên món, khối lượng gram, calo và các chỉ số đa lượng
- **So that**: Tôi vẫn ghi nhận được đầy đủ nhật ký dinh dưỡng của mình

### Acceptance Criteria (Given - When - Then)
- **Scenario 1: Nhập món tùy chỉnh với dữ liệu hợp lệ**
  - **Given**: Tôi nhấn nút "Thêm món tùy chỉnh"
  - **When**: Tôi điền Tên món: "Salad cá hồi quả bơ", Khối lượng: 250g, Calo: 380 kcal, Protein: 22g, Carbs: 10g, Fat: 28g
  - **And**: Tôi nhấn "Thêm vào bữa ăn"
  - **Then**: Món ăn mới được ghi nhận vào Firestore với `source: "manual_entry"`
  - **And**: SnackBar thông báo: *"Đã lưu Salad cá hồi quả bơ vào Bữa ăn"*

- **Scenario 2: Kiểm tra tính hợp lệ dữ liệu (Validation)**
  - **Given**: Tôi để trống ô Tên món hoặc nhập Calo mang giá trị âm
  - **When**: Tôi cố gắng nhấn nút "Thêm vào bữa ăn"
  - **Then**: Hệ thống hiển thị thông báo lỗi yêu cầu điền đầy đủ tên món và calo hợp lệ
  - **And**: Không có dữ liệu nào được lưu lên Firestore

