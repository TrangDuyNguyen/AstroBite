# 🎨 AstroBite — Puffy 3D Claymorphism Design System Specification

- **Hệ thống**: Puffy 3D Claymorphism × Duolingo Chunky
- **Sprint**: Sprint 13
- **Tác giả**: Sub-Agent UI/UX Designer (`ui-ux-designer`) + Tech Lead
- **Trạng thái**: ✅ **Gate 2 DESIGN SIGNED-OFF**
- **Cảm hứng**: [Claymorphism Kids Learning App — Hitesh Tapaniya (Dribbble)](https://dribbble.com/shots/27571529-Claymorphism-Kids-Learning-Mobile-App-UI-UX-Design)

---

## 1. Triết Lý Thiết Kế Puffy 3D Clay

Phong cách **Puffy 3D Claymorphism** nâng cấp từ Solar Fresh 2D lên trải nghiệm xúc giác hoàn toàn mới:

1. **Nền ấm dịu mắt (Warm Milk Canvas `#FAF8F5`)**: Nền sữa kem thay vì trắng tinh, tạo cảm giác ấm áp và thèm ăn.
2. **Bề mặt đất sét 3D phồng (Puffy 3D Clay Surfaces)**: Card trắng `#FFFFFF` với **gờ đáy cứng** (solid bottom bevel `3.5–4.5pt`) và bóng đổ mềm ambient — tạo chiều sâu 3D như đồ chơi đất sét thật.
3. **Hiệu ứng ánh sáng trên đỉnh (Glossy Top Highlight)**: Gradient trắng mờ 45%→0% alpha trên đỉnh FAB, macro bar, badge — bán sứ phồng 3D.
4. **Icon lò xo Morphicons (Spring-Physics Icon Morphing)**: Icon chuyển đổi với scale, rotation, fade qua `ClayMorphIcon` — lấy cảm hứng từ [Morphicons](https://www.morphicons.com/).
5. **Phản hồi xúc giác ép dẻo (Tactile Squash Feedback)**: Mỗi lần chạm, bề mặt co lại `0.95–0.98`, hạ gờ đáy xuống `1pt`, bóng ambient thu nhỏ.

---

## 2. Token Bảng Màu Puffy 3D Clay

```dart
// === Base & Canvas ===
AppColors.surface          = Color(0xFFFAF8F5); // Warm Milk Cream canvas
AppColors.surfaceContainer = Color(0xFFFFFFFF); // Pure White Clay cards
AppColors.shimmerBase      = Color(0xFFF0EFEB); // Warm soft shimmer base

// === Nutrients & Accents (BẤT BIẾN — KHÔNG ĐỔI MỤC ĐÍCH) ===
AppColors.primary          = Color(0xFF1CB0F6); // 🩵 Carbs / Duolingo Sky Blue
AppColors.secondary        = Color(0xFFFF5C8D); // 🍓 Fat / Strawberry Cream Pink
AppColors.tertiary         = Color(0xFFFF9600); // 🧡 Protein / Honey Tangerine Orange
AppColors.brandGreen       = Color(0xFF58CC02); // 🥑 Vitality / Duolingo Lime Green

// === Semantic Aliases ===
AppColors.carbs            = AppColors.primary;
AppColors.fat              = AppColors.secondary;
AppColors.protein          = AppColors.tertiary;

// === Clay Pastel Tints (Puffy Chips & Badges) ===
AppColors.clayBreakfast    = Color(0xFFFFF2D6); // Honey pastel
AppColors.clayLunch        = Color(0xFFE5F6FD); // Sky pastel
AppColors.clayDinner       = Color(0xFFF0E8FF); // Taro purple pastel
AppColors.claySnack        = Color(0xFFFFE8EE); // Strawberry milk pastel
AppColors.clayMint         = Color(0xFFE8F9D8); // Cucumber mint pastel

// === 3D Depth Colors (MỚI — Sprint 13) ===
const defaultBevelColor    = Color(0xFFDDD8CE); // Gờ đáy trắng clay
const cardBorderColor      = Color(0xFFEDE9E1); // Viền ấm đất sét
const primaryBevelColor    = Color(0xFF1488C2); // Gờ đáy xanh đậm (FAB, primary buttons)
const ambientShadowColor   = Color(0x181E2337); // Bóng mềm ambient 9.4% alpha

// === Typography (WCAG AAA/AA) ===
AppColors.onSurface        = Color(0xFF1E2337); // Deep Slate Berry (AAA > 13:1)
AppColors.onSurfaceVariant = Color(0xFF78829A); // Cool Slate (AA > 4.8:1)
AppColors.outline          = Color(0xFFE8E5DF); // Soft Clay border

// === Semantic Alerts ===
AppColors.success          = Color(0xFF58CC02); // Xanh thành tích
AppColors.warning          = Color(0xFFFF9600); // Cảnh báo cam
AppColors.error            = Color(0xFFEA2B2B); // Lỗi đỏ
```

---

## 3. Cấu Trúc Bóng 3D (Puffy Clay Shadow Recipe)

Mọi bề mặt nổi đều sử dụng **2 lớp bóng chuẩn hóa**:

| Lớp | Mục đích | Offset | Blur | Color |
|:----|:---------|:-------|:-----|:------|
| **Layer 1: Solid Bottom Bevel** | Tạo chiều sâu 3D đồ chơi | `Offset(0, 3.5)` | `0` | `#DDD8CE` hoặc lerp tối hơn |
| **Layer 2: Ambient Float** | Bóng mềm nổi | `Offset(0, 7.5)` | `14` | `9.4% #1E2337` |

### Quy Tắc Phái Sinh Màu Gờ Đáy

- **Bề mặt trắng**: dùng cố định `#DDD8CE`
- **Bề mặt tint (pastel)**: `Color.lerp(bgColor, Colors.black, 0.14)`
- **Bề mặt primary blue**: dùng cố định `#1488C2`

### Trạng Thái Khi Bấm (Pressed State)

| Thuộc tính | Default | Pressed |
|:-----------|:--------|:--------|
| Scale | `1.0` | `0.98` (card) / `0.95` (button) |
| Bevel offset | `3.5pt` | `1.0pt` |
| Ambient blur | `14` | `3–4` |
| Ambient offset | `7.5pt` | `2pt` |
| Duration | — | `100–120ms easeOutCubic` |

---

## 4. Kiến Trúc UI Kit & Danh Mục Thành Phần (`lib/shared/ui_kit/`)

Import duy nhất: `import 'package:astrobite/shared/ui_kit/ui_kit.dart';`

### 4.1 Bề Mặt (Surfaces)

- **`ClayCard`** (`surfaces/clay_card.dart`):
  - Nền `#FFFFFF`, bo `20pt`, viền `1.2px #EDE9E1`
  - Bóng: Solid bevel `Offset(0, 3.5)` + Ambient `Offset(0, 7.5), blur 14`
  - Squash `0.98` khi chạm, `AnimatedScale` 120ms
  - Hỗ trợ `bevelColor` override cho card có nền tint
  - *Alias: `SolarCard`*

- **`ClaySheet`** (`surfaces/clay_sheet.dart`):
  - Modal bottom sheet, bo đỉnh `24pt`, viền clay + pull handle

### 4.2 Nút Bấm 3D (Buttons)

- **`ClayButton`** (`buttons/clay_button.dart`):
  - Gờ đáy `3.5pt`, bo `16pt`, squash khi ấn
  - Biến thể: `primary` 🩵, `success` 🥑, `warning` 🧡, `danger` 🔴, `outline`
  - Tối thiểu `44pt` chiều cao

- **`ClayIconButton`** (`buttons/clay_icon_button.dart`):
  - Squircle `44×44pt`, bo `14pt`, gờ đáy `2.5pt`
  - Primary variant: nền Sky Blue + gờ `#1488C2`
  - Sử dụng `ClayMorphIcon` cho icon nội bộ
  - Squash `0.95` khi bấm

### 4.3 Nhập Liệu & Tìm Kiếm (Inputs)

- **`ClayTextField`** (`inputs/clay_text_field.dart`): Bo `16pt`, viền `#E8E5DF`, focus glow `#1CB0F6`
- **`ClaySearchBar`** (`inputs/clay_search_bar.dart`): Bo `16pt`, icon kính lúp, nút clear

### 4.4 Thước Đo & Phản Hồi (Indicators)

- **`ChunkyMacroBar`** (`indicators/chunky_macro_bar.dart`):
  - Thanh `14pt` cao, bo `10pt`, track: `12%` alpha + viền `20%` alpha + bevel lerp(color, black, 0.22)
  - **Highlight phản chiếu glossy** trên đỉnh `5pt` gradient trắng `45%→0%`
  - `TweenAnimationBuilder` 500ms `easeOutCubic`
  - *Alias: `MacroBar`*

- **`CalorieProgressArc`** (`indicators/calorie_progress_arc.dart`):
  - Arc: Sky Blue `#1CB0F6` bình thường → Tangerine `#FF9600` vượt mức
  - Track nền: `#EDE9E1`
  - Center: **đĩa đồng 3D clay** (72% kích thước arc) — bevel `2.5pt #DDD8CE`, ambient `blur 8`
  - Hiển thị: "X kcal còn lại" hoặc "+X kcal vượt"

- **`ClaySkeletonLoader`** (`indicators/clay_skeleton_loader.dart`): Shimmer base `#F0EFEB`

- **`ClayMorphIcon`** (`indicators/clay_morph_icon.dart`):
  - Spring-physics icon morphing (cảm hứng [Morphicons](https://www.morphicons.com/))
  - `AnimatedSwitcher` 280ms, `easeOutBack` / `easeInBack`
  - Scale `0.4→1.0`, Rotation `-0.12→0.0 turns`, Fade in/out

### 4.5 Phân Loại & Điều Hướng (Chips & Navigation)

- **`ClayMealChip`** (`chips/clay_meal_chip.dart`):
  - Capsule `24pt`, pastel: Sáng `#FFF2D6`, Trưa `#E5F6FD`, Tối `#F0E8FF`, Vặt `#FFE8EE`
  - Active: viền `1.8pt` + bóng sáng
  - *Alias: `MealTypeChip`*

- **`ClayBottomNav`** (`navigation/clay_bottom_nav.dart`):
  - Dock nổi capsule `33pt`, cao `64pt`, max width `368pt`
  - Bevel `4.5pt #DDD8CE` + ambient `blur 18`
  - Tab active: pill Sky Blue tint `#E5F6FD`, viền `#90D5F7`, bevel `#BCE3F7`
  - FAB Camera `54pt`: Sky Blue `#1CB0F6`, bevel `#1488C2`, glossy highlight, glow `35%` alpha blue
  - Tất cả icon dùng `ClayMorphIcon` cho spring morph
  - *Alias: `CelestialBottomNav`*

---

## 5. Ma Trận Trạng Thái Thành Phần

| Trạng thái | Xử lý trực quan |
|:-----------|:----------------|
| **Default** | Đầy đủ elevation, bevel, màu nền chuẩn |
| **Pressed** | Scale `0.95–0.98`, hạ bevel `1pt`, thu nhỏ ambient |
| **Focused** | Viền glow Sky Blue `#1CB0F6` |
| **Disabled** | Opacity `40%`, không bóng, không tương tác |
| **Loading** | `ClaySkeletonLoader` shimmer theo hình dáng component |
| **Error** | Viền hoặc text `#EA2B2B` + thông báo lỗi |

---

## 6. 5 Trạng Thái Màn Hình Bắt Buộc

| # | State | Mô tả |
|:--|:------|:------|
| 1 | **Default** | Dữ liệu đã tải, tất cả component hiển thị đầy đủ |
| 2 | **Loading (Shimmer)** | `ClaySkeletonLoader` đúng hình dáng của từng component |
| 3 | **Empty** | Hình minh họa thân thiện + CTA khuyến khích bắt đầu |
| 4 | **Error** | Card viền đỏ với nút retry |
| 5 | **Offline** | Dữ liệu cache + badge "Ngoại tuyến" |
