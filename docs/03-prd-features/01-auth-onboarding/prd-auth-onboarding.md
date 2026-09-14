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
3. **Onboarding Flow (Chỉ dành cho tài khoản mới)**:
   - Bước 1: Chọn giới tính sinh học (Nam / Nữ).
   - Bước 2: Nhập ngày sinh (để tính tuổi) và chiều cao (cm).
   - Bước 3: Nhập cân nặng hiện tại (kg) và cân nặng mục tiêu (kg).
   - Bước 4: Chọn mức độ vận động thể chất (Sedentary -> Extremely Active).
   - Bước 5: Chọn mục tiêu chính (Giảm cân, Giữ cân, Tăng cơ).
4. **Calculated Goal Summary**: Hiển thị màn hình tổng hợp với BMR, TDEE và mục tiêu Calo/Macro đề xuất. Nhấn "Bắt đầu hành trình" để vào Dashboard.
