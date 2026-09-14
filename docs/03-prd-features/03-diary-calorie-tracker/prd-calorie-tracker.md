# PRD: Nhật Ký Dinh Dưỡng & Theo Dõi Calo (Diary & Calorie Tracker)

- **Mã tính năng**: `FEAT-03`
- **Bộ phận phụ trách**: BA Team
- **Trạng thái**: Approved
- **Đối chiếu QA**: `tests/02-manual-testcases/03-diary-calorie-tracker/` & `tests/03-bdd-gherkin-scenarios/calorie_diary.feature`
- **Đối chiếu FE**: `lib/features/tracker/`

---

## 1. Mục Tiêu Nghiệp Vụ
Là màn hình Dashboard chính (Home) của ứng dụng AstroBite (`HomePage` / `SCR-08`), giúp người dùng nắm bắt trong tích tắc:
- **Thanh lịch chọn ngày (Date Picker Strip)**: Duyệt xem nhật ký các ngày trong tuần, làm nổi bật ngày hiện tại ("Hôm nay") với màu phát sáng `AppColors.primary`.
- **Tiến trình calo**: Tổng calo mục tiêu trong ngày (đồng bộ từ Hồ sơ cá nhân `UserProfile.dailyTargetCalories`, mặc định 2000 kcal), số calo đã nạp và số calo còn lại (Remaining Budget).
- **Phân bổ đa lượng (Macronutrients)**: Tỷ lệ nạp vào thực tế của 3 chỉ số Đạm (Protein 🟡 `#FFD700`), Tinh bột (Carbs 🔵 `#1A73E8`), Chất béo (Fat 🩷 `#FF69B4`) so với mục tiêu.
- **Nhật ký 4 bữa ăn**: Bữa Sáng (Breakfast), Bữa Trưa (Lunch), Bữa Tối (Dinner), Bữa Phụ (Snacks).

---

## 2. Quy Tắc Nghiệp Vụ & Hiển Thị

### 2.1 Tính Toán Calo & Trạng Thái Vượt Mức (Over Budget)
- `Calo còn lại = Mục tiêu calo hàng ngày - Tổng calo các bữa ăn đã ghi nhận`.
- **Trạng thái bình thường (`Tổng calo <= Mục tiêu`)**:
  - Vòng cung `CalorieProgressArc` hiển thị màu xanh Primary `#1A73E8`.
  - Trung tâm hiển thị: `X kcal` và nhãn `còn lại`.
  - Viền thẻ `DailySummaryCard` giữ viền mờ tiêu chuẩn.
- **Trạng thái cảnh báo vượt hạn mức (`Tổng calo > Mục tiêu`)**:
  - Vòng cung `CalorieProgressArc` và viền ngoài thẻ `DailySummaryCard` chuyển sang màu cảnh báo Vàng Tertiary `#FFD700`.
  - Trung tâm hiển thị: `+X kcal` và nhãn `vượt mục tiêu` (với X = Tổng calo - Mục tiêu).

### 2.2 Xóa Món Ăn (Swipe-to-delete)
- Người dùng vuốt món ăn sang trái (`DismissDirection.endToStart`).
- Hiển thị nền đỏ xóa `AppColors.error` (`#EF4444`) cùng biểu tượng thùng rác.
- Hiển thị Popup xác nhận: *"Bạn có chắc muốn xóa món này khỏi bữa ăn?"*.
- Khi xác nhận: Gọi xóa trên Firestore, cập nhật tổng calo và dinh dưỡng tức thì theo thời gian thực (Real-time stream) mà không cần reload trang.

### 2.3 Thêm Món Ăn Nhanh
- Mỗi thẻ bữa ăn có nút thêm `+` (touch target >= 44x44pt) điều hướng đến màn hình Nhập tay (`ManualEntryRoute`) với danh mục bữa ăn tương ứng.
