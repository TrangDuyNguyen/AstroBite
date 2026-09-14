# [TEMPLATE] Checklist Nghiệm Thu Trước Giờ Release (Release Checklist)

- **Phiên bản chuẩn bị phát hành**: `v[X.Y.Z]`
- **Ngày phát hành dự kiến**: `YYYY-MM-DD`
- **Người chủ trì**: QA Lead & Release Manager

---

## 1. Kiểm Tra Bộ Kịch Bản Smoke & Sanity Test
- [ ] Xác thực: Đăng ký tài khoản mới, Đăng nhập, Đăng xuất, Quên mật khẩu.
- [ ] Onboarding: Tính toán BMR/TDEE chính xác theo công thức.
- [ ] Food Scanner: Chụp ảnh nhận diện món ăn bằng Gemini AI thành công (< 3s).
- [ ] Food Scanner: Nhập khẩu phần thủ công và lưu vào Bữa Trưa.
- [ ] Calorie Diary: Hiển thị đúng vòng cung tiến trình, cảnh báo khi vượt calo.
- [ ] Calorie Diary: Xóa món ăn và cập nhật calo tức thì.
- [ ] Analytics: Biểu đồ tuần FlChart hiển thị mượt mà không lỗi.
- [ ] Profile: Cập nhật mục tiêu dinh dưỡng và lưu thành công.

---

## 2. Kiểm Tra Phi Chức Năng & Bảo Mật
- [ ] Firebase App Check đang hoạt động ở chế độ Enforcement (Chặn request giả mạo).
- [ ] Không còn bản ghi log nhạy cảm (API Keys, Passwords) in ra console ở bản Release.
- [ ] Kích thước file cài đặt (APK/AAB < 35MB, IPA < 50MB).
- [ ] Giao diện chuẩn Celestial Dark UI, không bị méo lệch trên thiết bị màn hình nhỏ (iPhone SE).

---

## 3. Ký Duyệt Xuất Bản (Sign-off)
- **QA Lead**: [ Đã nghiệm thu / Đạt chuẩn ] - Ký tên: ..........................
- **Tech Lead**: [ Đã kiểm duyệt code & security ] - Ký tên: ..........................
- **Product Owner**: [ Phê duyệt phát hành ] - Ký tên: ..........................
