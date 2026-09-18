# Test Cases: Nhập Món Ăn Thủ Công (Manual Food Entry)

- **Mã tính năng**: `FEAT-03-MANUAL`
- **Tài liệu PRD liên quan**: `docs/03-prd-features/03-diary-calorie-tracker/prd-manual-entry.md`
- **User Stories liên quan**: `US-07`, `US-08`, `US-09`
- **Bộ phận phụ trách**: QA Team
- **Trạng thái**: Ready for Testing

---

## 📋 Danh Sách Test Cases

| Test Case ID | Tiêu đề Test Case | Loại kiểm thử | Độ ưu tiên | User Story |
| :--- | :--- | :---: | :---: | :---: |
| `TC-MANUAL-01` | Tìm kiếm và lọc món ăn từ danh bạ có sẵn | Happy Path | High | `US-07` |
| `TC-MANUAL-02` | Điều chỉnh khối lượng gram qua Slider và cập nhật calo động | Functional | High | `US-08` |
| `TC-MANUAL-03` | Lưu món ăn có sẵn vào bữa ăn thành công | Functional | High | `US-07` |
| `TC-MANUAL-04` | Thêm món ăn mới tùy chỉnh với dữ liệu hợp lệ | Functional | High | `US-09` |
| `TC-MANUAL-05` | Xác thực lỗi khi thêm món tùy chỉnh (Tên trống hoặc Calo âm) | Boundary/Negative | High | `US-09` |
| `TC-MANUAL-06` | Tự động chọn đúng Bữa ăn khi điều hướng từ nút `+` trên Dashboard | Functional | Medium | `US-07` |
| `TC-MANUAL-07` | Đồng bộ dữ liệu calo và dinh dưỡng về Dashboard ngay lập tức | Integration | High | `US-07`, `US-09` |

---

## 📝 Chi Tiết Kịch Bản Kiểm Thử

### `TC-MANUAL-01`: Tìm kiếm và lọc món ăn từ danh bạ có sẵn
- **Tiền điều kiện**: Người dùng đang mở màn hình "Nhập tay".
- **Các bước thực hiện**:
  1. Nhập từ khóa `"phở"` vào ô tìm kiếm `FoodSearchBar`.
  2. Quan sát danh sách kết quả hiển thị bên dưới.
  3. Xóa từ khóa bằng nút clear icon hoặc phím Backspace.
- **Kết quả mong đợi**:
  - Khi gõ `"phở"`, danh sách lập tức chỉ hiển thị các món chứa từ khóa (VD: Phở bò, Phở gà).
  - Không phân biệt chữ hoa hay chữ thường (Case-insensitive).
  - Khi xóa từ khóa tìm kiếm, toàn bộ danh mục món ăn phổ biến được phục hồi.

---

### `TC-MANUAL-02`: Điều chỉnh khối lượng gram qua Slider và cập nhật calo động
- **Tiền điều kiện**: Người dùng đã chọn 1 món từ danh sách (VD: "Ức gà áp chảo" chuẩn 100g, 165 kcal, 31g protein, 0g carbs, 3.6g fat).
- **Các bước thực hiện**:
  1. Kéo thanh trượt `Slider` từ 100g lên 200g.
  2. Quan sát con số năng lượng calo và 3 chỉ số Macro (Carbs, Protein, Fat).
  3. Kéo thanh trượt xuống mức tối thiểu 50g.
- **Kết quả mong đợi**:
  - Tại 200g: Calo hiển thị tăng lên 330 kcal, Protein đạt ~62g.
  - Tại 50g: Calo hiển thị giảm xuống ~83 kcal.
  - Các chỉ số cập nhật mượt mà theo thời gian thực (60fps), có rung haptic nhẹ khi thao tác.

---

### `TC-MANUAL-03`: Lưu món ăn có sẵn vào bữa ăn thành công
- **Tiền điều kiện**: Người dùng đã chọn món "Bánh mì thịt", chọn bữa ăn "Bữa sáng".
- **Các bước thực hiện**:
  1. Chọn bữa ăn "Bữa sáng".
  2. Nhấn nút "Lưu vào Bữa sáng".
- **Kết quả mong đợi**:
  - Nút lưu hiển thị trạng thái loading ngắn.
  - Hiển thị thông báo SnackBar: *"Đã lưu Bánh mì thịt vào Bữa sáng!"*.
  - Bản ghi được tạo trong Firestore subcollection `users/{uid}/foodLogs` với `mealType: "breakfast"` và `source: "manual_entry"`.

---

### `TC-MANUAL-04`: Thêm món ăn mới tùy chỉnh với dữ liệu hợp lệ
- **Tiền điều kiện**: Người dùng đang ở màn hình Nhập tay.
- **Các bước thực hiện**:
  1. Nhấn nút "Thêm tùy chỉnh" (`Icons.add_box_outlined`).
  2. BottomSheet hiển thị form nhập liệu.
  3. Điền: Tên món = `"Salad ức gà sốt mè"`, Gram = `200`, Calo = `280`, Protein = `25`, Carbs = `12`, Fat = `10`.
  4. Nhấn nút "Thêm vào bữa ăn".
- **Kết quả mong đợi**:
  - BottomSheet đóng lại.
  - SnackBar thông báo: *"Đã lưu Salad ức gà sốt mè vào bữa ăn!"*.
  - Dữ liệu món ăn mới được lưu trữ đầy đủ các thông số dinh dưỡng trên Firestore.

---

### `TC-MANUAL-05`: Xác thực lỗi khi thêm món tùy chỉnh (Tên trống hoặc Calo âm)
- **Tiền điều kiện**: Mở BottomSheet "Thêm món tùy chỉnh".
- **Các bước thực hiện**:
  1. Để trống trường Tên món.
  2. Nhập số Calo là `-50` hoặc để trống.
  3. Nhấn nút "Thêm vào bữa ăn".
- **Kết quả mong đợi**:
  - Form kích hoạt validation cảnh báo đỏ: *"Vui lòng nhập tên món ăn"* và *"Lượng calo phải >= 0"*.
  - Không có request lưu trữ nào được gửi đi, màn hình giữ nguyên để người dùng sửa lại.

---

### `TC-MANUAL-06`: Tự động chọn đúng Bữa ăn khi điều hướng từ nút `+` trên Dashboard
- **Tiền điều kiện**: Người dùng đang ở màn hình Dashboard `HomePage`.
- **Các bước thực hiện**:
  1. Cuộn đến thẻ "Bữa tối".
  2. Nhấn vào nút `+` (thêm món) của thẻ Bữa tối.
  3. Quan sát màn hình Nhập tay mở ra.
- **Kết quả mong đợi**:
  - Màn hình Nhập tay mở ra với chip "Bữa tối" được kích hoạt sẵn (`isSelected == true`).
  - Nút lưu hiển thị đúng ngữ cảnh: *"Lưu vào Bữa tối"*.

---

### `TC-MANUAL-07`: Đồng bộ dữ liệu calo và dinh dưỡng về Dashboard ngay lập tức
- **Tiền điều kiện**: Dashboard ban đầu đang có Bữa trưa là 0 kcal.
- **Các bước thực hiện**:
  1. Lưu một món ăn 500 kcal vào Bữa trưa bằng phương thức Nhập tay.
  2. Quay trở lại Dashboard `HomePage`.
- **Kết quả mong đợi**:
  - Vòng cung Calo tăng thêm 500 kcal.
  - Thẻ Bữa trưa xuất hiện món ăn vừa thêm với tên món và 500 kcal.
  - Không cần kéo reload hay khởi động lại app.
