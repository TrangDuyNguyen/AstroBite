# Architectural Spec & ADR-035: Deep Clean Polish & Warning Elimination (Sprint 29)

- **Trạng thái**: ✅ **APPROVED**
- **Ngày ban hành**: 2026-10-10
- **Tác giả**: Sub-Agent Tech Lead & System Architect (*"The Pragmatic System Architect"*)
- **Mã Epic / Feature**: `EPIC-REF-08` / `FEAT-S29-DEEP-CLEAN`
- **Phiên bản mục tiêu**: `v3.9.0`

---

## 1. Bối Cảnh & Vấn Đề Kỹ Thuật (Context & Problem Statement)

Codebase AstroBite đã đạt cột mốc lịch sử ở Sprint 28: **0 file vi phạm chặn cứng Hard Cap (> 500 dòng)**.
Tuy nhiên, vẫn còn 4 file nằm trong dải cảnh báo cao (> 400 dòng) cần đưa về dưới ngưỡng mục tiêu (< 200 dòng):
1. `analytics_page.dart` (497 dòng > 350 dòng)
2. `clay_bottom_nav.dart` (477 dòng > 350 dòng)
3. `coach_history_sheet.dart` (426 dòng > 350 dòng)
4. `meal_quick_log_card.dart` (401 dòng > 350 dòng)

Mục tiêu Sprint 29: **Giải phẫu toàn diện 4 file này, đưa toàn bộ về sâu dưới 180 dòng, nâng tỷ lệ codebase đạt chuẩn Deep Clean lên mức tối đa!**

---

## 2. Quyết Định Kiến Trúc (Architecture Decisions - ADR-035)

### 2.1. Phân rã `analytics_page.dart` (497 dòng ➔ < 180 dòng)
Tách thành 3 sub-widgets trong `lib/features/analytics/presentation/widgets/analytics_components/`:
- `analytics_period_selector.dart` (~65 dòng): Tactile clay segmented button chọn 7 ngày / 30 ngày.
- `analytics_kpi_overview_row.dart` (~100 dòng): 3 thẻ KPI (Calo TB, Cân nặng, Kỷ luật tuân thủ).
- `analytics_macro_breakdown_card.dart` (~80 dòng): Thẻ phân bổ tỷ lệ dinh dưỡng Carbs, Protein, Fat.

### 2.2. Phân rã `clay_bottom_nav.dart` (477 dòng ➔ < 160 dòng)
Tách thành 2 sub-widgets trong `lib/shared/ui_kit/navigation/bottom_nav_components/`:
- `clay_hero_camera_fab.dart` (~140 dòng): Hero Camera FAB 3D kèm cradle gốm sứ và squash physics.
- `clay_nav_item.dart` (~140 dòng): Thẻ item tab điều hướng kèm indicator gem và 3D emblem.

### 2.3. Phân rã `coach_history_sheet.dart` (426 dòng ➔ < 160 dòng)
Tách thành 2 sub-widgets trong `lib/features/coach/presentation/widgets/history_components/`:
- `coach_history_delete_dialog.dart` (~65 dòng): Hộp thoại xác nhận xóa phiên trò chuyện.
- `coach_history_session_card.dart` (~140 dòng): Thẻ phiên trò chuyện kèm preview tin nhắn và tag.

### 2.4. Phân rã `meal_quick_log_card.dart` (401 dòng ➔ < 160 dòng)
Tách thành 3 components trong `lib/features/coach/presentation/widgets/quick_log_components/`:
- `meal_quick_log_props.dart` (~65 dòng): Model DTO `MealQuickLogProps`.
- `meal_quick_log_portion_stepper.dart` (~65 dòng): Thanh điều chỉnh gram khẩu phần stepper.
- `meal_quick_log_macro_badges.dart` (~80 dòng): 3 huy hiệu Carbs, Protein, Fat bất biến.

---

## 3. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1. `analytics_page.dart` $< 180$ dòng (-63.8%).
2. `clay_bottom_nav.dart` $< 160$ dòng (-66.5%).
3. `coach_history_sheet.dart` $< 160$ dòng (-62.4%).
4. `meal_quick_log_card.dart` $< 160$ dòng (-60.1%).
5. Toàn bộ 4 file hoàn toàn rời khỏi danh sách cảnh báo (> 350 dòng).
6. 100% tests pass (322/322), `flutter analyze` 0 issues, 0 memory leak.
