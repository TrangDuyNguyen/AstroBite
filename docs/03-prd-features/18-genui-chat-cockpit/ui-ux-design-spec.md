# Hồ Sơ Đặc Tả Thiết Kế Giao Diện (UI/UX Design Specification)
## FEAT-18: Generative UI Chat Cockpit (Sprint 11 — v2.0.0)

- **Mã tính năng**: `FEAT-18`
- **Mã Epic**: `EPIC-17` (Generative UI Chat Experience)
- **Tác giả**: Sub-Agent Mobile UI/UX Designer (`ui-ux-designer`) — *"The Celestial Aesthetic Purist"*
- **Tài liệu PRD tham chiếu**: [`docs/03-prd-features/18-genui-chat-cockpit/prd-genui-chat-cockpit.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/18-genui-chat-cockpit/prd-genui-chat-cockpit.md)
- **Ngày hoàn thiện**: 26/09/2026
- **Trạng thái**: 🟡 **Gate 2 Design Completed — Chờ BA, PO & Tech Lead Ký Duyệt**

---

## 🧭 1. Sơ Đồ Luồng Tương Tác Generative UI (Mermaid Flow)

```mermaid
graph TD
    classDef user fill:#112240,stroke:#1A73E8,stroke-width:2px,color:#FFFFFF;
    classDef ai fill:#0A192F,stroke:#00E5FF,stroke-width:1.5px,color:#FFFFFF;
    classDef widget fill:#192A46,stroke:#FFD700,stroke-width:2px,color:#FFFFFF;
    classDef action fill:#00E5FF,stroke:#1A73E8,stroke-width:1px,color:#0A192F;
    classDef success fill:#00E676,stroke:#00C853,stroke-width:1.5px,color:#0A192F;
    classDef err fill:#93000A,stroke:#FF69B4,stroke-width:1px,color:#FFFFFF;

    USER_INPUT["User gửi tin nhắn: 'Trưa nay ăn 150g ức gà?'"]:::user --> STREAM["A2UI Stream Receiver (Gemini 3.8 Flash)"]:::ai
    STREAM -->|Parsing Event| SHIMMER["Render Dynamic Widget Shimmer (< 0.5s)"]:::widget
    
    SHIMMER -->|Payload A2UI Ready| MATCH_CATALOG{"Tìm Component trong Catalog?"}
    MATCH_CATALOG -->|Có: 'MealQuickLogCard'| MEAL_CARD["Render MealQuickLogCard (GlassCard)"]:::widget
    MATCH_CATALOG -->|Có: 'MacroBudgetGauge'| GAUGE_CARD["Render MacroBudgetGauge (Dải tiến độ)"]:::widget
    MATCH_CATALOG -->|Có: 'QuickChoiceChips'| CHIPS_CARD["Render QuickChoiceChips (Dải nút)"]:::widget
    MATCH_CATALOG -->|Không / Text thuần| MD_FALLBACK["Fallback Markdown Bubble"]:::ai

    subgraph "Tương Tác Trên Thẻ MealQuickLogCard"
        MEAL_CARD -->|Bấm Stepper [-] [+]| RECALC["Co giãn Carbs/Fat/Protein tức thì (60 FPS)"]:::action
        MEAL_CARD -->|Bấm 'Ghi Vào Nhật Ký'| OPTIMISTIC_LOG["Optimistic Log to Food Diary (< 100ms)"]:::action
        OPTIMISTIC_LOG -->|Thành công| SUCCESS_STATE["Nút chuyển: '✓ Đã ghi nhận' (Disabled)"]:::success
        OPTIMISTIC_LOG -->|Mất mạng?| OFFLINE_QUEUE["Lưu Cache + Thêm vào Pending Sync Queue"]:::widget
    end

    subgraph "Tương Tác Trên Dải QuickChoiceChips"
        CHIPS_CARD -->|Chạm vào Chip Option| HAPTIC["Rung phản hồi nhẹ (Light Haptic)"]:::action
        HAPTIC -->|Auto-send text| STREAM
    end
```

---

## 🎨 2. Bản Vẽ Bố Cục 4pt Blueprint Của 3 Catalog Widgets

### 2.1. Component 1: `MealQuickLogCard` (Thẻ Món Ăn Tương Tác)
Được đóng gói dạng `GlassCard` nổi trong bong bóng chat của AI:

```
┌──────────────────────────────────────────────────────────────┐  ▲
│ 🍲 [Tên Món Ăn] (VD: Ức gà áp chảo sốt tiêu)                 │  │ 16pt Padding
│ 360 kcal  •  Khẩu phần: [ - ] 150g [ + ]                    │  │
├──────────────────────────────────────────────────────────────┤  ┼
│ 🔵 Carbs: 0.0g       🟡 Protein: 46.5g      🩷 Fat: 5.4g     │  │ 12pt Padding
│ [████████ 0%]        [██████████████ 85%]   [█████ 15%]      │  │ (3 Macro bất biến)
├──────────────────────────────────────────────────────────────┤  ┼
│ [⚡ GHI VÀO NHẬT KÝ (BỮA TRƯA)] (Touch target 48pt)          │  │ 16pt Padding
└──────────────────────────────────────────────────────────────┘  ▼
```

* **Quy chuẩn kích thước**:
  * Margin top/bottom: `8pt`
  * Padding trong: `16pt`
  * Bo góc: `16pt` (`BorderRadius.circular(16)`)
  * Màu nền: `AppColors.surfaceContainer` (`#112240`) phủ viền `AppColors.surfaceContainerHigh` (`#192A46`) độ dày `1.0pt`.

### 2.2. Component 2: `MacroBudgetGauge` (Đồng Hồ Tiến Độ Ngân Sách)
```
┌──────────────────────────────────────────────────────────────┐
│ 📊 TÁC ĐỘNG NGÂN SÁCH HÔM NAY                                │
│ Dự kiến nạp: +360 kcal   │   Còn lại sau khi ăn: 390 kcal    │
├──────────────────────────────────────────────────────────────┤
│ [████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] │
│ Target: 2,000 kcal  (Đạt 80.5% mục tiêu ngày)                 │
└──────────────────────────────────────────────────────────────┘
```
* **Màu sắc trạng thái**:
  * An toàn (`Remaining >= 0`): Dải tiến độ màu Primary Blue (`#1A73E8`) kết hợp xanh Cyan Neon (`#00E5FF`).
  * Vượt ngân sách (`Remaining < 0`): Dải cảnh báo Tertiary Amber (`#FFD700`) kèm icon `warning_amber_rounded`.

### 2.3. Component 3: `QuickChoiceChips` (Dải Nút Lựa Chọn Nhanh)
```
┌──────────────────────────────────────────────────────────────┐
│ [ 🥣 Bữa sáng ]   [ 🥗 Bữa trưa ]   [ 🥩 Giàu Protein ]      │
└──────────────────────────────────────────────────────────────┘
```
* **Quy chuẩn kích thước**:
  * Chiều cao Chip: `38pt` (Touch target bọc ngoài `44pt`).
  * Padding ngang: `14pt`, padding dọc: `8pt`.
  * Bo góc: `20pt` dạng Stadium Border.
  * Nền: `AppColors.surfaceContainerHigh` (`#192A46`), viền đổi màu Primary Neon khi chạm.

---

## 🌓 3. Quy Chuẩn 5 Trạng Thái Giao Diện Bắt Buộc (The 5 UI States)

| Trạng thái | Hành vi trực quan & Phản hồi người dùng |
| :--- | :--- |
| **1. Default State** | Thẻ GlassCard bóng bẩy, chữ sắc nét, độ tương phản text/background đạt chuẩn WCAG AA (`>= 4.5:1`). Nút CTA sẵn sàng nhận thao tác chạm. |
| **2. Loading / Shimmer** | Khi AI đang streaming JSON, khung thẻ hiện hiệu ứng Shimmer gradient chạy từ `#112240` sang `#192A46` theo chu kỳ 1.2s, giữ cố định chiều cao (min-height 120pt) để chống giật layout (Layout Shift). |
| **3. Empty State** | Nếu AI không tìm thấy dữ liệu dinh dưỡng cụ thể của món, hiển thị thẻ tinh giản kèm ô nhập gram thủ công và nút gợi ý tìm kiếm trong thư viện món ăn có sẵn. |
| **4. Error State** | Khi payload JSON bị lỗi schema hoặc không thể tạo component, fallback hiển thị dạng bubble tin nhắn cảnh báo màu đỏ rượu (`#93000A`) kèm nút **[Thử lại]** mà không làm crash app. |
| **5. Offline State** | Khi mất kết nối internet, nút bấm [Ghi vào nhật ký] vẫn bấm được bình thường (Optimistic UI), đính kèm nhãn phụ **"Chờ đồng bộ" (Pending Sync)** với icon đám mây gạch chéo màu xám bạc (`#8892B0`). |

---

## 🎨 4. Bảng Ánh Xạ Design Tokens (Celestial Dark UI Mapping)

| Token UI | Tên Hằng Số Code | Giá Trị Hex / Alpha | Mục Đích Sử Dụng |
| :--- | :--- | :---: | :--- |
| **Background Surface** | `AppColors.surface` | `#0A192F` | Nền toàn bộ khung chat. |
| **Card Container** | `AppColors.surfaceContainer` | `#112240` | Nền thẻ `MealQuickLogCard` & `MacroBudgetGauge`. |
| **Card Border** | `AppColors.surfaceContainerHigh` | `#192A46` | Viền nổi nhẹ 1.0pt cho các widget động. |
| **Carbs Indicator** | `AppColors.primary` | `#1A73E8` | **Bất biến**: Thanh đo Carbs, nút 1-Tap CTA. |
| **Protein Indicator**| `AppColors.tertiary` | `#FFD700` | **Bất biến**: Thanh đo Protein, cảnh báo vượt calo. |
| **Fat Indicator** | `AppColors.secondary` | `#FF69B4` | **Bất biến**: Thanh đo Fat chất béo. |
| **Success Feedback** | `AppColors.success` | `#00E676` | Trạng thái nút "✓ Đã ghi nhận". |
| **Primary Text** | `AppColors.textPrimary` | `#E6F1FF` | Tiêu đề món ăn, số calo lớn (20pt Bold). |
| **Secondary Text** | `AppColors.textSecondary` | `#8892B0` | Nhãn phụ, đơn vị gram, timestamp. |

---

## 📱 5. Công Thái Học Di Động (Mobile Ergonomics)

* **Quy chuẩn Lưới 4pt**: Toàn bộ padding, margin, khoảng cách giữa các phần tử là bội số của 4 (`4pt`, `8pt`, `12pt`, `16pt`, `24pt`).
* **Vùng Ngón Tay Cái (Thumb Zone)**:
  * Nút CTA **[Ghi vào nhật ký]** và **Quick Choice Chips** trải dài theo chiều ngang của card, đảm bảo người dùng cầm máy bằng 1 tay vẫn chạm tới dễ dàng.
  * Chiều cao touch target của toàn bộ các nút bấm và stepper đạt tối thiểu **`48x48pt`** (vượt chuẩn tối thiểu 44pt của Apple/Android).
