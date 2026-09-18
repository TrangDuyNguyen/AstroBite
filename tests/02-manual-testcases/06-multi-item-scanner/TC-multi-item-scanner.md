# Bộ Testcase Kiểm Thử Thủ Công: Quét Nhận Diện Đa Món Ăn (Multi-Item Food Scanner)

- **Module**: `06-multi-item-scanner` (`FEAT-06` / `EPIC-06`)
- **Tài liệu tham chiếu BA**: `docs/03-prd-features/06-multi-item-scanner/prd-multi-item-scanner.md` & `user-stories.md`
- **Tài liệu tham chiếu UI/UX**: `docs/03-prd-features/06-multi-item-scanner/ui-ux-design-spec.md`
- **Tác giả**: Sub-Agent QA Tester (`qa-tester`)
- **Kỹ thuật áp dụng**: Phân vùng tương đương (EP), Phân tích giá trị biên (BVA), Đoán lỗi (Error Guessing), State Transition

---

## 1. Ma Trận Truy Vết Kiểm Thử (Traceability Matrix)

| Mã Testcase | Mã User Story | Kỹ Thuật ISTQB | Mục Tiêu Kiểm Thử | Mức Độ Nghiêm Trọng |
| :--- | :--- | :---: | :--- | :---: |
| **`TC-MUL-001`** | `US-MUL-01` | Happy Path / EP | Nhận diện thành công khay cơm 3 món chuẩn | **S1 (Blocker)** |
| **`TC-MUL-002`** | `US-MUL-01` | BVA | Nhận diện đĩa cơm phức tạp 5-6 món (Ngưỡng tối đa) | **S2 (Critical)** |
| **`TC-MUL-003`** | `US-MUL-02` | State Transition | Bỏ tích chọn 1 món (Checkbox Unselected) & Reactive recalculation | **S1 (Blocker)** |
| **`TC-MUL-004`** | `US-MUL-03` | BVA | Kéo slider điều chỉnh gram tại điểm biên tối thiểu (20g) & tối đa (800g) | **S2 (Critical)** |
| **`TC-MUL-005`** | `US-MUL-04` | Happy Path | Thêm món ăn thủ công bị AI bỏ sót vào mâm cơm | **S3 (Major)** |
| **`TC-MUL-006`** | `US-MUL-05` | State Fallback | Ảnh chụp chỉ phát hiện 1 món đơn lẻ (Single-item fallback) | **S2 (Critical)** |
| **`TC-MUL-007`** | `US-MUL-05` | Negative / Error | Ảnh chụp không có món ăn hoặc độ tin cậy < 60% | **S2 (Critical)** |

---

## 2. Chi Tiết Các Kịch Bản Kiểm Thử (Test Details)

### TC-MUL-001: Nhận diện thành công khay cơm 3 món (Cơm trắng, Thịt kho, Rau muống)
- **Tiền điều kiện**: Thiết bị kết nối 4G/Wifi ổn định, tài khoản đã đăng nhập, camera được cấp quyền.
- **Các bước thực hiện**:
  1. Mở màn hình Camera Scanner từ FAB giữa.
  2. Hướng camera chụp khay cơm văn phòng gồm: Cơm trắng, Thịt ba chỉ kho trứng, Rau muống xào.
  3. Bấm nút Chụp ảnh.
- **Kết quả mong đợi**:
  - Thời gian phản hồi từ lúc chụp đến khi hiện BottomSheet <= 2.5 giây.
  - BottomSheet hiển thị 3 Dish Cards tương ứng: "Cơm trắng", "Thịt ba chỉ kho trứng", "Rau muống xào".
  - Độ tin cậy (confidence score) hiển thị trên từng thẻ >= 85%.
  - Tổng calo hiển thị trên Meal Summary Card bằng đúng tổng calo 3 món con.
  - Thanh MacroBar phân bổ 3 màu chuẩn: Carbs xanh `#1A73E8`, Fat hồng `#FF69B4`, Protein vàng `#FFD700`.

---

### TC-MUL-002: Bóc tách mâm cơm phức hợp chạm ngưỡng 5-6 món
- **Tiền điều kiện**: Chuẩn bị ảnh hoặc mâm cơm gồm 6 món (Cơm, Sườn, Chả, Trứng ốp la, Canh cải, Dưa leo).
- **Các bước thực hiện**:
  1. Chụp ảnh mâm cơm 6 món.
  2. Quan sát giao diện danh sách thẻ món ăn trên BottomSheet.
- **Kết quả mong đợi**:
  - AI bóc tách đầy đủ từ 5 đến 6 thẻ món con.
  - Danh sách hỗ trợ cuộn dọc trơn tru, không drop FPS (< 55 FPS), không giật lag layout.
  - Số calo tổng và thanh MacroBar cộng dồn chính xác.

---

### TC-MUL-003: Bỏ tích chọn 1 món con và tự động cập nhật tổng calo (Reactive Update)
- **Tiền điều kiện**: Đã có kết quả nhận diện 3 món (Tổng calo: 680 kcal).
- **Các bước thực hiện**:
  1. Chạm vào Checkbox tại thẻ "Cơm trắng (234 kcal)".
  2. Quan sát sự thay đổi giao diện của thẻ và phần tóm tắt ở đỉnh.
  3. Chạm lại vào Checkbox để kích hoạt lại.
- **Kết quả mong đợi**:
  - Khi bỏ chọn: Thẻ "Cơm trắng" chuyển sang mờ (Opacity 40%, xám màu), chỉ số calo trên thẻ bị gạch ngang.
  - Tổng calo giảm ngay lập tức: $680 - 234 = 446\text{ kcal}$ với độ trễ < 16ms (60 FPS).
  - Tỷ lệ Carbs trên MacroBar thu hẹp tương ứng.
  - Khi tích chọn lại: Thẻ sáng trở lại, tổng calo phục hồi về 680 kcal.

---

### TC-MUL-004: Kéo slider điều chỉnh gram tại điểm biên (BVA: 20g và 800g)
- **Tiền điều kiện**: Thẻ món ăn đang có trọng lượng mặc định 150g (380 kcal).
- **Các bước thực hiện**:
  1. Kéo thanh slider của món về sát mép trái tối thiểu.
  2. Quan sát giá trị số gram và calo.
  3. Kéo thanh slider của món về sát mép phải tối đa.
  4. Quan sát giá trị số gram và calo.
- **Kết quả mong đợi**:
  - Tại biên trái: Slider dừng chính xác ở `20g`, calo tính theo tỷ lệ $\approx 51\text{ kcal}$. Không cho phép kéo về 0 hoặc số âm.
  - Tại biên phải: Slider dừng chính xác ở `800g`, calo tính theo tỷ lệ $\approx 2027\text{ kcal}$.
  - Tổng calo toàn bữa trên đỉnh màn hình nhảy số tức thì theo thao tác kéo.

---

### TC-MUL-005: Thêm món ăn thủ công bị AI bỏ sót vào mâm cơm
- **Tiền điều kiện**: BottomSheet kết quả đa món đang mở.
- **Các bước thực hiện**:
  1. Cuộn xuống cuối danh sách, bấm nút `"+ Thêm món thủ công"`.
  2. Nhập tìm kiếm "Canh chua cá bông lau", chọn định lượng `200g` (90 kcal).
  3. Bấm xác nhận thêm.
- **Kết quả mong đợi**:
  - Món "Canh chua cá bông lau" (200g, 90 kcal) xuất hiện thêm vào danh sách.
  - Tổng calo toàn bữa cộng thêm 90 kcal.
  - Nút lưu hiển thị: *"Lưu Bữa Ăn (4 Món • ... Kcal)"*.

---

### TC-MUL-006: Fallback thông minh khi chỉ phát hiện 1 món đơn lẻ
- **Tiền điều kiện**: Chụp ảnh bát "Phở Bò" hoặc đĩa "Bánh mì ốp la".
- **Các bước thực hiện**:
  1. Chụp ảnh 1 món ăn đơn lẻ.
  2. Quan sát giao diện BottomSheet trả về.
- **Kết quả mong đợi**:
  - Hệ thống tự động chuyển sang giao diện đơn món quen thuộc của v1.0.
  - Không hiển thị hộp kiểm Checkbox thừa thãi và không hiển thị danh sách đa món gây rối mắt.

---

### TC-MUL-007: Xử lý khi ảnh chụp không phải đồ ăn hoặc độ tin cậy thấp (< 60%)
- **Tiền điều kiện**: Chụp ảnh bàn làm việc hoặc vật dụng cá nhân trong phòng tối.
- **Các bước thực hiện**:
  1. Chụp ảnh một cuốn sổ tay hoặc laptop.
  2. Quan sát thông báo trả về.
- **Kết quả mong đợi**:
  - Hệ thống hiển thị hộp thoại Celestial Alert: *"Không nhận diện rõ các món ăn trên đĩa. Bạn có muốn chụp lại ở góc sáng hơn hoặc nhập tên món thủ công?"*
  - Cung cấp 2 nút rõ ràng: [Chụp Lại] và [Nhập Thủ Công]. Không crash ứng dụng.
