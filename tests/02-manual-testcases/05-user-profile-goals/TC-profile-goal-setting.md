# Testcases Cài Đặt Mục Tiêu Profile (Profile Goal Setting Testcases)

- **Module**: `05-user-profile-goals`
- **Tham chiếu BA**: `docs/03-prd-features/05-user-profile-goals/user-stories.md` (US-08, US-09)

---

### TC-PRO-001: Thay đổi tỷ lệ Macro và lưu trữ thành công
- **Test Steps**:
  1. Vào màn hình Profile -> chọn "Mục tiêu dinh dưỡng".
  2. Chọn chế độ mẫu "High Protein" (35% Carbs, 40% Protein, 25% Fat).
  3. Nhấn nút "Lưu thay đổi".
  4. Quay lại Dashboard kiểm tra.
- **Expected Result**:
  - Dữ liệu được ghi thành công vào Firestore `users/{uid}`.
  - Các thanh MacroBar tại Dashboard hiển thị tỷ lệ mục tiêu mới: Protein 40%, Carbs 35%, Fat 25%.
- **Severity**: S2 (Critical)

---

### TC-PRO-002: Đăng xuất khỏi tài khoản
- **Test Steps**:
  1. Tại màn hình Profile, cuộn xuống dưới cùng và nhấn "Đăng xuất".
  2. Xác nhận trên hộp thoại xác nhận.
- **Expected Result**:
  - Firebase Authentication đăng xuất thành công.
  - Ứng dụng xóa sạch state trong ProviderScope và điều hướng về WelcomeScreen.
  - Nhấn nút Back của Android không thể quay lại màn hình Dashboard.
- **Severity**: S1 (Blocker)
