# Bộ Testcase Kiểm Thử Thủ Công: Theo Dõi Vi Chất Dinh Dưỡng (Micronutrients Tracking)

- **Module**: `08-micronutrients-tracking` (`FEAT-08` / `EPIC-08`)
- **Tài liệu tham chiếu BA**: `docs/03-prd-features/08-micronutrients-tracking/prd-micronutrients.md` & `user-stories.md`
- **Tài liệu tham chiếu UI/UX**: `docs/03-prd-features/08-micronutrients-tracking/ui-ux-design-spec.md`
- **Tác giả**: Sub-Agent QA Tester (`qa-tester`)
- **Kỹ thuật áp dụng**: Phân vùng tương đương (EP), Phân tích giá trị biên (BVA), State Transition, Backward Compatibility Check

---

## 1. Ma Trận Truy Vết Kiểm Thử (Traceability Matrix)

| Mã Testcase | Mã User Story | Kỹ Thuật ISTQB | Mục Tiêu Kiểm Thử | Mức Độ Nghiêm Trọng |
| :--- | :--- | :---: | :--- | :---: |
| **`TC-MIC-001`** | `US-MIC-01` | Happy Path / EP | Hiển thị 3 Chip vi chất (Natri, Xơ, Đường) trên kết quả quét AI | **S1 (Blocker)** |
| **`TC-MIC-002`** | `US-MIC-01` | BVA | Tỷ lệ vi chất tự động tính lại theo trọng lượng khi kéo slider | **S2 (Critical)** |
| **`TC-MIC-003`** | `US-MIC-02` | Boundary Warning | Cảnh báo đổi màu Cam khi món ăn có Natri > 800mg | **S2 (Critical)** |
| **`TC-MIC-004`** | `US-MIC-03` | Happy Path | Thẻ vi chất trên màn hình Diary hiển thị 3 thanh tiến độ | **S1 (Blocker)** |
| **`TC-MIC-005`** | `US-MIC-03` | Boundary Warning | Cảnh báo đổi màu Đỏ khi tổng lượng Natri trong ngày vượt 2,300mg | **S2 (Critical)** |
| **`TC-MIC-006`** | `US-MIC-04` | Backward Compat | Tương thích ngược: Đọc các bản ghi cũ v1.0 không có vi chất | **S1 (Blocker)** |

---

## 2. Chi Tiết Các Kịch Bản Kiểm Thử (Test Details)

### TC-MIC-001: Hiển thị 3 Chip vi chất trên BottomSheet kết quả nhận diện
- **Tiền điều kiện**: Quét ảnh đĩa "Cá hồi áp chảo măng tây".
- **Các bước thực hiện**:
  1. Chụp ảnh đĩa cá hồi măng tây.
  2. Quan sát hàng `MicronutrientChipsRow` trong BottomSheet kết quả.
- **Kết quả mong đợi**:
  - Xuất hiện 3 chip nhỏ gọn:
    - Chip Natri: `Muối: 320 mg` (icon hạt muối, màu Cyan `#00E5FF`).
    - Chip Chất xơ: `Xơ: 4.2 g` (icon chiếc lá, màu Emerald `#00E676`).
    - Chip Đường: `Đường: 1.5 g` (icon giọt nước, màu xám bạc `#E0E0E0`).
  - Kích thước chip gọn gàng, không che khuất thanh MacroBar.

---

### TC-MIC-002: Cảnh báo món ăn có lượng muối cao (Natri > 800mg)
- **Tiền điều kiện**: Chụp ảnh hoặc nhập món "Mì tôm lẩu thái hải sản" (Hàm lượng Natri: 1450mg).
- **Các bước thực hiện**:
  1. Quét hoặc chọn món "Mì tôm lẩu thái".
  2. Quan sát Chip Natri và huy hiệu cảnh báo.
- **Kết quả mong đợi**:
  - Chip Natri tự động chuyển từ màu Cyan sang màu Cam Hổ Phách `#FF9100`.
  - Xuất hiện badge `Muối cao` kèm icon tam giác cảnh báo.
  - Chạm vào badge hiển thị tooltip nhắc nhở uống nhiều nước.

---

### TC-MIC-003: Theo dõi 3 thanh tiến độ vi chất trên màn hình Nhật Ký (Diary)
- **Tiền điều kiện**: Đã ghi nhận các bữa ăn trong ngày với tổng: 1600mg Natri, 28g Xơ, 22g Đường.
- **Các bước thực hiện**:
  1. Mở màn hình Diary.
  2. Cuộn đến thẻ "Vi Chất Dinh Dưỡng Hôm Nay".
- **Kết quả mong đợi**:
  - Thanh Natri hiển thị `1,600 / 2,300 mg` — Màu Cyan (An toàn).
  - Thanh Chất xơ hiển thị `28 / 25 g` — Màu Emerald kèm icon ngôi sao (Đạt mục tiêu).
  - Thanh Đường hiển thị `22 / 36 g` — Màu xám sáng (Trong mức kiểm soát).
  - Thao tác thu gọn/mở rộng thẻ mượt mà không drop FPS.

---

### TC-MIC-004: Cảnh báo khi tổng Natri trong ngày vượt ngưỡng WHO (BVA: > 2300mg)
- **Tiền điều kiện**: Đang có 2,100mg Natri trên thẻ Diary.
- **Các bước thực hiện**:
  1. Ghi thêm một bữa ăn phụ có 350mg Natri (Tổng thành 2,450mg).
  2. Quan sát lại thẻ vi chất trên Diary.
- **Kết quả mong đợi**:
  - Thanh Natri chuyển sang màu Đỏ Rực Cảnh Báo `#FF5252`.
  - Hiển thị badge: *"Vượt ngưỡng khuyến nghị (2,450 / 2,300 mg)"*.

---

### TC-MIC-005: Tương thích ngược tuyệt đối với các bản ghi cũ của v1.0.0
- **Tiền điều kiện**: Cơ sở dữ liệu chứa bản ghi bữa ăn tạo từ v1.0.0 (không có các trường `sodium_mg`, `fiber_g`, `sugar_g`).
- **Các bước thực hiện**:
  1. Chọn ngày cũ trên thanh lịch ngày.
  2. Quan sát việc nạp và render dữ liệu.
- **Kết quả mong đợi**:
  - Ứng dụng parse bình thường, tự động điền giá trị `0.0`.
  - Không gặp lỗi `NoSuchMethodError`, `type 'Null' is not a subtype of type 'double'` hay crash app.
