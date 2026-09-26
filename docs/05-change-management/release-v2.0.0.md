# Bản Ghi Phát Hành (Release Notes) — AstroBite v2.0.0

- **Phiên bản**: `v2.0.0+12`
- **Mã Epic**: `EPIC-17` (Generative UI Chat Experience)
- **Mã Feature**: `FEAT-18` (Generative UI Chat Cockpit)
- **Chu kỳ Sprint**: Sprint 11 (26/09/2026 – 10/10/2026)
- **Ngày phát hành**: 26/09/2026
- **Trạng thái**: 🟢 **OFFICIALLY RELEASED TO PRODUCTION**

---

## 🌟 Điểm Nhấn Đột Phá Trong Phiên Bản v2.0.0

### 1. Kiến Trúc Flutter GenUI SDK & Giao Thức A2UI
* Chuyển hóa toàn diện AstroCoach Chat từ dạng văn bản thuần sang **Giao diện tương tác sinh động theo thời gian thực (Agent-to-User Interface)**.
* AI không chỉ tư vấn mà trực tiếp lắp ráp các widget Native Flutter vào khung chat theo đặc tả của Google Flutter GenUI ([docs.flutter.dev/ai/genui](https://docs.flutter.dev/ai/genui)).

### 2. Bộ 3 Thành Phần Dynamic Widgets (Catalog Items)
1. **`MealQuickLogCard`**:
   - Thẻ hiển thị món ăn gồm tên món, calo, bộ 3 Macro chuẩn màu bất biến: Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`.
   - Bộ điều chỉnh trọng lượng (Stepper -20g, +20g) tự động co giãn calo và macro.
   - Nút **[⚡ Ghi vào nhật ký ngay]** (1-Tap Log) cập nhật ngay lập tức vào Food Diary với độ trễ `< 100ms`.
2. **`MacroBudgetGauge`**:
   - Đồng hồ đo tiến độ so sánh lượng calo dự kiến của món ăn với ngân sách còn lại trong ngày.
   - Cảnh báo trực quan màu Tertiary Gold (`#FFD700`) khi món ăn làm vượt ngân sách calo.
3. **`QuickChoiceChips`**:
   - Dải các chip lựa chọn nhanh kích hoạt hành động phản hồi ngược cho AI bằng 1 chạm mà không cần gõ bàn phím.

### 3. Nâng Cấp AI Engine: Gemini 3.8 Flash Streaming
* Độ trễ phản hồi First Token/Component cực thấp: `< 1.2s`.
* Hỗ trợ Strict Structured JSON Schema, loại trừ 100% rủi ro lỗi cú pháp schema khi sinh UI.

---

## 📊 Thống Kê Đảm Bảo Chất Lượng
- **Tổng số Unit & Widget Tests**: **198 / 198 tests Passed (100%)**.
- **Static Analyzer**: `flutter analyze` 0 errors, 0 warnings.
- **Tốc độ khung hình (Frame Rate)**: 60 FPS mượt mà khi cuộn danh sách chat.

---

## 📲 Phân Phối Trực Tiếp Qua Firebase App Distribution

- **APK Binary**: `app-release.apk` (61.9 MB)
- **Firebase Console**: [Chi tiết bản phát hành trên Firebase Console](https://console.firebase.google.com/project/astrobite-dev/appdistribution/app/android:com.solopreneur.astrobite/releases/5lih1758dcc98?utm_source=firebase-tools)
- **Dành cho Testers**: [Tải bản build v2.0.0 (12)](https://appdistribution.firebase.google.com/testerapps/1:925552313324:android:31ea07eec9ad23375d36c9/releases/5lih1758dcc98?utm_source=firebase-tools)
- **Nhóm thử nghiệm**: `internal-testers`
