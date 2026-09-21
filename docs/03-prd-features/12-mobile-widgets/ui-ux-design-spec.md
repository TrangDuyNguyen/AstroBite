# UI/UX Design Spec: Bố Cục Tiện Ích Màn Hình Khóa & Màn Hình Chính (Mobile Widgets Blueprint)

- **Mã tính năng**: `FEAT-12` (Gate 2 Design Spec)
- **Mã Epic liên kết**: `EPIC-11` (Mobile Widgets & Quick Glance)
- **Bộ phận phụ trách**: Sub-Agent UI/UX Designer (`ui-ux-designer`) — *"The Celestial Aesthetic Purist"*
- **Trạng thái**: 🟡 **Ready for Gate 2 Sign-Off**
- **Tham chiếu PRD**: `docs/03-prd-features/12-mobile-widgets/prd-mobile-widgets.md` (Gate 1)
- **Hệ quy chiếu thiết kế**: `DESIGN.md` & `lib/core/theme/app_colors.dart`

---

## 1. Bản Vẽ Bố Cục Widgets (Widget Wireframe Blueprints)

### 1.1. Small Widget (Kích Thước 158x158pt)
- **Màu nền**: `AppColors.surface` (`#0A192F`) với viền mỏng phát sáng `#1E3A5F`.
- **Thành phần**:
  - **Góc trên bên trái**: Logo Monogram nhỏ và huy hiệu Streak (`🔥 5`).
  - **Trung tâm**: Con số Calo Còn Lại (Typography `HeadlineMedium`, `FontWeight.bold`, màu trắng tuyết `#FFFFFF`).
  - **Góc dưới**: Chữ `"KCAL CÒN LẠI"` và thanh tiến độ năng lượng phát sáng màu xanh Carbs `#1A73E8`.

### 1.2. Medium Widget (Kích Thước 338x158pt)
- **Màu nền**: `AppColors.surfaceContainer` (`#112240`).
- **Cột Trái (40% diện tích)**:
  - Mini Cosmic Energy Arc đường kính `90pt`.
  - Giữa vòng: Con số Calo còn lại (`650 kcal`).
  - Dưới vòng: Tag trạng thái `"🔥 5 NGÀY ĂN SẠCH"`.
- **Cột Phải (60% diện tích)**:
  - 3 thanh Macro thu nhỏ theo đúng quy chuẩn màu bất biến:
    - 🔵 Carbs: `#1A73E8`
    - 🩷 Fat: `#FF69B4`
    - 🟡 Protein: `#FFD700`
  - Nút Quick Action CTA hình viên thuốc (Pill Shape):
    - Background: Gradient `#1A73E8` $\rightarrow$ `#FF69B4`.
    - Text: `[📷 QUÉT MÓN ĂN - 1 CHẠM]`.
    - Deep Link: `astrobite://scanner`.

---

## 2. Quy Chuẩn Màu Sắc & Tokens Bất Biến

```dart
const Color kWidgetBackground = Color(0xFF0A192F); // Midnight Blue
const Color kWidgetSurface = Color(0xFF112240);    // Surface Container
const Color kCarbsBar = Color(0xFF1A73E8);         // Primary Blue
const Color kFatBar = Color(0xFFFF69B4);           // Secondary Pink
const Color kProteinBar = Color(0xFFFFD700);       // Tertiary Gold
```

---

## 3. Ký Duyệt Cổng 2 (Gate 2 Sign-Off)

- **Thiết kế bởi**: Sub-Agent UI/UX Designer (`ui-ux-designer`) — **APPROVED**
- **Đánh giá**: Chuẩn xác kích thước iOS WidgetKit & Android AppWidget, bảo toàn màu dinh dưỡng và phong cách Celestial Dark UI.
