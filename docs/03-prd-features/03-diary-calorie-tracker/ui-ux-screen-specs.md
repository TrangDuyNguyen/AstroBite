# Đặc Tả Giao Diện (UI/UX Screen Specs): Diary & Calorie Tracker

## 1. Danh Sách Màn Hình & Widgets
- `SCR-08`: TrackerDashboardScreen (`/dashboard`)
- `COMP-04`: CalorieProgressArc (Vòng cung bán nguyệt tiến trình calo)
- `COMP-05`: MacroBarGroup (Bộ 3 thanh tiến trình Carbs, Fat, Protein)
- `COMP-06`: MealSectionCard (Thẻ nhóm bữa ăn: Sáng, Trưa, Tối, Phụ)
- `SCR-09`: ManualAddFoodDialog (Dialog nhập món thủ công kèm tìm kiếm)

---

## 2. Quy Chuẩn Đồ Họa & Tương Tác
- **Thẻ Bữa Ăn (MealSectionCard)**: Nền `AppColors.surfaceContainer` (`#112240`), bo góc 20pt, có nút thêm nhanh `+` (touch target 44x44pt).
- **Thanh MacroBar**: Chiều cao 8pt, nền tối `#1E293B`, thanh màu động có hiệu ứng chuyển sắc (Smooth animation curve `Curves.easeOutCubic`).
- **Lịch Chọn Ngày (Date Picker Strip)**: Thanh ngang cuộn ngày ở trên cùng với ngày hiện tại được highlight phát sáng màu xanh `#1A73E8`.
