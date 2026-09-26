# ADR-06: Kiến Trúc Generative UI Chat Cockpit (Flutter GenUI Specification + Gemini 3.8 Flash A2UI)

- **Trạng thái**: 🟢 **ĐÃ PHÊ DUYỆT (Accepted - Gate 0 Passed)**
- **Chủ trì**: Sub-Agent Tech Lead (`tech-lead`) — *"The Pragmatic System Architect"*
- **Người thẩm định**: Sub-Agent Product Owner (PO)
- **Ngày ban hành**: 2026-09-26
- **Phạm vi kỹ thuật**: `EPIC-17` (Generative UI Chat Experience), `FEAT-18` (GenUI Chat Cockpit)
- **Phiên bản mục tiêu**: AstroBite `v2.0.0` (Sprint 11)

---

## 1. Bối Cảnh & Kết Quả Tech Spike (Context & Spike Discovery)

### 1.1. Hiện Trạng Kỹ Thuật (Legacy AstroCoach Chat)
* Trước Sprint 11, AstroCoach Chat trong `lib/features/coach/` hoạt động theo mô hình text chat thông thường kèm giải pháp nguyên mẫu thô sơ (pseudo-markdown code block ````astrobite-meal ... ```` hoặc comment HTML `<!--astrobite-meal:...-->`).
* Hạn chế: Dễ vỡ khi regex parse lỗi, không hỗ trợ cập nhật state 2 chiều (data binding), không có khái niệm Widget Catalog chuẩn mực, AI trả lời text nhiều gây nản cho người dùng.

### 1.2. Phát Hiện Trọng Yếu Từ Tech Spike (Spike Finding)
* **Khảo sát Package `genui` trên pub.dev**: Package `genui` hiện đang yêu cầu Dart SDK `>=3.9.2 <4.0.0`, trong khi môi trường máy trạm dự án sử dụng Dart SDK `3.7.2` (Flutter 3.x stable). Việc nâng cấp Flutter SDK hệ thống ngay lập tức tiềm ẩn rủi ro phá vỡ các thư viện Firebase native hiện hành.
* **Quyết Định Ponytail Cốt Lõi**:
  Thay vì chờ đợi bản release Dart tiếp theo hay ép dependency gây crash build, Tech Lead thiết kế module **AstroBite GenUI Core Engine** (`lib/core/genui/`) triển khai 100% chuẩn đặc tả của Google Flutter GenUI SDK ([docs.flutter.dev/ai/genui](https://docs.flutter.dev/ai/genui)):
  1. `Catalog` & `CatalogItem<T>`
  2. `SurfaceController` & `A2uiMessage`
  3. `DataModel` (Observable state store)
  4. `A2uiTransportAdapter` kết nối trực tiếp với **Gemini 3.8 Flash**.
  *Đánh dấu trần nâng cấp:* `// ponytail: upgrade to package:genui when project Dart SDK reaches >= 3.9.2`.

---

## 2. Quyết Định Kiến Trúc Chi Tiết (Architectural Decisions)

### 2.1. Quyết Định 1: Mô Hình A2UI (Agent-to-User Interface) Protocol

Gemini 3.8 Flash sẽ giao tiếp với Flutter Client thông qua định dạng A2UI JSON payload có cấu trúc chặt chẽ:

```json
{
  "surface": "chat_cockpit",
  "text": "Tôi đã tính toán bữa trưa phù hợp với lượng calo còn lại của bạn:",
  "components": [
    {
      "id": "comp_meal_01",
      "type": "MealQuickLogCard",
      "props": {
        "dishName": "Ức gà áp chảo sốt tiêu",
        "calories": 360,
        "protein": 38,
        "carbs": 12,
        "fat": 6,
        "sodium": 280,
        "mealType": "lunch",
        "defaultWeightG": 180
      }
    },
    {
      "id": "comp_gauge_02",
      "type": "MacroBudgetGauge",
      "props": {
        "projectedCalories": 360,
        "remainingCalories": 750,
        "targetCalories": 2000
      }
    }
  ]
}
```

### 2.2. Quyết Định 2: Bộ Danh Mục Widget Độc Lập (Catalog Items)

Đăng ký 3 CatalogItem chuẩn Celestial Dark UI:

1. **`MealQuickLogCard`**:
   - Thẻ hiển thị món ăn gồm tên món, calo nổi bật, 3 Macro chuẩn màu bất biến:
     - 🔵 **Carbs (`#1A73E8`)**
     - 🟡 **Protein (`#FFD700`)**
     - 🩷 **Fat (`#FF69B4`)**
   - Bộ điều chỉnh khẩu phần (Steppers: -20g, +20g).
   - Nút hành động chính **[1-Tap Log to Diary]** gọi trực tiếp `TrackerRepository` để lưu vào Firestore.

2. **`MacroBudgetGauge`**:
   - Đồng hồ so sánh Calo nạp vào dự kiến vs Ngân sách calo còn lại trong ngày.
   - Thể hiện trực quan dưới dạng vạch tiến độ phân tầng (Micro Arc/Bar).

3. **`QuickChoiceChips`**:
   - Dải các chip lựa chọn nhanh (ví dụ: `["Ăn sáng", "Ăn trưa", "Ăn tối", "Bữa phụ"]` hoặc `["Ăn nhiều đạm", "Ăn thanh đạm"]`).
   - Khi bấm, tự động gửi input text phản hồi lại cho AI để tiếp tục hội thoại.

### 2.3. Quyết Định 3: Gemini 3.8 Flash System Prompt & Tool Definition

Chuyển đổi hoàn toàn sang **Gemini 3.8 Flash**:
* Sử dụng Structured Outputs / Function Schemas tương ứng với danh sách `Catalog`.
* Độ trễ SLA: First Token/Component time `< 1.2s`.
* Fallback cơ chế: Nếu AI trả về text thông thường không có component, app vẫn render bong bóng chat Markdown bình thường.

---

## 3. Đánh Giá Hậu Quả & Rủi Ro (Consequences & Trade-offs)

### Ưu điểm (Positive)
* **Zero Dependency Conflict**: Hoàn toàn tương thích với Flutter/Dart hiện tại, không gây lỗi xung đột pubspec.
* **Tốc độ vượt trội**: Tối ưu hóa code trực tiếp bằng native Flutter Widgets, giữ vững 60 FPS khi cuộn.
* **Bảo mật & Dễ kiểm thử**: Các `CatalogItem` được test riêng biệt bằng widget tests (`flutter_test`).

### Hạn chế & Giảm thiểu (Mitigation)
* Cần bảo đảm prompt của Gemini 3.8 Flash luôn trả về đúng component types đã đăng ký trong `Catalog`.
* Xử lý trường hợp component type lạ bằng `UnknownCatalogWidget` để tránh crash app.

---

## 4. Ký Duyệt Gate 0 (Feasibility Sign-Off)

- **Tech Lead**: Sub-Agent Tech Lead (`tech-lead`)
- **Phán quyết**: 🟢 **APPROVED — KHẢ THI 100%**
- **Bàn giao**: Chuyển giao sang **Gate 1 (Sub-Agent BA)** soạn thảo PRD chi tiết.
