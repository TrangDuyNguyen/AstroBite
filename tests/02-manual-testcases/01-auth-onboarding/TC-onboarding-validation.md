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

---

### TC-ONB-002: Kiểm tra kích hoạt ngưỡng sàn calo an toàn (Calorie Safety Floor)
- **Test Steps**:
  1. Người dùng Nữ (`female`), Tuổi: 40, Chiều cao: `150 cm`, Cân nặng: `45 kg`.
  2. Mức độ vận động: `Sedentary` (PAL 1.20).
  3. Chọn mục tiêu: `Giảm cân` (-500 kcal).
- **Expected Result**:
  - `BMR = 10 * 45 + 6.25 * 150 - 5 * 40 - 161 = 450 + 937.5 - 200 - 161 = 1026.5 kcal`.
  - `TDEE = 1026.5 * 1.20 = 1231.8 kcal`.
  - Thâm hụt thông thường: `1231.8 - 500 = 731.8 kcal` (Vi phạm ngưỡng an toàn nữ 1200 kcal).
  - Hệ thống tự động kích hoạt Calorie Safety Floor: Mục tiêu Calo được chặn ở mức tối thiểu `1200 kcal`.
  - Hiển thị tooltip/thông báo cảnh báo an toàn sức khỏe y khoa.
- **Severity**: S2 (Critical)

---

### TC-ONB-003: Phân tích giá trị biên (BVA) cho chiều cao và cân nặng
- **Test Steps**:
  1. Nhập Chiều cao: thử nghiệm `99 cm` (ngoại lệ), `100 cm` (hợp lệ biên dưới), `250 cm` (hợp lệ biên trên), `251 cm` (ngoại lệ).
  2. Nhập Cân nặng: thử nghiệm `29.9 kg` (ngoại lệ), `30.0 kg` (hợp lệ biên dưới), `250.0 kg` (hợp lệ biên trên), `250.1 kg` (ngoại lệ).
- **Expected Result**:
  - Với các giá trị ngoại lệ (`99 cm`, `251 cm`, `29.9 kg`, `250.1 kg`): Nút "Tiếp tục" bị vô hiệu hóa hoặc xuất hiện cảnh báo lỗi màu đỏ.
  - Với các giá trị biên hợp lệ: Cho phép chuyển bước bình thường.
- **Severity**: S3 (Major)

---

### TC-ONB-004: Kiểm tra định tuyến sau đăng nhập (Post-Login Routing Guard)
- **Test Steps**:
  1. Đăng nhập bằng tài khoản A (`is_onboarding_completed: true`).
  2. Quan sát màn hình đích sau khi Auth hoàn tất.
  3. Đăng xuất. Đăng nhập bằng tài khoản B (`is_onboarding_completed: false` hoặc user mới qua Google).
  4. Quan sát màn hình đích.
- **Expected Result**:
  - Tài khoản A: Chuyển thẳng vào `Dashboard` (`ShellRoute`), không hiện màn hình Onboarding.
  - Tài khoản B: Chuyển hướng ngay sang `/onboarding` tại bước tương ứng.
- **Severity**: S1 (Blocker)

---

### TC-ONB-005: Khôi phục phiên khảo sát dở dang (Drop-off & Resumption)
- **Test Steps**:
  1. Đăng nhập tài khoản mới, hoàn thành Bước 1 (Nam), Bước 2 (175cm, 25 tuổi), Bước 3 (75kg).
  2. Tại Bước 4, thoát hẳn ứng dụng (Kill app).
  3. Mở lại ứng dụng và đăng nhập.
- **Expected Result**:
  - Hệ thống tự động khôi phục dữ liệu đã nhập ở Bước 1, 2, 3 và mở lại đúng màn hình khảo sát tại Bước 4.
  - Người dùng không phải nhập lại từ đầu.
- **Severity**: S2 (Critical)

