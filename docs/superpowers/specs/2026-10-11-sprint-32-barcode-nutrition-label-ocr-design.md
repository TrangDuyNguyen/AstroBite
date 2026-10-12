# Architecture Decision Record (ADR-038): Sprint 32 — Barcode & Nutrition Label OCR Scanner (v3.4.0)

> **Trạng thái**: 🟢 **ACCEPTED (Gate 0 Sign-Off)**  
> **Người chủ trì**: Sub-Agent Tech Lead (*The Pragmatic System Architect*) & Sub-Agent PO (*The Strategic Tyrant*)  
> **Mã Epic / Feature**: `EPIC-SCAN-02` / `FEAT-S32-BARCODE-OCR`  
> **Ngày phê duyệt**: 2026-10-11  
> **Phạm vi áp dụng**: Pipeline nhận diện Camera, Vision Prompt Engineering, Open Food Facts Integration, và UI Scanner Mode Switcher  

---

## 1. Bối Cảnh & Vấn Đề Kỹ Thuật (Context & Problem Statement)

AstroBite hiện tại sở hữu tính năng quét đĩa thức ăn (`FoodScannerPage` / `CameraPage`) cực kỳ mạnh mẽ với Gemini 2.0 Flash Vision và bóc tách thành phần Á Đông (`BrothToggleChip`, `ToppingChecklistWrap`). Tuy nhiên, đối với nhóm **thực phẩm đóng gói sẵn** (sữa chua, bánh protein bar, mì gói, đồ hộp, snack, nước uống):
- Người dùng gặp khó khăn khi chụp cả bao bì vì Gemini thường đoán theo hình ảnh minh họa trên nhãn thay vì đọc chính xác bảng số liệu dinh dưỡng in ở mặt sau.
- Thực phẩm đóng gói có **Mã vạch (Barcode EAN-13 / UPC)** và **Bảng thành phần dinh dưỡng (Nutrition Facts / Thông tin dinh dưỡng)** chuẩn hóa.
- Mục tiêu kinh doanh (PO): Cắt giảm thời gian ghi nhận (Time-to-Log) đồ đóng hộp xuống `< 1.5 giây`, nâng D30 Retention lên `+15%`.

---

## 2. Phân Tích Đánh Đổi & So Sánh 3 Phương Án (Trade-off Analysis)

| Tiêu Chí Đánh Giá | Phương Án 1: Gemini 2.0 Flash Multimodal Vision (Khuyến Nghị) | Phương Án 2: On-device `mobile_scanner` + Gemini OCR | Phương Án 3: Full Google ML Kit On-Device |
| :--- | :--- | :--- | :--- |
| **Độ phức tạp & Kích thước binary (APK/IPA)** | 🟢 **0 package mới (0MB thêm vào)**. Tận dụng 100% `firebase_ai` & camera hiện có. | 🟡 Cần cài `mobile_scanner` (+6-8MB native binary). | 🔴 Cài `google_mlkit_*` (+25-35MB model download, rủi ro tương thích). |
| **Khả năng đọc bảng Nutrition Facts đa dạng** | 🟢 **Xuất sắc**. Gemini Flash hiểu ngữ cảnh tiếng Việt ("Năng lượng", "Chất đạm", "Chất béo", "Đường", "Natri") và chuẩn FDA/EU. | 🟢 Gemini xử lý OCR nhãn tốt, barcode quét on-device. | 🔴 Regex parsing bảng OCR text on-device cực kỳ dễ vỡ khi góc chụp nghiêng hoặc nhãn uốn cong. |
| **Tra cứu cơ sở dữ liệu Barcode** | 🟢 Trích xuất mã số vạch từ ảnh ➔ Gọi Open Food Facts REST API / Local cache. | 🟢 Quét số vạch on-device ➔ Gọi Open Food Facts REST API. | 🟡 Gọi Open Food Facts REST API. |
| **Độ trễ xử lý (Latency SLA)** | 🟢 **1.2s - 1.8s** (đáp ứng SLA < 2.5s với shimmer/skeleton). | 🟡 Barcode: 100ms, Nhãn OCR: 1.5s - 2.0s. | 🟢 Barcode: 100ms, Text parsing: 400ms (nhưng độ chính xác bảng thấp). |
| **Tuân thủ triết lý Ponytail** | 🟢 **Tối thượng**: Tận dụng hạ tầng có sẵn, stdlib HTTP call, zero bloatware. | 🟡 Vi phạm quy tắc 0 package nếu không bắt buộc. | 🔴 Vi phạm nghiêm trọng: Kéo models nặng nề vào app client. |

---

## 3. Quyết Định Kỹ Thuật (Decisions)

### D1: Kiến Trúc Hybrid Ponytail — Gemini 2.0 Flash Vision + Open Food Facts API
1. **Zero New Third-party Dependencies**: Không thêm package quét barcode native nặng nề vào `pubspec.yaml`.
2. **Dual-Mode Scanner Switcher trên CameraPage**:
   - Mode 1: `ScanMode.dish` (Chế độ hiện tại: Quét món ăn trên đĩa, bóc tách broth/topping Á Đông).
   - Mode 2: `ScanMode.packaged` (Chế độ mới: Quét nhãn dinh dưỡng & mã vạch thực phẩm đóng gói).
3. **Engine Phân Tích Nhãn Dinh Dưỡng (Nutrition Facts Vision Prompt)**:
   - Xây dựng System Instruction chuyên biệt ép Gemini 2.0 Flash trả về JSON schema với các trường:
     - `brand_and_product_name`: Tên sản phẩm & thương hiệu.
     - `serving_size_g`: Khẩu phần 1 lần ăn (gram / ml).
     - `calories`: Năng lượng (kcal) trên mỗi khẩu phần.
     - `carbs_g`, `protein_g`, `fat_g`: 3 chỉ số đa lượng cốt lõi.
     - `sodium_mg`, `sugar_g`, `fiber_g`: Vi chất quan trọng.
     - `detected_barcode`: Mã số vạch nếu có trong ảnh.

### D2: Tích Hợp Open Food Facts API (Fallback & Tăng Tốc Độ Chính Xác)
- Tạo service tinh gọn `BarcodeLookupService`:
  - Endpoint: `https://world.openfoodfacts.org/api/v2/product/{barcode}.json`
  - Đọc trực tiếp HTTP qua `http` / `HttpClient` chuẩn Dart stdlib.
  - Cache kết quả tra cứu vào memory / local storage để tra cứu lại với $O(1)$ complexity.

### D3: Tái Cấu Trúc Viewfinder & HUD Công Thái Học
- Thiết kế khung quét thông minh (Smart Bounding Box):
  - Hiển thị dải ngắm chữ nhật bo góc theo tỷ lệ bao bì thực phẩm đóng gói.
  - Hướng dẫn trực quan: *"Căn chỉnh bảng dinh dưỡng hoặc mã vạch vào khung hình"*.
  - Tích hợp nút chuyển đổi nhanh (Mode Pill Switcher) ngay phía trên nút chụp ảnh, đảm bảo nằm trọn trong Thumb Zone tiện dụng.

### D4: Bàn Giao Kết Quả Sang ScanReviewPage
- Tái sử dụng 100% `ScanReviewPage` và các widget con đã được module hóa chuẩn Ponytail (`scan_review_hero_card`, `scan_macro_gauge_section`, `scan_portion_card`).
- Tự động điền số gram theo serving size ghi trên nhãn sản phẩm (ví dụ: 1 hộp sữa 180ml hoặc 1 gói mì 75g).

---

## 4. Ngân Sách Hiệu Năng & Cam Kết SLAs (Performance Budgets)
- **Cold Start Impact**: `+0ms` (không nạp thêm native binary).
- **Vision AI Response Time**: `<= 1.8s` (có Animated Scan Shimmer).
- **Memory Consumption**: Tối đa `< 120MB` trong suốt phiên camera, giải phóng 100% buffer khi đóng camera (`0 memory leak`).
- **FPS**: Đạt `>= 58 FPS` trên thiết bị tầm trung.

---

## 5. Chữ Ký Phê Duyệt Kỹ Thuật (Sign-Off)
- **Sub-Agent Tech Lead**: 🟢 **APPROVED (ADR-038 Published & Feasible)**
- **Sub-Agent PO**: 🟢 **APPROVED (Aligned with Sprint 32 Scope)**
