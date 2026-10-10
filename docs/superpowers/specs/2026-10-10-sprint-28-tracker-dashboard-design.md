# Architectural Spec & ADR-034: Daily Tracker & Dashboard Modular Clean Architecture (Sprint 28)

- **Trạng thái**: ✅ **APPROVED**
- **Ngày ban hành**: 2026-10-10
- **Tác giả**: Sub-Agent Tech Lead & System Architect (*"The Pragmatic System Architect"*)
- **Mã Epic / Feature**: `EPIC-REF-07` / `FEAT-S28-TRACKER-DASHBOARD`
- **Phiên bản mục tiêu**: `v3.8.0`

---

## 1. Bối Cảnh & Vấn Đề Kỹ Thuật (Context & Problem Statement)

Codebase AstroBite đã giải quyết thành công các God Files ở Camera Scanner, Gamification/Guilds, và Auth/Onboarding. Tuy nhiên, ở phân hệ cốt lõi **Daily Tracker & Dashboard**, vẫn còn 2 file vi phạm chặn cứng Hard Cap (> 500 dòng) và 2 file ở ngưỡng cảnh báo cao (> 400 dòng):
1. `custom_food_sheet.dart` (682 dòng > 500 dòng): Bottom sheet thêm món tùy chỉnh nhồi nhét header, validation, 3 trường thông số cơ bản và 3 bệ đỡ đa lượng (macro pedestals).
2. `home_page.dart` (552 dòng > 500 dòng): Màn hình chính gánh vác Widget sync, Quick meal plan actions, Bang hội banner, Nutrition log header, và AI Coach suggestion card.
3. `celestial_cockpit_card.dart` (452 dòng): Cockpit dinh dưỡng chứa vòng cung calo, thanh macro, ngăn kéo mở rộng vi chất (natri, chất xơ, đường) và logic progress bar.
4. `meal_detail_page.dart` (435 dòng): Trang chi tiết bữa ăn chứa overview card, danh sách món ăn, hộp thoại xác nhận xóa và empty state.

Mục tiêu tối thượng của Sprint 28: **Bóc tách triệt để 4 file này, đưa toàn bộ về dưới 200 dòng, quét sạch 100% các file vi phạm Hard Cap trên toàn bộ repository AstroBite!**

---

## 2. Quyết Định Kiến Trúc (Architecture Decisions - ADR-034)

### 2.1. Phân rã `custom_food_sheet.dart` (682 dòng ➔ < 180 dòng)
Tách thành 3 sub-widgets trong `lib/features/tracker/presentation/widgets/custom_food_sheet_components/`:
- `custom_food_sheet_header.dart` (~80 dòng): Header, meal badge & manual badge, close button.
- `custom_food_basic_inputs.dart` (~120 dòng): Tên món ăn (autofocus), khẩu phần gram, calo tiêu thụ.
- `custom_food_macro_pedestals.dart` (~100 dòng): 3 bệ đỡ nhập Carbs, Protein, Fat tactile clay tiles.

### 2.2. Phân rã `home_page.dart` (552 dòng ➔ < 160 dòng)
Tách thành 3 sub-widgets trong `lib/features/tracker/presentation/widgets/home_components/`:
- `home_astro_coach_suggestion_card.dart` (~110 dòng): Card gợi ý dinh dưỡng thông minh từ AstroCoach AI với nút điều hướng `CoachRoute`.
- `home_quick_actions_bar.dart` (~100 dòng): Hành động nhanh công thức món (`RecipesRoute`), kế hoạch 7 ngày (`MealPlannerRoute`) và banner Bang hội (`GuildRoute`).
- `home_nutrition_log_header.dart` (~75 dòng): Thanh tiêu đề nhật ký dinh dưỡng 4 bữa ăn kèm tổng calo / mục tiêu.

### 2.3. Phân rã `celestial_cockpit_card.dart` (452 dòng ➔ < 180 dòng)
Tách thành 2 sub-widgets trong `lib/features/tracker/presentation/widgets/cockpit_components/`:
- `cockpit_micronutrient_row.dart` (~110 dòng): Dòng hiển thị vi chất Natri, Xơ, Đường kèm mini progress bar và badge cảnh báo.
- `cockpit_micronutrients_drawer.dart` (~90 dòng): Ngăn kéo có thể thu gọn / mở rộng vi chất với biểu tượng Clay3D Flask.

### 2.4. Phân rã `meal_detail_page.dart` (435 dòng ➔ < 180 dòng)
Tách thành 3 sub-widgets trong `lib/features/tracker/presentation/widgets/meal_detail_components/`:
- `meal_detail_overview_card.dart` (~85 dòng): Thẻ tổng quan calo và 3 MacroPill (Carbs, Fat, Protein).
- `meal_detail_food_card.dart` (~75 dòng): Thẻ hiển thị món ăn kèm thông số dinh dưỡng và nút xóa.
- `meal_detail_empty_state.dart` (~65 dòng): Trạng thái rỗng khi bữa ăn chưa có món kèm nút CTA thêm món.

---

## 3. Tiêu Chí Nghiệm Thu (Acceptance Criteria)

1. `custom_food_sheet.dart` $< 180$ dòng (-73.6%).
2. `home_page.dart` $< 160$ dòng (-71.0%).
3. `celestial_cockpit_card.dart` $< 180$ dòng (-60.1%).
4. `meal_detail_page.dart` $< 180$ dòng (-58.6%).
5. **Số file vi phạm Hard Cap (> 500 dòng) trên toàn dự án: CHÍNH THỨC VỀ 0 FILE!**
6. 100% tests pass (322/322), `flutter analyze` 0 issues, 0 memory leak.
