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
