# Testcases Ghi Nhật Ký Bữa Ăn (Diary Logging Testcases)

- **Module**: `03-diary-calorie-tracker`
- **Tham chiếu BA**: `docs/03-prd-features/03-diary-calorie-tracker/user-stories.md` (US-04, US-05)

---

### TC-LOG-001: Lưu món ăn từ Scanner vào Bữa Trưa
- **Test Steps**:
  1. Từ màn hình Scan Result, chọn chip bữa ăn "Bữa Trưa".
  2. Nhấn "Lưu vào Nhật ký".
- **Expected Result**:
  - Modal đóng lại, ứng dụng tự động chuyển về Dashboard màn hình chính.
  - Thẻ "Bữa Trưa" xuất hiện món ăn mới vừa lưu kèm thumbnail ảnh (nếu có) và calo.
  - Vòng cung CalorieProgressArc tăng thêm giá trị tương ứng.
  - Con số "Calo còn lại" giảm đi chính xác bằng lượng calo của món vừa thêm.
- **Severity**: S1 (Blocker)

---

### TC-LOG-002: Vuốt để xóa món ăn khỏi Bữa Ăn
- **Test Steps**:
  1. Tại thẻ "Bữa Sáng", chọn món ăn muốn xóa.
  2. Vuốt sang trái (Swipe left), nhấn icon thùng rác màu đỏ `#EF4444`.
  3. Xác nhận trên popup "Bạn có chắc muốn xóa món này?".
- **Expected Result**:
  - Món ăn biến mất khỏi danh sách với animation mượt mà.
  - Dữ liệu trên Firestore xóa document tương ứng trong `users/{uid}/meal_logs/{id}`.
  - Dashboard cập nhật lại calo còn lại ngay lập tức.
- **Severity**: S2 (Critical)
