# Đặc Tả Giao Diện (UI/UX Screen Specs): Diary & Calorie Tracker

## 1. Danh Sách Màn Hình & Widgets
- `SCR-08`: TrackerDashboardScreen / HomePage (Màn hình chính Tổng quan hôm nay)
- `COMP-04`: CalorieProgressArc (Vòng cung bán nguyệt tiến trình calo)
- `COMP-05`: MacroBarGroup (Bộ 3 thanh tiến trình Carbs, Fat, Protein)
- `COMP-06`: MealSectionCard (Thẻ nhóm bữa ăn: Sáng, Trưa, Tối, Phụ)
- `COMP-07`: DatePickerStrip (Thanh chọn ngày ngang cuộn mượt)
- `SCR-09`: ManualAddFoodDialog / ManualEntryPage (Màn hình nhập món thủ công)

---

## 2. Quy Chuẩn Đồ Họa & Tương Tác (Celestial Dark UI)

### 2.1 Thanh Chọn Ngày (`COMP-07: DatePickerStrip`)
- **Vị trí**: Nằm ngay dưới AppBar và trên `DailySummaryCard`.
- **Thiết kế**: Danh sách ngày cuộn ngang, mỗi item gồm thứ (T2, T3... / CN) và ngày (1-31).
- **Ngày được chọn**: Nền bo góc `AppColors.primary` (`#1A73E8`), đổ bóng mờ xanh neon nhẹ.
- **Ngày hiện tại (Today)**: Đánh dấu chấm xanh hoặc text nhỏ "Hôm nay".
- **Kích thước chạm**: Tối thiểu 44x44pt.

### 2.2 Thẻ Tiến Trình Calo (`DailySummaryCard` & `COMP-04`, `COMP-05`)
- **Nền thẻ**: `GlassCard` với `AppColors.surfaceBlur` (`0x99192A46`), backdrop filter blur 20.
- **Trạng thái bình thường**: Viền mờ `AppColors.outline.withValues(alpha: 0.3)`. Vòng cung xanh `AppColors.primary`.
- **Trạng thái vượt calo**: Viền thẻ đổi sang màu Vàng `AppColors.tertiary.withValues(alpha: 0.8)`. Vòng cung phát sáng màu Vàng `AppColors.tertiary`. Text trung tâm hiển thị: `+X kcal` (headlineMedium) và `vượt mục tiêu` (labelMedium).
- **Các thanh MacroBar**:
  - Đạm (Protein): `AppColors.tertiary` (`#FFD700`).
  - Tinh bột (Carbs): `AppColors.primary` (`#1A73E8`).
  - Chất béo (Fat): `AppColors.secondary` (`#FF69B4`).

### 2.3 Thẻ Bữa Ăn (`COMP-06: MealSectionCard`)
- **Nền**: `AppColors.surfaceContainer` (`#112240`), bo góc 12pt, elevation 0.
- **Tiêu đề bữa ăn**: Biểu tượng Emoji (🌅 Sáng, ☀️ Trưa, 🌙 Tối, 🍪 Phụ) + Tên bữa ăn + Tổng calo bữa.
- **Nút thêm nhanh `+`**: Biểu tượng `Icons.add_circle_outline`, touch target 44x44pt.
- **Mỗi món ăn trong danh sách**:
  - Tên món + khối lượng (g) bên trái, calo (`letterSpacing: 0.5`) bên phải.
  - Vuốt sang trái (`Dismissible`): Nền đỏ xóa `AppColors.error` (`#CF6679` / `#EF4444`) với icon thùng rác màu trắng.
  - Hộp thoại xác nhận `AlertDialog`: Tiêu đề "Xác nhận xóa", nội dung "Bạn có chắc muốn xóa món này khỏi bữa ăn?", nút "Hủy" và nút "Xóa" (`AppColors.error`).

### 2.4 Màn Hình Nhập Món Thủ Công (`SCR-09: ManualEntryPage`)
- **AppBar**: Tiêu đề "Nhập tay", nút Back quay về nếu mở từ Push Route, nút Action "Thêm tùy chỉnh" (`Icons.add_box_outlined`).
- **Thanh chọn Bữa ăn**: Dùng `MealTypeChip` (Sáng, Trưa, Tối, Phụ). Tự động active chip dựa vào `initialMealType` hoặc giờ trong ngày.
- **Thanh tìm kiếm (`FoodSearchBar`)**: Bo góc 12pt, icon tìm kiếm, placeholder "Tìm món ăn (Phở, Cơm tấm, Bánh mì...)", hỗ trợ clear text.
- **Danh sách món gợi ý**:
  - Thẻ `Card` nền `AppColors.surfaceContainer`, viền mảnh `AppColors.outline.withValues(alpha: 0.2)`.
  - Icon món / emoji minh họa.
  - Tên món (titleMedium, đậm), phụ đề hiển thị khẩu phần mặc định và lượng calo (`Xg • Y kcal`).
  - Nút chọn/chỉnh khẩu phần hoặc nút thêm nhanh.
- **Bảng điều chỉnh khẩu phần (Portion Scaling Sheet/Card)**:
  - Khi người dùng nhấn vào món ăn: Hiển thị bộ điều chỉnh khối lượng với Slider 50g - 1000g.
  - Hiển thị tức thì Calo (headlineMedium màu `AppColors.primary`) và 3 thẻ Macro (Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`).
  - Nút `FilledButton` lớn: "Lưu vào [Tên bữa ăn] (X kcal)" chiều cao tối thiểu 48pt.
- **Modal Thêm Món Tùy Chỉnh (`CustomFoodSheet`)**:
  - `showModalBottomSheet` với bo góc trên 24pt, nền `AppColors.surfaceContainer`.
  - Các ô nhập liệu `TextFormField` với styling Dark Celestial:
    - Tên món ăn (text, autofocus).
    - Khối lượng (gram - number).
    - Năng lượng (calo / kcal - number).
    - Bộ 3 trường đạm, carbs, fat (hàng ngang 3 cột gọn gàng).
  - Nút "Thêm vào nhật ký" kiểm tra form validation và lưu tức thì.
