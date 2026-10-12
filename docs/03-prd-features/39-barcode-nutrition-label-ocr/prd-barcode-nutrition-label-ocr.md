# PRD: Quét Mã Vạch & Bóc Tách Bảng Dinh Dưỡng Thực Phẩm Đóng Gói — AstroBite

- **Mã tính năng**: `FEAT-S32-BARCODE-OCR`
- **Mã Epic**: `EPIC-SCAN-02`
- **Sprint**: Sprint 32 (Phiên bản mục tiêu `v3.4.0`)
- **Tác giả**: Sub-Agent BA (*The Pedantic Logician*)
- **Người thẩm định & ký duyệt**: Sub-Agent PO (*The Strategic Tyrant*) & Sub-Agent Tech Lead (*The Pragmatic System Architect*)
- **Trạng thái**: 🟢 **APPROVED (Gate 1 Sign-Off)**

---

## 1. Mục Tiêu Sản Phẩm & Chỉ Số Đo Lường (Metrics & SLAs)

1. **Mục tiêu kinh doanh (Business Value & Retention)**:
   - Cắt giảm thời gian ghi nhận (Time-to-Log) đối với thực phẩm đóng hộp, đóng chai, đồ ăn vặt từ `45 giây` (nhập tay) xuống `< 1.5 giây` (quét camera).
   - Nâng cao tỷ lệ giữ chân D30 Retention thêm `+15%` nhờ giảm thiểu ma sát ghi nhật ký ăn uống hằng ngày.
   - Gia tăng tần suất ghi nhận đồ ăn vặt / bữa phụ đóng gói lên `+35%`.

2. **Chỉ số kỹ thuật & SLA (Technical SLAs)**:
   - **Tỷ lệ nhận diện chính xác**: `>= 92%` đối với bảng thành phần dinh dưỡng (Nutrition Facts) và `>= 95%` đối với mã vạch chuẩn (EAN-13, UPC-A).
   - **Độ trễ xử lý (Latency SLA)**: `< 1.8 giây` từ thời điểm chụp ảnh đến khi hiển thị kết quả trên `ScanReviewPage`.
   - **FPS camera**: `>= 58 FPS` trong suốt quá trình preview và chụp.
   - **Rò rỉ bộ nhớ (Memory Leak)**: Tuyệt đối `0 leak`, giải phóng toàn bộ image buffers khi rời màn hình.

---

## 2. Phạm Vi Tính Năng (Scope & MoSCoW)

- **Must-have (M)**:
  - Bổ sung bộ chọn chế độ quét trên giao diện Camera (`CameraPage`):
    - [📸 Món ăn] (`ScanMode.dish`) — Nhận diện đĩa thức ăn, bóc tách nước dùng / topping.
    - [🏷️ Đóng gói / Mã vạch] (`ScanMode.packaged`) — Quét nhãn dinh dưỡng & mã vạch.
  - Khung ngắm thông minh (Smart Bounding Box Viewfinder): Tỷ lệ khung chữ nhật bo tròn tối ưu cho quét nhãn hộp/chai/gói.
  - Phân tích Vision AI với Gemini 2.0 Flash: Trích xuất bảng Nutrition Facts (Calories, Carbs, Protein, Fat, Sodium, Serving Size, Tên sản phẩm, Mã vạch).
  - Tích hợp tra cứu fallback Open Food Facts API nếu phát hiện mã vạch rõ nét.
  - Chuyển tiếp liền mạch sang `ScanReviewPage` với các trường dinh dưỡng được điền tự động chính xác theo Serving Size.
  - Hỗ trợ song ngữ hoàn chỉnh (VI / EN) cho tất cả các nhãn và thông điệp mới.

- **Should-have (S)**:
  - Cache cục bộ kết quả tra cứu mã vạch để tra cứu tức thì $O(1)$ cho các lần quét lặp lại.
  - Hướng dẫn nhanh trên màn hình khi khung ngắm chưa bắt được bảng dinh dưỡng (Tips sheet).

- **Won't-have (Sprint 32)**:
  - Chưa hỗ trợ quét mã QR của các chuỗi nhà hàng (chuyển sang Sprint sau).
  - Chưa hỗ trợ so sánh 2 sản phẩm cùng lúc trên 1 khung hình camera.

---

## 3. Từ Điển Dữ Liệu (Data Dictionary)

| Trường Dữ Liệu | Kiểu Dữ Liệu | Ràng Buộc | Mô Tả Nghiệp Vụ |
| :--- | :--- | :--- | :--- |
| `scanMode` | `ScanMode` enum | `dish` \| `packaged` | Chế độ quét hiện hành của camera |
| `productName` | `String` | Non-null, <= 80 chars | Tên sản phẩm hoặc thương hiệu nhận diện |
| `servingSize` | `String` | e.g. "1 hộp (180ml)", "50g" | Khẩu phần chuẩn ghi trên bao bì |
| `servingWeightG`| `double` | > 0 | Trọng lượng quy đổi theo gram để tính toán |
| `calories` | `int` | >= 0 | Năng lượng (kcal) trên mỗi khẩu phần |
| `carbsG` | `double` | >= 0 | Lượng Carbohydrate (g) |
| `proteinG` | `double` | >= 0 | Lượng Protein (g) |
| `fatG` | `double` | >= 0 | Lượng Chất béo (g) |
| `sodiumMg` | `int?` | >= 0 | Lượng Natri (mg) |
| `barcode` | `String?` | 8 - 14 ký tự số | Mã vạch chuẩn nếu trích xuất được |

---

## 4. Chữ Ký Phê Duyệt Gate 1 (Sign-Off)
- **Sub-Agent BA**: 🟢 **SIGNED (Spec Complete & Unambiguous)**
- **Sub-Agent PO**: 🟢 **APPROVED (Aligned with Product Goals & MoSCoW)**
- **Sub-Agent Tech Lead**: 🟢 **FEASIBILITY APPROVED (ADR-038 Compliant)**
