# Architectural Spec & ADR-029: AI Coach & Scan Review Decomposition

- **Feature**: `FEAT-S23-COACH-SCANNER` (Epic: `EPIC-REF-02`)
- **Author**: Sub-Agent Tech Lead (`tech-lead`)
- **Status**: 🟢 **Approved (Gate 0 Feasibility Sign-Off)**
- **Target Release**: `v3.3.0`
- **Date**: 2026-10-10

---

## 1. Bối Cảnh & Vấn Đề Kỹ Thuật (Context & Problem Statement)

Sau khi hoàn thành Sprint 22 giải phẫu phân hệ Tracker và Profile, công cụ đo kiểm `scripts/check_file_length.sh` phát hiện 2 God Files có kích thước lớn nhất toàn bộ codebase:
1. `lib/features/coach/presentation/coach_page.dart`: **2,153 dòng** (vượt gấp 4.3 lần Hard Cap 500 dòng).
   - Ôm đồm: Context Header (Macro mini bar), Empty State + Quick actions, Chat Bubble + Markdown + Copy action, Holographic 1-Tap Meal Card, Input bar + Voice/STT handling, Typing indicator + Bouncing dots.
2. `lib/features/scanner/presentation/pages/scan_review_page.dart`: **1,482 dòng** (vượt gấp 3 lần Hard Cap 500 dòng).
   - Hàm `build()` chính dài hơn 650 dòng.
   - Chứa 6 private widgets nội bộ: `_DishItemCard`, `_MiniMacro`, `_MacroIndicator`, `_CalorieTargetRadialGauge`, `_QuickReviewWeightChip`, `_TactileActionButton`.

---

## 2. Quyết Định Kiến Trúc: ADR-029

### 2.1. Phân Tách `coach_page.dart` (2,153 dòng ➔ < 350 dòng)
Trích xuất 6 modular sub-widgets đặt tại `lib/features/coach/presentation/widgets/`:
1. `coach_context_header.dart` (< 200 dòng): Thanh tóm tắt dinh dưỡng ngày, thanh macro tiến độ mini và calo còn lại.
2. `coach_empty_state.dart` (< 150 dòng): Màn hình trống đón chào, lời khuyên và danh sách gợi ý bắt đầu câu hỏi.
3. `coach_chat_bubble.dart` (< 250 dòng): Bong bóng tin nhắn AI và người dùng, hiển thị Markdown, nút sao chép và timestamp.
4. `coach_meal_card.dart` (< 220 dòng): Thẻ gợi ý món ăn thông minh Holographic ClayCard, tích hợp 1-Tap Log `< 150ms` và chi tiết macro.
5. `coach_input_bar.dart` (< 250 dòng): Thanh nhập tin nhắn, nút mic ghi âm giọng nói STT (`speech_to_text`), trạng thái đang nghe và nút gửi 3D.
6. `coach_typing_indicator.dart` (< 150 dòng): Hiệu ứng AI đang phản hồi với 3 chấm nảy sinh động `_BouncingMacroDots`.

### 2.2. Phân Tách `scan_review_page.dart` (1,482 dòng ➔ < 350 dòng)
Trích xuất 5 modular sub-widgets đặt tại `lib/features/scanner/presentation/widgets/`:
1. `scan_dish_item_card.dart` (< 220 dòng): Component thẻ món ăn trong bữa ăn đa món (Multi-dish scan), điều chỉnh gram và phân rã macro.
2. `scan_macro_gauge_section.dart` (< 200 dòng): Cụm hiển thị đồng hồ calo tròn (`_CalorieTargetRadialGauge`), thanh macro tiến độ (`_MacroIndicator`) và `_MiniMacro`.
3. `scan_quick_weight_stepper.dart` (< 150 dòng): Các chip bước nhảy khối lượng nhanh (`+50g`, `1 Bát`, `1 Đĩa`).
4. `scan_review_hero_card.dart` (< 220 dòng): Thẻ Hero hiển thị ảnh món, tên món ăn, độ tin cậy AI (Confidence badge) và nút mở Sheet chỉnh sửa món.
5. `scan_review_action_bar.dart` (< 150 dòng): Nút bấm xúc giác 3D Duolingo `_TactileActionButton` để Lưu vào Nhật Ký (`Save to Diary`).

---

## 3. Thẩm Định Tính Khả Thi & Cam Kết SLAs (Feasibility Sign-Off)
- **Cold Start & Render**: Duy trì 60 FPS mượt mà nhờ giảm triệt để cây Widget lồng sâu trong `build()`.
- **Độ dài tệp**: Tất cả các tệp mới và tệp chính đều đạt chuẩn Ponytail `< 350 dòng`.
- **Tương thích ngược**: Giữ nguyên toàn bộ StateNotifier/AsyncNotifier Riverpod và các route AutoRoute. 100% test suite hiện có phải pass không cần sửa logic nghiệp vụ.
