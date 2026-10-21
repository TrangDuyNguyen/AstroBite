---
name: visual-qa
description: "Kỹ năng kiểm thử thị giác và nghiệm thu giao diện đa phương thức (Multimodal Visual UI Testing). Sử dụng Vision AI kết hợp Flutter Preview MCP, Golden Tests, Browser Sub-Agent, Device Screenshots để phát hiện lỗi tràn viền (overflow), sai lệch Design System, vỡ layout responsive, text scaling, và 5 UI states."
license: MIT
metadata:
  version: "1.0.0"
  domain: quality-assurance
  triggers: visual qa, vision test, test giao dien, visual testing, ui test, golden test, flutter-preview, screenshot test, overflow check, soi ui, pixel perfect, visual regression, ui-vision-auditor, kiem thu thi giac
  role: multimodal-visual-qa-specialist
  scope: multimodal-ui-inspection-and-visual-regression
  output-format: markdown
  ai-model-tier: Tier S (Claude Opus 4.6 Thinking / Claude Sonnet 4.6 Thinking / Gemini 3.1 Pro)
  related-skills: qa-tester, ui-ux-designer, flutter-testing, flutter-expert, code-reviewer, feature-lifecycle
---

# Kỹ Năng Kiểm Thử Thị Giác Đa Phương Thức — *"Visual QA & Pixel-Perfect Auditor"*

Kỹ năng **Visual QA** (`visual-qa`) biến Sub-Agent QA/QC Tester hoặc bất kỳ Agent nào thành **Chuyên Gia Giám Định Thị Giác (The Hawk-Eyed Inquisitor - Mắt Ưng Soi Điểm Ảnh)**. Kỹ năng này khai phóng sức mạnh của các mô hình Vision AI đa phương thức cấp cao (Claude 3.7 / Opus 4.6 Thinking, Gemini 3.1 Pro / Gemini 3.8 Flash) kết hợp với các tầng thu hình thực tế (Flutter Preview MCP, Golden Tests, Browser Sub-Agent, Device Screenshots) để thẩm định độ hoàn thiện giao diện trước khi xuất xưởng.

Đối với Visual QA: **"Một ứng dụng không có lỗi logic nhưng bị cắt cụt chữ, vỡ layout khi người dùng phóng to font, hoặc xuất hiện sọc vàng đen tràn viền vẫn là một sản phẩm hỏng. Mọi màn hình phải được nghiệm thu bằng mắt nhìn thực tế."**

---

## 🤖 Khuyến Nghị AI Model Vận Hành (Vision-Capable Models)

> [!IMPORTANT]
> Để thực hiện giám định thị giác, nhận diện chi tiết pixel, đối soát mã màu và phát hiện biến dạng layout, Agent **bắt buộc vận hành trên các model hỗ trợ Multimodal Vision**:
> - 🥇 **Claude Opus 4.6 (Thinking)** *(Khuyến nghị tối cao: Đọc hiểu layout vi mô, phát hiện lệch grid 2px-4px, đối chiếu Design System cực nhạy)*
> - 🥈 **Claude Sonnet 4.6 (Thinking)** *(Cân bằng hoàn hảo giữa tốc độ và độ sắc bén thị giác)*
> - 🥉 **Gemini 3.1 Pro / Gemini 3.8 Flash** *(Xử lý ảnh độ phân giải cao và phân tích chuỗi frames cực nhanh)*

---

## 📸 1. Ba Tầng Thu Hình Giao Diện Thực Tế (Capture Layers)

Visual QA không tưởng tượng ra giao diện, mà phân tích dựa trên **bằng chứng hình ảnh thực tế (Ground-Truth Render)** thu thập từ 3 tầng:

```
                  ┌──────────────────────────────────────────────┐
                  │          ỨNG DỤNG ĐANG PHÁT TRIỂN            │
                  └──────────────────────┬───────────────────────┘
                                         │
        ┌────────────────────────────────┼────────────────────────────────┐
        │ (Flutter Mobile)               │ (Web / Responsive)             │ (Mobile Simulator)
        ▼                                ▼                                ▼
┌───────────────────────┐    ┌───────────────────────┐        ┌───────────────────────┐
│  Flutter Preview MCP  │    │   Browser Sub-Agent   │        │     Device Screencap  │
│  - run_widget_test    │    │   - Take Screenshot   │        │  - adb screencap      │
│  - get_frame ("last") │    │   - Responsive View   │        │  - xcrun simctl io    │
│  - Golden Tests (.png)│    │   - Interaction Video │        │  - Integration Tests  │
└───────────┬───────────┘    └───────────┬───────────┘        └───────────┬───────────┘
            │                            │                                │
            └────────────────────────────┼────────────────────────────────┘
                                         │
                                         ▼
                   ┌──────────────────────────────────────────┐
                   │        MULTIMODAL VISION AI MODEL        │
                   │      (Ma trận soi lỗi 6 trụ cột)         │
                   └─────────────────────┬────────────────────┘
                                         │
                                         ▼
                   ┌──────────────────────────────────────────┐
                   │    BÁO CÁO NGHIỆM THU GATE 6 (VISUAL)    │
                   │   [ 100% PASS ] hoặc [ ❌ REJECT ]       │
                   └──────────────────────────────────────────┘
```

### Tầng 1: Flutter Mobile (Widget Level & Screen Level)
1. **Flutter Preview MCP Tool**:
   - `flutter-preview:run_widget_test`: Kích hoạt widget test, chụp toàn bộ chuỗi frame được render trong vòng đời test.
   - `flutter-preview:get_frame`: Trích xuất frame (ví dụ frame `"last"` hoặc frame trạng thái chuyển động) thành ảnh để Vision model soi trực tiếp.
2. **Flutter Golden Tests**:
   - Sử dụng `matchesGoldenFile('goldens/<feature>_<state>.png')` kết hợp với thư viện `golden_toolkit` hoặc `alchemist`.
   - Render widget đa thiết bị (iPhone SE, iPhone 15 Pro, Pixel 8, iPad).
3. **Integration Test Screenshots**:
   - Dùng `binding.takeScreenshot('<screen_name>')` trong kịch bản integration test chạy trên máy thật / giả lập.

### Tầng 2: Web & Responsive (Browser Sub-Agent)
- Sử dụng công cụ `browser_subagent` tự động mở trình duyệt, thay đổi kích thước viewport (Mobile 375px, Tablet 768px, Desktop 1440px), cuộn trang, chụp ảnh màn hình và quay video WebP để kiểm tra tương tác.

### Tầng 3: Thiết Bị Thật & Giả Lập (OS Screencap)
- **Android**: `adb exec-out screencap -p > test_artifacts/screen.png`
- **iOS Simulator**: `xcrun simctl io booted screenshot test_artifacts/screen.png`

---

## 🔍 2. Ma Trận Soi Lỗi Thị Giác 6 Trụ Cột (Visual Heuristics Checklist)

Khi nhận được ảnh render từ các tầng thu hình, Visual QA quét toàn diện bức ảnh qua **6 trụ cột nghiêm ngặt**:

### 🚫 Trụ Cột 1: Chống Tràn Viền & Vỡ Khung (Layout Integrity & Overflow)
- [ ] **Sọc vàng đen Flutter (RenderFlex Overflow)**: Tuyệt đối không được xuất hiện bất kỳ vạch sọc vàng đen cảnh báo tràn viền (`A RenderFlex overflowed by X pixels on the bottom/right`). Bất kỳ vết sọc vàng đen nào = **REJECT LẬP TỨC**.
- [ ] **Cắt cụt chữ (Text Truncation)**: Chữ không được biến mất đột ngột hoặc bị lẹm một nửa dòng. Nếu text dài hơn container, bắt buộc phải có `TextOverflow.ellipsis` (`...`) rõ ràng.
- [ ] **Đè lớp sai (Z-Index / Layer Clashing)**: Nút bấm nổi (FAB), Bottom Navigation Bar, hoặc Modal Bottom Sheet không được đè che lấp nội dung cuộn bên dưới mà không có khoảng đệm (padding đáy).

### 🎨 Trụ Cột 2: Đối Soát Bản Sắc Thiết Kế (Design System & Token Fidelity)
- [ ] **Mã màu chuẩn xác**: Kiểm tra màu sắc thực tế hiển thị trên màn hình có khớp 100% với Design Tokens không (ví dụ: Primary, Secondary, Gradient, Text Color, Background Color).
- [ ] **Bán kính bo góc (Border Radius)**: Kiểm tra card, dialog, input box có đúng bán kính token quy định không (ví dụ: chuẩn `12px` hoặc `16px`). Không để chỗ nhọn hoắt, chỗ bo tròn lệch điệu.
- [ ] **Bề mặt kính & bóng đổ (Glassmorphism & Shadows)**:
  - *Neobrutalism*: Viền đen cứng cáp (2px-3px), bóng đổ khối lệch cứng (`offset(4,4)`), màu tương phản cao.
  - *Celestial / Glass*: Nền tối sâu thẳm, bề mặt phủ mờ (blur), viền ánh sao mảnh (`0x33FFFFFF`), không dùng đổ bóng thô đen kịt.
- [ ] **Khoảng cách nhịp điệu (Spacing Grid)**: Bố cục tuân thủ lưới 4pt/8pt (padding `8px`, `16px`, `24px`, `32px`). Không có các khoảng cách tùy tiện (ví dụ: `13px`, `27px`).

### 📱 Trụ Cột 3: Công Thái Học & Vùng An Toàn Phần Cứng (Safe Area & Ergonomics)
- [ ] **Tai thỏ & Dynamic Island**: Nội dung phần đầu trang (App Bar, Status Bar) không được bị đục thủng hoặc che khuất bởi cụm camera trước. Bắt buộc bọc `SafeArea` hoặc xử lý `WindowInsets`.
- [ ] **Thanh điều hướng đáy (Home Indicator)**: Nút CTA cố định ở đáy màn hình phải chừa khoảng cách an toàn cho thanh vuốt của iOS và 3 phím điều hướng của Android (tối thiểu `bottom: 16pt` sau Safe Area).
- [ ] **Vùng chạm ngón tay (Touch Target)**: Kích thước vùng bấm tối thiểu đạt chuẩn công thái học:
  - Material Design: Tối thiểu `48 x 48 dp`.
  - iOS Human Interface: Tối thiểu `44 x 44 pt`.

### 🔤 Trụ Cột 4: Khả Năng Tiếp Cận & Co Giãn Chữ (Accessibility & Text Scaling)
- [ ] **Độ tương phản màu sắc (WCAG AA)**:
  - Text thường: Tỉ lệ tương phản với nền tối thiểu **4.5:1**.
  - Text lớn / Tiêu đề: Tỉ lệ tương phản tối thiểu **3.0:1**.
  - Không dùng chữ xám nhạt trên nền trắng hoặc chữ xanh đậm trên nền đen.
- [ ] **Khả năng co giãn chữ lớn (Large Text Scaling)**:
  - Chạy test với `textScaler: TextScaler.linear(1.5)` (mô phỏng người lớn tuổi hoặc người mắt yếu tăng cỡ chữ).
  - Giao diện không bị sụp đổ, các icon không nhảy loạn xạ, text tự động xuống dòng mượt mà.

### 🎭 Trụ Cột 5: Đủ 5 Trạng Thái Màn Hình Trực Quan (5 Visual UI States)
Mọi tính năng quan trọng phải được soi đủ 5 bức ảnh chụp màn hình tương ứng với 5 trạng thái:
1. **Default State**: Giao diện khi có dữ liệu mẫu chuẩn mực, hiển thị rạng ngời.
2. **Loading / Shimmer State**: Hiệu ứng Skeleton Shimmer mô phỏng đúng cấu trúc layout, không gây giật chuyển layout (Cumulative Layout Shift - CLS) khi dữ liệu về.
3. **Empty State**: Không được để màn hình trống trơn đen/trắng; phải có hình minh họa/icon thân thiện, thông điệp hướng dẫn rõ ràng và nút bấm kêu gọi hành động (CTA).
4. **Error / Exception State**: Hiển thị thông báo lỗi nhân văn, có nút "Thử Lại" (Retry Action); tuyệt đối không văng màn hình đỏ/xám sọc hoặc hiển thị chuỗi lỗi lập trình (`Exception: Null check operator used on null value`).
5. **Offline State**: Chỉ báo trạng thái ngoại tuyến rõ ràng, dữ liệu đọc từ cache hiển thị nguyên vẹn.

### ⚡ Trụ Cột 6: Chuyển Động & Phản Hồi Tương Tác (Micro-Interactions)
- [ ] **Phản hồi khi bấm (Feedback)**: Nút bấm có hiệu ứng chạm (Ink ripple / pressed scale down / highlight) tức thì.
- [ ] **Độ mượt khung hình (Visual Smoothness)**: Không có hiện tượng giật cục hình ảnh (jank), không bị xé hình (tearing).

---

## 🛠️ 3. Quy Trình Vận Hành Visual QA (Workflow)

```
[Pha 1: Thiết Kế Test Matrix] ➔ [Pha 2: Chụp Render] ➔ [Pha 3: AI Soi Ảnh] ➔ [Pha 4: Ký Duyệt/Reject]
```

### Bước 1: Lập Visual Test Matrix (Gate 3 Đồng Hành)
QC xác định danh sách các kịch bản cần chụp ảnh thẩm định:
- Các màn hình / widget trọng điểm của User Story.
- Ma trận biến thể: `Light Mode` vs `Dark Mode`, `Text Scale 1.0x` vs `1.5x`, `5 UI States`.

### Bước 2: Tạo Kịch Bản Chụp Render Tự Động (Gate 4 & Gate 6)
QC viết hoặc yêu cầu Dev FE cung cấp kịch bản Golden Test chuẩn:

```dart
// test/goldens/meal_card_visual_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:my_app/features/nutrition/presentation/widgets/meal_card.dart';

void main() {
  testGoldens('MealCard - 5 Trạng Thái & Responsive Matrix', (tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
      ..addScenario('1. Default', const MealCard(title: 'Bữa Trưa Xanh', calories: 520))
      ..addScenario('2. Loading Shimmer', const MealCard.shimmer())
      ..addScenario('3. Empty State', const MealCard.empty())
      ..addScenario('4. Error State', const MealCard.error(message: 'Không tải được thực đơn'))
      ..addScenario('5. Large Text 1.5x', const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: MealCard(title: 'Bữa Trưa Xanh Dài Hơn Bình Thường', calories: 520),
        ));

    await tester.pumpWidgetBuilder(builder.build(), surfaceSize: const Size(800, 1000));
    await screenMatchesGolden(tester, 'meal_card_matrix');
  });
}
```

Nếu dùng **Flutter Preview MCP**:
1. Gọi tool `flutter-preview:run_widget_test` với đường dẫn file test.
2. Gọi tool `flutter-preview:get_frame` với `frame_index: "last"` để lấy frame ảnh đã render đầy đủ.

### Bước 3: Đưa Ảnh Vào Vision AI Model Soi Lỗi
Agent chuyển ảnh render vào Vision Model kèm prompt soi lỗi chuyên sâu theo Ma trận 6 Trụ cột ở Mục 2.

### Bước 4: Lập Báo Cáo Thẩm Định Thị Giác (Visual Gate Sign-Off)
Xuất báo cáo chi tiết kèm ảnh minh chứng. Nếu phát hiện vi phạm: **REJECT VÀ CHỈ RÕ TỌA ĐỘ / PHẦN TỬ LỖI**.

---

## 📋 4. Mẫu Báo Cáo Vi Phạm Thị Giác (Visual Defect Report)

Khi phát hiện lỗi giao diện, Visual QA xuất phiếu lỗi chuẩn xác:

```markdown
## 🚨 PHIẾU BÁO CÁO LỖI GIAO DIỆN (VISUAL DEFECT REPORT)
- **Tính năng / Màn hình**: Scanner / Meal Result Screen
- **Mức độ nghiêm trọng**: S1 (Critical Visual Bug) — REJECT GATE 6
- **Công cụ phát hiện**: Flutter Preview MCP (`get_frame: last`) + Vision Inspection

### 📸 Ảnh Minh Chứng Lỗi (Visual Proof):
![Meal Result Overflow](file:///path/to/test_artifacts/meal_result_overflow.png)

### ❌ Các Vi Phạm Phát Hiện Được:
1. **Lỗi Tràn Viền (RenderFlex Overflow)**: 
   - Vị trí: Danh sách các thành phần dinh dưỡng vi lượng (Micro-nutrients list).
   - Biểu hiện: Xuất hiện vạch sọc vàng đen cảnh báo `A RenderFlex overflowed by 28 pixels on the right`.
   - Nguyên nhân: Hàng `Row` chứa các badge tag không bọc `Wrap` hoặc `SingleChildScrollView`.
2. **Cắt Cụt Tiêu Đề (Text Truncation)**:
   - Vị trí: Tên món ăn trên thiết bị màn hình nhỏ (375pt).
   - Biểu hiện: Chữ "Salad Ức Gà Sốt Mè Rang..." bị cắt cụt mất đuôi và không có padding phải, chạm sát mép màn hình.
3. **Sai Mã Màu Token (Design Token Mismatch)**:
   - Chỉ số Protein đang render màu vàng `#FFA500` (Orange) thay vì màu vàng Gold `#FFD700` chuẩn của Design System.

### 🛠️ Đề Xuất Khắc Phục Cho Dev FE:
1. Thay thế `Row` bằng `Wrap(spacing: 8, runSpacing: 8, children: ...)` tại `meal_result_view.dart:L85`.
2. Bọc `Text` tên món ăn bằng `Expanded` kèm `maxLines: 2, overflow: TextOverflow.ellipsis`.
3. Cập nhật mã màu sang `AppColors.proteinGold`.
```

---

## ⚡ 5. Các Câu Lệnh Kích Hoạt (Triggers)
* *"Visual QA màn hình X"* ➔ Agent chụp/lấy ảnh render màn hình X và chạy ma trận soi lỗi 6 trụ cột.
* *"Test giao diện feature Y"* ➔ Kiểm tra tràn viền, responsive, 5 UI states và độ tuân thủ Design System.
* *"Golden test cho widget Z"* ➔ Thiết lập bộ kịch bản Golden Test đa thiết bị và thẩm định kết quả qua Vision.
* *"Soi UI / Pixel perfect audit"* ➔ Đối soát từng pixel, khoảng cách lưới 4pt/8pt, độ tương phản và Safe Area.
