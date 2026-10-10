# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 22
- **Tên Sprint**: Core Tracker Clean Architecture & O(1) Meal Enums Overhaul
- **Mã Epic / Feature**: `EPIC-REF-01` / `FEAT-S22-TRACKER`
- **Phiên bản mục tiêu**: `v3.2.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026
- **Trạng thái Sprint**: 🟢 **COMPLETED (Gate 7 Approved)**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 22: Core Tracker Clean Architecture & O(1) Meal Enums Overhaul

1. **Kiến Trúc & Enhanced Enums O(1) (Gate 0 & Gate 1 — 3 SP)**: Thiết lập bộ Enhanced Enums chuẩn Dart 3 `MealType` và `NutrientType` đóng gói metadata (label, icon, color, calorieRatio, timeRange), xóa sổ toàn bộ Magic Strings trong phân hệ Tracker.
2. **Giải Phẫu God File `meal_section.dart` (1,224 dòng — 5 SP)**: Bóc tách thành 4 widgets chuyên biệt (`meal_card_header`, `meal_food_item_tile`, `food_detail_sheet`, `dishes_breakdown_section`, `macro_pill`, `calorie_portion_card`) đạt ngưỡng `< 200 dòng` (file chính 122 dòng).
3. **Giải Phẫu God File `manual_entry_page.dart` (969 dòng — 5 SP)**: Bóc tách thành Form nhập liệu theo từng component độc lập (`food_list_item_tile`, `food_portion_card`, `recent_foods_tray`, `manual_entry_bottom_bar`), bảo đảm chuẩn Ponytail, 0 lỗi analyze, duy trì 60 FPS và 306/306 tests pass.

---

## 📋 Bảng Kanban Sprint 22

### 1. 📝 BACKLOG / QUEUED — [0 SP]
*(Toàn bộ các task đã được thực thi và nghiệm thu hoàn tất)*

### 2. ⚡ IN PROGRESS — [0 SP]
*(Không còn công việc tồn đọng)*

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S22-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-22-tracker-refactoring-design.md` | **G0** | Tech Lead: Architectural Spec, O(1) Meal Enums & Feasibility Sign-Off | `tech-lead` | 1 | 🟢 **DONE** |
| `TSK-S22-01-PRD` | `docs/03-prd-features/29-tracker-refactoring/` | **G1** | BA: Soạn PRD & User Stories BDD luồng MealType và bóc tách | `business-analyst` | 2 | 🟢 **DONE** |
| `TSK-S22-02-DESIGN` | `docs/03-prd-features/29-tracker-refactoring/ui-design.md` | **G2** | UI/UX Designer: Kiểm định Widget tree & bố cục 4pt | `ui-ux-designer` | 2 | 🟢 **DONE** |
| `TSK-S22-03-TEST-PLAN` | `docs/03-prd-features/29-tracker-refactoring/gate-3-test.md` | **G3** | QA Tester: Thiết kế regression tests & test plan Gate 3 | `qa-tester` | 1 | 🟢 **DONE** |
| `TSK-S22-04-ENUMS` | `lib/core/constants/meal_enums.dart` | **G4** | Dev FE: Thiết lập MealType & NutrientType Enhanced Enums | `flutter-core-dev` | 1 | 🟢 **DONE** |
| `TSK-S22-05-MEALSECTION` | `features/tracker/presentation/widgets/meal_section.dart` | **G4** | Dev FE: Bóc tách `meal_section.dart` (1,224 ➔ 122 dòng) | `flutter-core-dev` | 3 | 🟢 **DONE** |
| `TSK-S22-06-MANUALENTRY` | `features/tracker/presentation/pages/manual_entry_page.dart` | **G4** | Dev FE: Bóc tách `manual_entry_page.dart` (969 ➔ 331 dòng) | `flutter-core-dev` | 2 | 🟢 **DONE** |
| `TSK-S22-07-UNITTESTS` | `test/core/constants/meal_enums_test.dart` | **G6** | QA/Dev: Viết bộ unit tests cho MealType & NutrientType | `qa-tester` | 1 | 🟢 **DONE** |


---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 21 — AstroBite v3.1.0 Social Guilds & Planetary Challenges (Hoàn tất 07/10/2026)
- **Mục tiêu**: Xây dựng Bang hội vi mô (tối đa 20 thành viên), mã mời 6 ký tự, Thử thách hành tinh tuần và đóng góp điểm Starlight XP tự động.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 289/289 tests pass thực chất, `flutter analyze` 0 issues, 60 FPS, Gate 7 Approved.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.1.0.md`

### 🟢 Sprint 20 — AstroBite v3.0.0 Hands-Free Voice Logging (AstroVoice AI) (Hoàn tất 05/10/2026)
- **Mục tiêu**: Bổ sung `EPIC-VOICE` cho phép người dùng nói tự nhiên bữa ăn tiếng Việt, nhận diện on-device (`speech_to_text`), Gemini 2.0 Flash NLU bóc tách món & đơn vị dân dã kèm suy luận bữa ăn 24h, hiển thị GenUI `MealQuickLogCard` và 1-Tap Log trong $< 150ms$.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 277/277 tests pass thực chất, `flutter analyze` 0 issues, SLA AI latency ~1.1s, 60 FPS, 0 memory leak.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.0.0.md`

### 🟢 Sprint 19 — AstroBite v2.9.0 Multi-Region Food Culture Intelligence (Hoàn tất 05/10/2026)
- **Mục tiêu**: Bóc tách ẩm thực Việt Nam / Châu Á (Phở, Bún bò, Cơm tấm...) với cơ chế nước dùng và topping độc lập qua Gemini 2.0 Flash Vision One-Pass, tích hợp Broth Toggle Chip và Topping Checklist Wrap.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 266/266 tests pass thực chất, `flutter analyze` 0 issues, SLA AI latency ~1.85s, 60 FPS, 0 memory leak.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.9.0.md`

### 🟢 Sprint 18 — AstroBite v2.8.0 Live Social Sync & Streak Nudge (Hoàn tất 04/10/2026)
- **Mục tiêu**: Hoàn thiện toàn diện `EPIC-COMMUNITY` với Firestore Stream Leaderboard và tính năng Streak Nudge qua FCM.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 256/256 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.8.0.md`

### 🟢 Sprint 17 — AstroBite v2.7.0 Social Accountability & Astro Leaderboard (Hoàn tất 04/10/2026)

- **Mục tiêu**: Tăng trưởng cộng đồng qua tính năng khoe thành tích Share Card và Astro Leaderboard.
- **Kết quả**: **11 / 11 SP (100% Passed)** — Tích hợp Native Share thành công với RepaintBoundary.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.7.0.md`

### 🟢 Sprint 16 — AstroBite v2.6.0 Deep Domain, Analytics & OS Widgets (Hoàn tất 03/10/2026)
- **Mục tiêu**: Bổ sung `AnalyticsPage` với biểu đồ `CalorieTrendChart`, `WeightTrendChart` và hệ thống Native OS Home Widget (`home_widget`) theo triết lý One-way sync.
- **Kết quả**: **9 / 9 SP (100% Passed)** — Toàn bộ test tự động đạt chuẩn, 0 lỗi, không sụt giảm FPS.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.6.0.md`

### 🟢 Sprint 15 — AstroBite v2.5.2 First Impression & Identity (Hoàn tất 30/09/2026)
- **Mục tiêu**: Nâng cấp trải nghiệm FTUX (First Time User Experience), Auth, Onboarding, và Profile với UI Kit `ClayCard` và nút bấm Duolingo.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 242/242 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.5.2.md`

### 🟢 Sprint 14 — AstroBite v2.3.0 High-Value AI Experience (Hoàn tất 29/09/2026)
- **Mục tiêu**: Nâng cấp `CameraPage` (Viewfinder bo góc 24pt, nút Shutter 3D tactile squash 0.92, haptic feedback), `ScanReviewPage` (ClaySheet, ChunkyMacroBar, ClayMealChip, nút lưu 3D Duolingo), `CoachPage` (bong bóng ClayCard, GenUI 1-Tap Log < 150ms).
- **Kết quả**: **10 / 10 SP (100% Passed)** — 242/242 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.3.0.md`

### 🟢 Sprint 13 — AstroBite v2.2.0 Core Daily Loop Tracker & Navigation (Hoàn tất 27/09/2026)
- **Mục tiêu**: Tái thiết kế `ShellScreen` (ClayBottomNav), `HomePage` (Cockpit `CalorieProgressArc` + `ChunkyMacroBar`), `ManualEntryPage` (ClaySearchBar + ClayTextField + Quick Steppers), `MealDetailPage`.
- **Kết quả**: **10 / 10 SP (100% Passed)** — 216/216 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.2.0.md`

### 🟢 Sprint 12 — AstroBite v2.1.0 Claymorphic UI Kit Foundation Reset (Hoàn tất 27/09/2026)
- **Mục tiêu**: Xây dựng bộ UI Kit chuẩn (`lib/shared/ui_kit/`), tokens `AppColors` & `AppTheme` Light Theme, `SolarCard`, `ClayButton`, `ChunkyMacroBar`, `CalorieProgressArc`, `ClayMealChip`, `ClayBottomNav`.
- **Kết quả**: **10 / 10 SP (100% Passed)** — 214/214 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/signoff-sprint-12.md`

### 🟢 Sprint 11 — AstroBite v2.0.0 Generative UI Chat Cockpit (Hoàn tất 26/09/2026)
- **Mục tiêu**: A2UI Protocol & Gemini 3.8 Flash Adapter, MealQuickLogCard, MacroBudgetGauge, QuickChoiceChips.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 198/198 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.0.0.md`
