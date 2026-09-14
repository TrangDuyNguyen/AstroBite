# Đặc Tả Giao Diện (UI/UX Screen Specs): User Profile & Goals

## 1. Danh Sách Màn Hình & Thành Phần
- `SCR-11`: UserProfileScreen (`/profile`)
- `SCR-12`: NutritionGoalSettingScreen (`/profile/goals`)
- `COMP-10`: MacroRatioCustomizer (Bộ 3 slider liên kết có hiển thị tổng % tự động cân bằng)
- `COMP-11`: AccountSecuritySection (Các tùy chọn đổi mật khẩu, đăng xuất, xóa tài khoản)

---

## 2. Quy Chuẩn Đồ Họa & Tương Tác
- **Avatar Profile**: Hình tròn đường kính 80pt, viền phát sáng Celestial Blue, có icon camera nhỏ để đổi ảnh đại diện.
- **Thẻ Danh Mục Cài Đặt**: `GlassCard` nền `#112240`, các item có icon màu trắng mờ bên trái, mũi tên chỉ đường `ChevronRight` bên phải.
- **Nút Nguy Hiểm (Danger Action)**: Nút "Đăng xuất" và "Xóa tài khoản" sử dụng màu đỏ cảnh báo `#EF4444` trên nền kính mờ.
