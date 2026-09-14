# PRD: Xác Thực Tài Khoản & Khảo Sát Onboarding (Auth & Onboarding)

- **Mã tính năng**: `FEAT-01`
- **Bộ phận phụ trách**: BA Team
- **Trạng thái**: Approved
- **Đối chiếu QA**: `tests/02-manual-testcases/01-auth-onboarding/`
- **Đối chiếu FE**: `frontend/lib/features/auth/`

---

## 1. Mục Tiêu Nghiệp Vụ
Cung cấp giải pháp đăng ký, đăng nhập nhanh chóng, bảo mật qua Firebase Auth (Email/Password, Google Sign-In, Apple ID), sau đó dẫn dắt người dùng mới qua quy trình khảo sát 5 bước để tự động tính toán BMR, TDEE và thiết lập mục tiêu calo hàng ngày.

---

## 2. Luồng Trải Nghiệm Người Dùng (User Flow)
1. **Welcome Screen**: Hiển thị logo AstroBite hiệu ứng phát sáng Celestial, 2 nút "Bắt đầu ngay" (Tạo tài khoản) và "Tôi đã có tài khoản" (Đăng nhập).
2. **Auth Screen**: Nhập email & mật khẩu hoặc chọn Đăng nhập nhanh bằng Google/Apple.
3. **Cây quyết định sau đăng nhập (Post-Login Routing Guard)**:
   - Khi đăng nhập thành công qua bất kỳ phương thức nào, hệ thống kiểm tra document `users/{uid}` trên Firestore:
     - **Trường hợp A (Người dùng đã hoàn thành Onboarding - `is_onboarding_completed == true`)**: Bỏ qua khảo sát, fetch chỉ số dinh dưỡng và chuyển thẳng vào `ShellRoute` (Dashboard).
     - **Trường hợp B (Người dùng mới hoặc chưa hoàn thành Onboarding - `is_onboarding_completed == false` hoặc doc chưa có dữ liệu thể trạng)**: Chuyển hướng ngay sang màn hình khảo sát `/onboarding`.
     - **Trường hợp C (Khôi phục phiên khảo sát dở dang)**: Nếu người dùng từng thoát app ở bước $K \in [1..5]$, hệ thống tự động đưa về bước $K$ kèm các dữ liệu đã nhập trước đó.
4. **Quy trình khảo sát Onboarding (5 Bước chuẩn hóa)**:
   - **Bước 1 (Giới tính sinh học)**: Chọn Nam (`male`) hoặc Nữ (`female`) để xác định hệ số Mifflin-St Jeor.
   - **Bước 2 (Tuổi & Chiều cao)**: Nhập năm sinh (hợp lệ từ 12-100 tuổi) và chiều cao (100.0 - 250.0 cm).
   - **Bước 3 (Cân nặng & Mục tiêu cân nặng)**: Nhập cân nặng hiện tại (30.0 - 250.0 kg) và cân nặng mục tiêu. Cảnh báo an toàn nếu BMI mục tiêu < 18.5.
   - **Bước 4 (Mức độ vận động thể chất - PAL)**: Chọn 1 trong 5 mức độ (Sedentary 1.20, Lightly Active 1.375, Moderately Active 1.55, Very Active 1.725, Extremely Active 1.90).
   - **Bước 5 (Mục tiêu thể trạng chính)**: Giảm cân (thâm hụt 500 kcal/ngày), Giữ cân (0 kcal), Tăng cân/cơ (thặng dư 300 kcal/ngày). Áp dụng ngưỡng sàn an toàn (Nam >= 1500 kcal, Nữ >= 1200 kcal).
5. **Calculated Goal Summary (`/onboarding/summary`)**:
   - Hiển thị BMR, TDEE, Calorie Target (với đồng hồ bán nguyệt phát sáng Celestial).
   - Phân bổ Macro chuẩn y khoa: Carbs 45% (Xanh `#1A73E8`), Protein 30% (Vàng `#FFD700`), Fat 25% (Hồng `#FF69B4`).
   - Nút "Bắt đầu hành trình": Ghi một lần (atomic write) vào Firestore `users/{uid}`, cập nhật `is_onboarding_completed = true`, chuyển hướng toàn bộ sang Dashboard.
