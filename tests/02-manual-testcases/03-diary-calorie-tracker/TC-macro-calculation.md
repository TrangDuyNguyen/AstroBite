# Testcases Tính Toán & Cảnh Báo Vượt Calo (Macro Calculation Testcases)

- **Module**: `03-diary-calorie-tracker`
- **Tham chiếu BA**: `docs/03-prd-features/03-diary-calorie-tracker/user-stories.md` (US-04)

---

### TC-MAC-001: Hiển thị cảnh báo khi tổng calo nạp vào vượt quá mục tiêu
- **Preconditions**: Mục tiêu calo hàng ngày = `2,000 kcal`.
- **Test Steps**:
  1. Ghi nhận các món ăn sao cho tổng calo đạt `2,150 kcal` (vượt 150 kcal).
  2. Quan sát màu sắc và thông báo trên CalorieProgressArc.
- **Expected Result**:
  - Vòng cung không bị gãy hay tràn layout UI.
  - Vòng cung và viền ngoài chuyển sang màu Vàng Tertiary `#FFD700`.
  - Dòng chữ chính giữa hiển thị: *"+150 kcal vượt mục tiêu"*.
- **Severity**: S2 (Critical)
