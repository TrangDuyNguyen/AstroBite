# Testcases Kiểm Tra Hợp Lệ Onboarding (Onboarding Validation)

- **Module**: `01-auth-onboarding`
- **Tham chiếu BA**: `docs/03-prd-features/01-auth-onboarding/user-stories.md` (US-02)

---

### TC-ONB-001: Kiểm tra tính toán BMR & TDEE theo công thức chuẩn Mifflin-St Jeor
- **Test Steps**:
  1. Người dùng chọn Giới tính: Nam (`male`).
  2. Chiều cao: `175 cm`, Tuổi: `28` (Năm sinh 1998).
  3. Cân nặng hiện tại: `80 kg`.
  4. Mức độ vận động: `Lightly Active` (Hệ số PAL 1.375).
  5. Chọn mục tiêu: `Giảm cân` (-500 kcal).
- **Expected Result**:
  - `BMR = 10 * 80 + 6.25 * 175 - 5 * 28 + 5 = 800 + 1093.75 - 140 + 5 = 1758.75` (~ 1,759 kcal).
  - `TDEE = 1758.75 * 1.375 = 2418.28` (~ 2,418 kcal).
  - `Mục tiêu Calo = 2418.28 - 500 = 1918.28` (~ 1,918 kcal).
  - Tỷ lệ Macro: Carbs 45% (216g), Protein 30% (144g), Fat 25% (53g).
  - Dữ liệu hiển thị trên màn hình Summary khớp hoàn toàn với kết quả tính toán.
- **Severity**: S2 (Critical)
