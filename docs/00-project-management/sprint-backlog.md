# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 24
- **Tên Sprint**: Recipes & Meal Planning God Files Elimination
- **Mã Epic / Feature**: `EPIC-REF-03` / `FEAT-S24-RECIPES`
- **Phiên bản mục tiêu**: `v3.4.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 24: Recipes & Meal Planning God Files Elimination

1. **Kiến Trúc & Bóc Tách Recipes Feature (Gate 0 & Gate 1 — 3 SP)**: Ban hành Architectural Spec ADR-030 & PRD giải phẫu 2 God Files lớn nhất: `recipe_builder_page.dart` (984 dòng) và `recipes_page.dart` (646 dòng).
2. **Giải Phẫu God File `recipe_builder_page.dart` (984 dòng — 5 SP)**: Bóc tách thành 5 sub-widgets chuyên trách, đưa file chính về **245 dòng** (< 350 dòng, -75.1%).
3. **Giải Phẫu God File `recipes_page.dart` (646 dòng — 5 SP)**: Bóc tách thành 3 sub-widgets chuyên biệt, đưa file chính về **161 dòng** (< 350 dòng, -75.1%).

---

## 📋 Bảng Kanban Sprint 24

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S24-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-24-recipes-refactoring-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-030 cho Recipes Refactoring | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S24-01-PRD` | `docs/03-prd-features/31-recipes-refactoring/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Recipe & Ingredients | `business-analyst` | 2 | 🏁 **DONE** |
| `TSK-S24-02-DESIGN` | `docs/03-prd-features/31-recipes-refactoring/ui-design.md` | **G2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | 🏁 **DONE** |
| `TSK-S24-03-TEST-PLAN` | `docs/03-prd-features/31-recipes-refactoring/gate-3-test.md` | **G3** | QA Tester: Regression Test Plan cho Recipes | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S24-04-BUILDER` | `features/recipes/presentation/pages/recipe_builder_page.dart` | **G4** | Dev FE: Bóc tách `recipe_builder_page.dart` (984 ➔ 245 dòng) | `flutter-core-dev` | 4 | 🏁 **DONE** |
| `TSK-S24-05-RECIPES` | `features/recipes/presentation/pages/recipes_page.dart` | **G4** | Dev FE: Bóc tách `recipes_page.dart` (646 ➔ 161 dòng) | `flutter-core-dev` | 3 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 23 — AstroBite v3.3.0 AI Coach & Scanner God Files Elimination (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `coach_page.dart` (2,153 ➔ 344 dòng) và `scan_review_page.dart` (1,482 ➔ 340 dòng) thành 19 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 320/320 tests pass thực chất, `flutter analyze` 0 issues, Gate 7 Approved.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.3.0.md`

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 22 — AstroBite v3.2.0 Core Tracker Clean Architecture & O(1) Meal Enums (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `meal_section.dart` (1,224 ➔ 122 dòng) và `manual_entry_page.dart` (969 ➔ 331 dòng), thiết lập Enhanced Enums `MealType`, `NutrientType` O(1) và thư mục `core/utils/`.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 320/320 tests pass, `flutter analyze` 0 issues, Gate 7 Approved.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.2.0.md`

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
