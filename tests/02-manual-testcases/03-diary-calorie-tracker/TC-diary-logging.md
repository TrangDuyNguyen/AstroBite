# Testcases Ghi Nhật Ký Bữa Ăn (Diary Logging Testcases)

- **Module**: `03-diary-calorie-tracker`
- **Tham chiếu BA**: `docs/03-prd-features/03-diary-calorie-tracker/user-stories.md` (US-04, US-05, US-06)

---

### TC-LOG-001: Lưu món ăn từ Scanner vào Bữa Trưa
- **Test Steps**:
  1. Từ màn hình Scan Result, chọn chip bữa ăn "Bữa Trưa".
  2. Nhấn "Lưu vào Nhật ký".
- **Expected Result**:
  - Modal đóng lại, ứng dụng tự động chuyển về Dashboard màn hình chính.
  - Thẻ "Bữa Trưa" xuất hiện món ăn mới vừa lưu kèm khối lượng và calo.
  - Vòng cung CalorieProgressArc tăng thêm giá trị tương ứng.
  - Con số "Calo còn lại" giảm đi chính xác bằng lượng calo của món vừa thêm.
- **Severity**: S1 (Blocker)

---

### TC-LOG-002: Vuốt để xóa món ăn khỏi Bữa Ăn (Swipe-to-delete có confirm)
- **Test Steps**:
  1. Tại thẻ "Bữa Sáng", chọn món ăn muốn xóa (ví dụ "Bánh mì ốp la").
  2. Vuốt món ăn sang trái (Swipe left), lộ nền đỏ với icon thùng rác.
  3. Thả tay, quan sát hộp thoại xác nhận: *"Bạn có chắc muốn xóa món này khỏi bữa ăn?"*.
  4. Nhấn nút "Xóa".
- **Expected Result**:
  - Món ăn biến mất khỏi danh sách Bữa Sáng.
  - Hiển thị SnackBar: *"Đã xóa món Bánh mì ốp la"*.
  - Dữ liệu Firestore cập nhật xóa document tương ứng.
  - Dashboard cập nhật lại calo đã nạp giảm 350 kcal, calo còn lại tăng thêm 350 kcal ngay lập tức.
- **Severity**: S1 (Blocker)

---

### TC-LOG-003: Hủy thao tác xóa món ăn
- **Test Steps**:
  1. Vuốt món ăn sang trái để mở hộp thoại xác nhận xóa.
  2. Nhấn nút "Hủy".
- **Expected Result**:
  - Hộp thoại đóng lại.
  - Món ăn trở về vị trí ban đầu trong danh sách bữa ăn, không bị xóa.
  - Không thay đổi số calo đã nạp và calo còn lại.
- **Severity**: S3 (Minor)

---

### TC-DATE-001: Chuyển đổi ngày trên thanh lịch (Date Picker Strip)
- **Test Steps**:
  1. Mở màn hình Tổng quan hôm nay, kiểm tra Date Picker Strip ở trên cùng.
  2. Xác nhận ngày hôm nay được đánh dấu với nhãn "Hôm nay" và viền sáng màu Primary.
  3. Nhấn vào một ngày trước đó (ví dụ hôm qua).
- **Expected Result**:
  - Ngày hôm qua trở thành ngày được chọn (highlight xanh Primary `#1A73E8`).
  - Dữ liệu tiến trình calo và danh sách 4 bữa ăn tải dữ liệu của ngày được chọn.
  - Nhấn lại vào ngày hôm nay, dữ liệu trở về ngày hôm nay.
- **Severity**: S2 (Critical)
