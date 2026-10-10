# UI/UX Layout Blueprint: AI Coach & Scan Review (Sprint 23)

- **Sub-Agent**: `ui-ux-designer`
- **Design Tokens**: Celestial Dark & Puffy Claymorphism (4pt spacing grid, 20pt card corner radius, WCAG AAA)
- **Status**: 🟢 **Gate 2 Design Sign-Off**

---

## 🎨 1. Sơ Đồ Cấu Trúc Thành Phần Màn Hình AI Coach

```mermaid
graph TD
  CoachPage["CoachPage (< 350 lines)"]
  CoachPage --> Header["CoachContextHeader (Padding 16pt, Progress Minibars)"]
  CoachPage --> ChatBody["ListView / ChatTimeline"]
  ChatBody --> EmptyState["CoachEmptyState (ClayCard, Tips & Quick Prompts)"]
  ChatBody --> Bubbles["CoachChatBubble (User & Assistant Markdown)"]
  ChatBody --> MealCard["CoachMealCard (1-Tap Holographic Card, Squash 0.98)"]
  ChatBody --> TypingDots["CoachTypingIndicator (Bouncing Macro Dots)"]
  CoachPage --> InputBar["CoachInputBar (ClayTextField + STT Mic Button + 3D Send)"]
```

### Chi Tiết Kích Thước & Spacing 4pt:
- **`CoachContextHeader`**: Margin top 8pt, padding horizontal 16pt, vertical 12pt, bo góc 20pt.
- **`CoachChatBubble`**: Padding 14pt, bo góc 18pt, đuôi bong bóng offset 4pt. User bubble nền `AppColors.primary`, Assistant bubble nền `AppColors.surfaceContainer`.
- **`CoachMealCard`**: Bo góc 20pt, viền Clay border `outline`, nút 1-Tap Log cao 48pt với hiệu ứng bóng 3D bevel 3.5pt.
- **`CoachInputBar`**: Nền trắng đục/clay, padding 12pt, mic icon 44x44pt chuẩn công thái học.

---

## 🎨 2. Sơ Đồ Cấu Trúc Thành Phần Màn Hình Scan Review

```mermaid
graph TD
  ScanReviewPage["ScanReviewPage (< 350 lines)"]
  ScanReviewPage --> Hero["ScanReviewHeroCard (Image, Food Title, Confidence Pill)"]
  ScanReviewPage --> Gauges["ScanMacroGaugeSection (Radial Gauge + 3 Macro Bars)"]
  ScanReviewPage --> Steppers["ScanQuickWeightStepper (+50g, 1 Bát, 1 Đĩa)"]
  ScanReviewPage --> DishList["ScanDishItemCard (Multi-dish List & Gram Sliders)"]
  ScanReviewPage --> ActionBar["ScanReviewActionBar (3D Save Button, Duolingo Style)"]
```

### Chi Tiết Kích Thước & Spacing 4pt:
- **`ScanReviewHeroCard`**: Hero Image bo góc 20pt, độ cao 200pt, confidence badge bo tròn 16pt.
- **`ScanMacroGaugeSection`**: Vòng tròn Radial Gauge đường kính 140pt, 3 thanh macro cao 12pt với nhãn 11pt.
- **`ScanDishItemCard`**: Chiều cao linh hoạt, padding 16pt, slider bo tròn với thumb 24x24pt.
- **`ScanReviewActionBar`**: Nút lưu 3D Duolingo chiều cao 52pt, bevel 4pt, màu xanh chủ đạo `AppColors.primary`.
