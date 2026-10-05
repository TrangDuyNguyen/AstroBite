# UI/UX Design Specification: Sprint 19 Multi-Region Food Culture Intelligence

- **Người thiết kế**: Sub-Agent UI/UX Designer (*The Celestial Aesthetic Purist*)
- **Người thẩm định**: Sub-Agent BA (*The Pedantic Logician*) & Sub-Agent PO (*The Strategic Tyrant*)
- **Chuẩn thiết kế**: Claymorphic × Duolingo 2D/3D (Lưới 4pt, bo góc tròn 20pt/24pt, màu dinh dưỡng bất biến)
- **Feature Code**: `FEAT-S19-GLOBAL-CUISINE` / `EPIC-GLOBAL`
- **Phiên bản mục tiêu**: `v2.9.0`
- **Màn hình trọng tâm**: `ScanReviewPage` (`lib/features/scanner/presentation/pages/scan_review_page.dart`)

---

## 1. Sơ Đồ Luồng Tương Tác Người Dùng (Mermaid User Flow)

```mermaid
flowchart TD
    A[Màn hình Camera / Scan Review] -->|Gemini Vision phân tích thành công| B[ScanReviewPage]
    
    B --> C{Món ăn có nước lèo? has_broth}
    C -->|true| D[Hiển thị Broth Toggle Chip bo góc 24pt]
    C -->|false| E[Ẩn Broth Toggle, giữ nguyên thẻ tiêu chuẩn]
    
    D -->|Tap Toggle: Chỉ ăn cái| F[Giao diện chuyển màu Mint: Giảm ~40% Calo & ~73% Natri]
    D -->|Tap Toggle: Ăn cả nước| G[Giao diện chuyển màu Sky Blue: Giữ nguyên 100% Calo]
    
    B --> H{Món ăn có toppings/combo? sub_items}
    H -->|isNotEmpty| I[Hiển thị Topping Mini Checklist - Wrap Chips]
    H -->|isEmpty| J[Ẩn Topping Checklist]
    
    I -->|Tap bỏ chọn chip Topping| K[Chip chuyển xám gạch ngang: Trừ trực tiếp calo topping]
    I -->|Tap chọn lại chip Topping| L[Chip sáng ClayCard: Cộng lại calo topping]
    
    F & G & K & L --> M[Cập nhật tức thì: ChunkyMacroBar & CalorieProgressArc < 16ms]
    M --> N[Bấm nút Duolingo 3D 'Lưu Bữa Ăn'] ➔ O[Ghi nhận nhật ký chính xác vào Firestore/Cache]
```

---

## 2. Bản Vẽ Bố Cục & Quy Chuẩn Lưới 4pt (Screen Layout Blueprint)

### 2.1. Thẻ Món Ăn Mở Rộng (`ClayDishCard` với Broth & Topping)
* **Mặt lưng thẻ**: `AppColors.surfaceContainer` (`#FFFFFF`), bo góc `20pt`, shadow 2 lớp nổi chuẩn Duolingo (`Offset(0, 8), blur 16` + `Offset(0, 3.5), blur 0`).
* **Padding nội bộ**: `16pt` xung quanh (Lưới 4pt).
* **Phần đầu thẻ (Header)**:
  * Tên món ăn: Font W800 `16pt`, màu `AppColors.onSurface` (`#1E2337` Deep Slate Berry).
  * Trọng lượng ước tính: `ClayMealChip` nhỏ xinh (`#F5F3EF`), chữ `AppColors.onSurfaceVariant` (`#78829A`).
  * Nút xóa món ăn: Icon thùng rác góc phải trên (Touch target `44x44pt`).

---

### 2.2. Khối Công Tắc Broth Toggle Component
* **Vị trí**: Ngay bên dưới tên món ăn, phía trên thanh phân bổ calo.
* **Kích thước**: Chiều cao `44pt` (đáp ứng chuẩn công thái học di động), bo góc `24pt` dạng Pill mềm mại.
* **2 Trạng thái trực quan**:
  1. **Trạng thái [🍜 Ăn cả nước]** *(Mặc định)*:
     - Nền: `AppColors.clayLunch` (`#E5F6FD` Sky Blue Pastel).
     - Viền: `1.5pt` màu `AppColors.primary` (`#1CB0F6` Duolingo Sky Blue).
     - Icon: `🍜` emoji 16pt.
     - Text: *"Ăn cả nước (+190 kcal)"* — Font W700 `13pt`, màu `#1CB0F6`.
     - Phụ đề nhỏ: *"Bao gồm 1,350mg Natri nước lèo"*.
  2. **Trạng thái [🥢 Chỉ ăn cái]** *(Đã kích hoạt)*:
     - Nền: `AppColors.clayMint` (`#E8F9D8` Lime Mint Pastel).
     - Viền: `1.5pt` màu `AppColors.brandGreen` (`#58CC02` Duolingo Lime Green).
     - Icon: `🥢` emoji 16pt.
     - Text: *"Chỉ ăn cái (-190 kcal)"* — Font W700 `13pt`, màu `#58CC02`.
     - Phụ đề nhỏ: *"Tiết kiệm 73% Muối & Mỡ béo ✨"*.
* **Micro-animation**: Hiệu ứng `AnimatedContainer` co giãn mượt mà thời lượng `200ms`, `Curves.easeInOutCubic` kèm phản hồi rung nhẹ `HapticFeedback.lightImpact()`.

---

### 2.3. Khối Topping Mini Checklist Component
* **Vị trí**: Dưới hàng Macro mini, cách lề trên `12pt`.
* **Tiêu đề nhóm**: Font W700 `12pt`, chữ in hoa nhẹ: `TOPPINGS & MÓN PHỤ (CHẠM ĐỂ BỎ BỚT)`.
* **Bố cục**: `Wrap(spacing: 8, runSpacing: 8)` bọc các chip topping tương tác.
* **Quy chuẩn Chip Topping (`ClayToppingChip`)**:
  * **Trạng thái Đang chọn (`is_selected == true`)**:
    - Nền: `#FFFFFF` Pure White, đổ bóng 3D `Offset(0, 2), blur 0` viền `#E8E5DF`.
    - Biểu tượng: Icon tròn xanh lá `✓`.
    - Text: `Sườn nướng (230 kcal)` — Font W700 `12pt`, màu `#1E2337`.
    - Touch target: Chiều cao `36pt`, padding ngang `12pt`.
  * **Trạng thái Bỏ chọn (`is_selected == false`)**:
    - Nền: `#F0EFEA` Slate Mờ, không đổ bóng, viền đứt nét hoặc xám nhạt `#D5D1C8`.
    - Biểu tượng: Icon gạch ngang `-` xám.
    - Text: `Mỡ hành (60 kcal)` — Chữ gạch ngang `TextDecoration.lineThrough`, màu xám nhạt `#A0A4B0`.

---

## 3. Quy Chuẩn 5 Trạng Thái Giao Diện Bắt Buộc (5 Screen States)

1. **Default State (Trạng thái bình thường)**:
   - Hiển thị đầy đủ thông tin món ăn, các nút Toggle và Topping Chips sẵn sàng cho tương tác 1 chạm.
   - Thao tác gạt toggle hoặc bỏ topping cập nhật ngay lập tức `ChunkyMacroBar` và `CalorieProgressArc` mà không làm giật màn hình (60 FPS).
2. **Loading / Shimmer State (Trạng thái tải)**:
   - Trong quá trình Gemini đang bóc tách món Việt, hiển thị `ClaySkeletonLoader` bao gồm:
     - 1 khung hình tròn đại diện ảnh món.
     - 1 khung chữ nhật bo góc `24pt` đại diện cho thanh Broth Toggle.
     - 3 khung nhỏ bo góc `16pt` đại diện cho các Topping Chips.
3. **Empty / Non-broth State (Trạng thái không áp dụng)**:
   - Nếu món ăn là món khô thuần túy (VD: Gỏi cuốn, Bánh cuốn không nước), khối Broth Toggle tự động ẩn đi hoàn toàn, không tạo ra bất kỳ khoảng cách trống hoặc vệt ngăn cách thừa nào (`SizedBox.shrink()`).
4. **Error / Corrupted Data State (Trạng thái dữ liệu lỗi)**:
   - Nếu phản hồi JSON từ Gemini thiếu trường `broth_calories` hoặc `broth_calories > calories`:
     - Tự động fallback coi như món ăn không có nước lèo (`has_broth = false`).
     - Hiển thị thông báo nhẹ dạng ClaySnackbar: *"Không thể xác định tỷ lệ nước dùng, giữ nguyên lượng calo gốc."*
5. **Offline State (Trạng thái ngoại tuyến)**:
   - Sử dụng bộ nhớ đệm cục bộ đã lưu, cho phép người dùng tùy chỉnh trạng thái toggle và lưu vào hàng đợi đồng bộ (`sync_queue`).

---

## 4. Bảng Ánh Xạ Design Tokens (Celestial Dark / Claymorphic System)

| Thành Phần UI | Token Sử Dụng | Giá Trị Màu / Kích Thước | Mục Đích |
| :--- | :--- | :--- | :--- |
| **Nền Canvas** | `AppColors.surface` | `#FAF8F5` (Warm Milk) | Nền dịu mắt, thân thiện |
| **Mặt Thẻ Món** | `AppColors.surfaceContainer`| `#FFFFFF` (Pure White) | Nổi bật thông tin dinh dưỡng |
| **Broth Toggle (Ăn nước)** | `AppColors.clayLunch` & `primary` | `#E5F6FD` / `#1CB0F6` | Màu xanh Duolingo Sky Blue |
| **Broth Toggle (Chỉ ăn cái)**| `AppColors.clayMint` & `brandGreen`| `#E8F9D8` / `#58CC02` | Màu xanh lá Duolingo Lime Green |
| **Topping Chip Active** | `AppColors.onSurface` | `#1E2337` (Deep Slate Berry) | Chữ đậm tương phản cao (> 13:1) |
| **Topping Chip Inactive** | `AppColors.onSurfaceVariant` | `#A0A4B0` + Line-through | Thể hiện topping đã bị loại bỏ |
| **Bo góc thẻ** | Token Radius Large | `20pt` | Phong cách Claymorphic mềm mại |
| **Bo góc Toggle** | Token Radius Pill | `24pt` | Công thái học ngón tay cái |
| **Khoảng cách lưới** | `AppValues.padding*` | `4, 8, 12, 16, 24pt` | Lưới 4pt nghiêm ngặt |

---

## 5. Handoff Checklist Dành Cho Dev FE (`flutter-core-dev`)

- [ ] Tạo widget con `BrothToggleChip` độc lập trong `lib/features/scanner/presentation/widgets/`.
- [ ] Tạo widget con `ToppingChecklistWrap` độc lập trong `lib/features/scanner/presentation/widgets/`.
- [ ] Tích hợp logic mutation state thông qua phương thức `toggleBroth()` và `toggleSubItem()` trong Riverpod controller.
- [ ] Bảo đảm touch target tối thiểu `44pt` cho nút Toggle và `36pt` cho Chip Topping.
- [ ] Tuyệt đối không hardcode mã màu hex, sử dụng 100% tokens từ `AppColors`.
