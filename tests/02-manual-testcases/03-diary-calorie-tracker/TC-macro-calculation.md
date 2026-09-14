# Testcases Tính Toán & Cảnh Báo Vượt Calo (Macro Calculation Testcases)

- **Module**: `03-diary-calorie-tracker`
- **Tham chiếu BA**: `docs/03-prd-features/03-diary-calorie-tracker/user-stories.md` (US-04)

---

### TC-MAC-001: Hiển thị cảnh báo khi tổng calo nạp vào vượt quá mục tiêu (Over Budget)
- **Preconditions**: Mục tiêu calo hàng ngày = `2,000 kcal`.
- **Test Steps**:
  1. Ghi nhận các món ăn sao cho tổng calo đạt `2,150 kcal` (vượt 150 kcal).
  2. Quan sát màu sắc và thông báo trên CalorieProgressArc và viền thẻ `DailySummaryCard`.
- **Expected Result**:
  - Vòng cung không bị gãy hay tràn layout UI.
  - Vòng cung và viền ngoài thẻ `DailySummaryCard` chuyển sang màu cảnh báo Vàng Tertiary `#FFD700`.
  - Dòng chữ chính giữa hiển thị số calo vượt: `+150 kcal` và nhãn `vượt mục tiêu`.
- **Severity**: S1 (Blocker)

---

### TC-MAC-002: Hiển thị tiến trình calo và đa lượng bình thường (Within Budget)
- **Preconditions**: Mục tiêu calo hàng ngày = `2,000 kcal`.
- **Test Steps**:
  1. Ghi nhận Bữa Sáng (500 kcal, 25g protein, 60g carbs, 15g fat) và Bữa Trưa (700 kcal, 35g protein, 85g carbs, 20g fat).
  2. Quan sát hiển thị trên Dashboard.
- **Expected Result**:
  - Tổng calo tiêu thụ: `1,200 kcal`, calo còn lại: `800 kcal`.
  - Dòng chữ chính giữa hiển thị: `800 kcal` và nhãn `còn lại` với màu xanh Primary `#1A73E8`.
  - Viền thẻ `DailySummaryCard` giữ viền mờ mặc định.
  - 3 thanh MacroBar hiển thị chính xác lượng gram và tỷ lệ tiến trình tương ứng:
    - Đạm (Protein): 60g / 150g (🟡 `#FFD700`)
    - Tinh bột (Carbs): 145g / 250g (🔵 `#1A73E8`)
    - Chất béo (Fat): 35g / 44g (🩷 `#FF69B4`)
- **Severity**: S2 (Critical)

---

### TC-MAC-003: Đồng bộ mục tiêu calo từ hồ sơ người dùng (UserProfile)
- **Preconditions**: Người dùng đã hoàn thành Onboarding với mục tiêu tính toán là `1,850 kcal`.
- **Test Steps**:
  1. Mở màn hình Dashboard Tổng quan hôm nay.
  2. Kiểm tra mục tiêu calo trong thẻ tổng kết.
- **Expected Result**:
  - Mục tiêu calo hiển thị là `1,850 kcal` (thay vì giá trị mặc định 2000).
  - Mục tiêu các chất đa lượng (Protein, Carbs, Fat) được tính toán tương ứng theo tỷ lệ dinh dưỡng của 1,850 kcal.
- **Severity**: S2 (Critical)
