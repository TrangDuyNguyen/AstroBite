# Tài Liệu Yêu Cầu Sản Phẩm (PRD) — Sprint 08
## Đại Trùng Tu Giao Diện: Cinematic Celestial UI & Holographic AR HUD Scanner

- **Mã tính năng**: `FEAT-15`
- **Mã Epic**: `EPIC-17` (Cinematic Celestial UI & Holographic AR HUD Scanner)
- **Tác giả**: Sub-Agent Business Analyst — *"The Pedantic Logician"*
- **Người duyệt**: Sub-Agent Product Owner — *"The Strategic Tyrant"* & Sub-Agent Tech Lead — *"The Pragmatic System Architect"*
- **Mục tiêu phiên bản**: `v1.7.0` (Sprint 08)
- **Mục tiêu kinh doanh**: WOW Effect D1, tăng tỷ lệ hoàn thành scan (Scan Completion Rate) từ 85% lên >= 95%, D30 Retention đạt 45%, thời gian nhận thức calo & macro < 1.0 giây nhờ giao diện trực giác Holographic HUD.

---

## 🎯 1. Bối Cảnh & Vấn Đề (Problem Statement)

Sau khi Sprint 07 (`v1.6.0`) giải quyết triệt để tính công thái học và thao tác nhanh (1-tap logging, steppers, sticky bottom bar), trải nghiệm thị giác của người dùng cần được nâng lên tầm cao mới:
1. **Camera Scanner hiện tại**: Khung ngắm radar tròn 2D đơn giản chưa toát lên được sức mạnh công nghệ AI đa phương thức (Multimodal Gemini Vision AI 2.0). Người dùng mong muốn cảm giác tương lai, sắc sảo như công nghệ thực tế tăng cường (AR HUD Sci-Fi).
2. **Review Dinh Dưỡng**: Màn hình xem lại món sau khi quét cần một tấm kính nổi (Holographic Bento Glass Card) thể hiện bộ ba Macro phát sáng (Electric Blue `#1A73E8`, Hot Pink `#FF69B4`, Gold `#FFD700`) cùng vòng tròn calo trực quan, giúp người dùng nắm bắt dữ liệu ngay lập tức.
3. **Độ trung thực thiết kế (Design Fidelity)**: Cần kết nối trực tiếp với **Google Stitch MCP** để trích xuất bản vẽ thiết kế, mã layout HTML/CSS và ảnh chụp màn hình trực quan làm kim chỉ nam thị giác (Visual Ground Truth) cho Dev FE thực thi chuẩn xác từng pixel (Pixel-Perfect).

---

## 📋 2. Yêu Cầu Chức Năng & Tiêu Chí Chấp Nhận (BDD Given-When-Then)

### User Story 1: Kính Ngắm Thực Tế Tăng Cường (AR HUD Sci-Fi Viewfinder)
> Là một người dùng quét món ăn, tôi muốn khung ngắm camera hiển thị các đường nét AR HUD tương lai (khung viền góc đôi góc cyan/blue, vòng tròn tâm ngắm holographic, telemetry định vị và nhãn AI nổi trên món ăn), để tôi cảm nhận được sự hiện đại và chính xác của AI.

#### Scenario 1.1: Trạng thái tìm kiếm mục tiêu (Scanning Target)
- **Given** người dùng mở màn hình camera quét món (`CameraPage`),
- **When** camera bắt đầu khởi động luồng hình ảnh,
- **Then** màn hình hiển thị 4 góc khung ngắm đôi (Double-layered corner brackets) màu xanh Electric `#1A73E8` với hiệu ứng tỏa sáng mềm (glow),
- **And** ở tâm màn hình xuất hiện vòng tròn tâm ngắm holographic quay nhẹ nhàng cùng vệt quét laser (Scanner beam) chuyển động lên xuống 60 FPS,
- **And** nhãn Telemetry hiển thị góc ngắm và trạng thái: `[FOCAL LOCK: 98.4% CONFIDENCE]`.

#### Scenario 1.2: AI nhận diện và khóa mục tiêu (Focal Lock & Tagging)
- **Given** camera chụp được hình ảnh món ăn hợp lệ (ví dụ: Phở Bò Tái Nạm),
- **When** Gemini Vision AI trả về kết quả thành công,
- **Then** ngay trên tọa độ món ăn xuất hiện Card nhận diện kính mờ nổi (Floating Holographic Tag) hiển thị:
  - Tên món: *"Phở Bò Tái Nạm"*
  - Badge công nghệ: `[AI VERIFIED]`
  - Calo: `450 kcal`
  - Đường line gradient mảnh nối từ tag xuống tâm ngắm của món ăn.

---

### User Story 2: Phiếu Dinh Dưỡng Holographic Bento (Holographic Nutrition Bento Sheet)
> Là một người dùng kiểm tra dinh dưỡng sau quét, tôi muốn xem lượng calo và 3 chỉ số Macro trên một tấm thẻ kính mờ đa tầng với màu sắc phát sáng chuẩn mực, để tôi đánh giá món ăn trong vòng 1 giây.

#### Scenario 2.1: Bộ ba Macro phát sáng chuẩn ngữ nghĩa bất biến
- **Given** kết quả dinh dưỡng của món ăn được hiển thị trên Review Sheet,
- **Then** màn hình hiển thị 3 thẻ con Bento chuẩn màu ngữ nghĩa bất biến:
  - 🔵 **Carbs**: `#1A73E8` (Electric Blue) — Hiển thị số gram, % tổng calo, và thanh micro-bar phát sáng.
  - 🟡 **Đạm (Protein)**: `#FFD700` (Gold) — Hiển thị số gram, % tổng calo, và thanh micro-bar phát sáng.
  - 🩷 **Chất béo (Fat)**: `#FF69B4` (Hot Pink) — Hiển thị số gram, % tổng calo, và thanh micro-bar phát sáng.
- **And** Hero Calorie Counter hiển thị số calo lớn (Font Inter đậm) bên cạnh vòng tròn tiến độ mục tiêu ngày (`21% của 2,100 kcal`).

#### Scenario 2.2: Tích hợp công thái học ngón tay cái (Thumb-zone Steppers & Sticky CTA)
- **Given** phiếu Holographic Bento đang mở ở nửa dưới màn hình,
- **When** người dùng muốn tăng giảm nhanh khẩu phần,
- **Then** các chip stepper `-50g`, `1 Bát (~350g)`, `1 Đĩa (~300g)`, `+50g` nằm gọn trong tầm với ngón tay cái,
- **And** nút bấm chính *"Lưu vào Nhật ký"* màu xanh Electric `#1A73E8` (chiều cao 48pt, min touch target 48x48pt) dính chặt ở đáy màn hình.

---

## 📊 3. Từ Điển Dữ Liệu (Data Dictionary)

| Trường dữ liệu | Kiểu | Mô tả & Ràng buộc | Giá trị mẫu |
| :--- | :--- | :--- | :--- |
| `focalLockConfidence` | `double` | Độ tin cậy khóa tiêu cự của AI HUD (0.0 - 1.0) | `0.984` (98.4%) |
| `hudCoordinates` | `String` | Tọa độ quét hiển thị trên màn hình ngắm | `X: 104.2 / Y: 382.7 / Z: 0.84m` |
| `dishTitle` | `String` | Tên món ăn nhận diện chuẩn hóa | `"Phở Bò Tái Nạm"` |
| `dishCalories` | `int` | Lượng calo tính theo khẩu phần hiện tại (kcal) | `450` |
| `carbsG` / `carbsRatio` | `double` / `double` | Lượng Carbs (g) và tỷ lệ % calo (Màu `#1A73E8`) | `52.0g` (48%) |
| `proteinG` / `proteinRatio` | `double` / `double` | Lượng Đạm (g) và tỷ lệ % calo (Màu `#FFD700`) | `28.0g` (24%) |
| `fatG` / `fatRatio` | `double` / `double` | Lượng Chất béo (g) và tỷ lệ % calo (Màu `#FF69B4`) | `14.0g` (28%) |
| `portionWeightG` | `int` | Trọng lượng khẩu phần điều chỉnh | `350` (g) |

---

## 🚦 4. Ràng Buộc Kỹ Thuật & SLAs (Non-Functional Requirements)

1. **Hiệu năng hoạt ảnh (FPS)**: Hoạt ảnh AR HUD (Rotating ring, Scanner beam, Laser pulse) phải chạy ổn định ở mức **>= 55-60 FPS**, không gây lag camera stream hoặc drop frame.
2. **Bộ nhớ (RAM)**: Tuyệt đối không để xảy ra rò rỉ bộ nhớ (0 Memory Leak) khi bật/tắt camera hoặc dispose AnimationControllers.
3. **Màu sắc dinh dưỡng bất biến**: Bắt buộc tuân thủ 100% `AppColors.primary` (`#1A73E8` - Carbs), `AppColors.tertiary` (`#FFD700` - Protein), `AppColors.secondary` (`#FF69B4` - Fat). Cấm hardcode màu lạ.
4. **Chuẩn thiết kế**: Tuân thủ lưới 4pt, bo góc 12-24px, hiệu ứng kính mờ `surfaceBlur` với `BackdropFilter blur(20, 20)`.
