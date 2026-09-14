# PRD: Hồ Sơ Cá Nhân & Quản Lý Mục Tiêu (User Profile & Goals)

- **Mã tính năng**: `FEAT-05`
- **Bộ phận phụ trách**: BA Team
- **Trạng thái**: Approved
- **Đối chiếu QA**: `tests/02-manual-testcases/05-user-profile-goals/` & `tests/03-bdd-gherkin-scenarios/profile_management.feature`
- **Đối chiếu FE**: `frontend/lib/features/profile/`

---

## 1. Mục Tiêu Nghiệp Vụ
Cho phép người dùng quản lý thông tin tài khoản, cập nhật chỉ số thể trạng (cân nặng hiện tại biến động theo tuần), điều chỉnh mục tiêu dinh dưỡng (Calo hàng ngày, tỷ lệ Carbs/Fat/Protein tùy biến) và quản lý quyền riêng tư/bảo mật.

---

## 2. Các Tính Năng Chi Tiết
1. **Thông tin cá nhân**: Avatar, Tên hiển thị, Email, Chiều cao, Giới tính sinh học.
2. **Cập nhật cân nặng mới**: Người dùng nhập số cân nặng mới -> Hệ thống tự động tính lại BMR/TDEE nếu có sự thay đổi đáng kể (> 2kg).
3. **Tùy chỉnh Macro Goal**:
   - Chọn chế độ ăn mẫu: Cân bằng (45C/30P/25F), Giàu đạm (High Protein: 35C/40P/25F), Keto (5C/25P/70F).
   - Tự do nhập tỷ lệ phần trăm tùy ý (Hệ thống kiểm tra tổng phải bằng đúng 100%).
4. **Cài đặt hệ thống**: Chuyển đổi đơn vị (kg/lbs, cm/ft), Quản lý tài khoản, Đăng xuất và Xóa tài khoản.
