# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 13
- **Tên Sprint**: Core Daily Loop — Navigation & Tracker Screen Overhaul
- **Mã Epic / Feature**: `EPIC-UI-REFRESH` / `FEAT-S13-TRACKER-NAV`
- **Phiên bản mục tiêu**: `v2.2.0`
- **Thời gian Sprint**: 11/10/2026 – 24/10/2026
- **Trạng thái Sprint**: 🟢 **DONE (10 / 10 SP — 100% Passed)**
- **Tổng Story Points cam kết**: **10 SP** (Tiến độ: **10 / 10 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 13: Core Daily Loop

1. **Shell Navigation Dock (`TSK-S13-01`)**: Di chuyển `ShellScreen` từ `CelestialBottomNav` sang `ClayBottomNav` (`lib/shared/ui_kit/navigation/clay_bottom_nav.dart`), hoàn thiện nút tròn Camera FAB 3D nhô cao với hiệu ứng đàn hồi `0.95` squash on press.
2. **Home Cockpit Dashboard (`TSK-S13-02`)**: Nâng cấp `home_page.dart` tích hợp `CalorieProgressArc` và 3 thanh `ChunkyMacroBar` (Carbs 🩵, Fat 🍓, Protein 🧡) trên cùng thẻ Cockpit `ClayCard`. 4 thẻ bữa ăn dùng `ClayCard` kèm màu pastel tints (`clayBreakfast`, `clayLunch`, `clayDinner`, `claySnack`).
3. **Manual Food Entry (`TSK-S13-03`)**: Tái cấu trúc `manual_entry_page.dart` sử dụng `ClaySearchBar`, `ClayTextField`, `ClayMealChip`, Quick Weight Steppers và nút lưu 3D `ClayButton`.
4. **Meal Detail Sheet & Page (`TSK-S13-04`)**: Nâng cấp `meal_detail_page.dart` hiển thị danh sách món ăn chi tiết dưới dạng `ClayCard`, tích hợp `ChunkyMacroBar` con và các nút thao tác xóa/sửa `ClayIconButton`.

---

## 📋 Bảng Kanban Sprint 13

### 1. 📝 BACKLOG / QUEUED — [0 SP]
*(Toàn bộ các task đã hoàn thành)*

### 2. ⚡ IN PROGRESS — [0 SP]
*(Không còn task đang thực hiện)*

### 3. 🏁 DONE — [10 SP]

| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S13-00-SPIKE` | Kiến trúc Navigation & Shell | **G0** | Tech Lead: Spike kiểm tra tích hợp `ClayBottomNav` vào `ShellScreen` không vỡ `AutoTabsScaffold` | `tech-lead` | 1 | 🟢 **DONE** |
| `TSK-S13-00-PRD` | `prd-s13-tracker-nav.md` | **G1** | BA: Soạn PRD & User Stories BDD chi tiết cho 4 màn hình (Shell, Home, ManualEntry, MealDetail) | `business-analyst` | 1 | 🟢 **DONE** |
| `TSK-S13-00-DESIGN` | Layout Blueprint 4pt | **G2** | UI/UX Designer: Thiết kế layout 4 màn hình, 5 trạng thái (Default, Shimmer, Empty, Error, Offline) | `ui-ux-designer` | 1 | 🟢 **DONE** |
| `TSK-S13-00-TEST-PLAN` | Test Cases & Gherkin | **G3** | QA Tester: Thiết kế Master Test Plan, Manual TCs (EP & BVA) và kịch bản Gherkin | `qa-tester` | 1 | 🟢 **DONE** |
| `TSK-S13-01-SHELL-NAV` | `ShellScreen` / `app_router.dart` | **G4** | Dev FE: Tích hợp `ClayBottomNav` vào `ShellScreen`, kiểm tra chuyển tab và Camera FAB | `flutter-core-dev` | 1 | 🟢 **DONE** |
| `TSK-S13-02-HOME-PAGE` | `home_page.dart` | **G4** | Dev FE: Nâng cấp Home Dashboard với `CalorieProgressArc`, `ChunkyMacroBar`, thẻ bữa ăn `ClayCard` | `flutter-core-dev` | 2 | 🟢 **DONE** |
| `TSK-S13-03-MANUAL-ENTRY` | `manual_entry_page.dart` | **G4** | Dev FE: Nâng cấp form tìm kiếm và ghi món với `ClaySearchBar`, `ClayTextField`, `ClayButton` | `flutter-core-dev` | 2 | 🟢 **DONE** |
| `TSK-S13-04-MEAL-DETAIL` | `meal_detail_page.dart` | **G4** | Dev FE: Nâng cấp Meal Detail với danh sách món dạng `ClayCard`, macro bar và action buttons | `flutter-core-dev` | 1 | 🟢 **DONE** |
| `TSK-S13-05-REVIEW` | Git diff Sprint 13 | **G5** | Reviewer: Ponytail Diff Review, triệt tiêu code rác, đảm bảo 0 bloat | `code-reviewer` | - | 🟢 **DONE** |
| `TSK-S13-06-QA-VERIFY` | Automated Test Suite | **G6** | QA Tester: Chạy toàn bộ test suite, kiểm tra visual regression, đo đạc FPS >= 55 | `qa-tester` | - | 🟢 **DONE** |
| `TSK-S13-07-RELEASE` | Tag release `v2.2.0` | **G7** | PO & Tech Lead: Thẩm định phát hành phiên bản thương mại `v2.2.0` | `product-owner` | - | 🟢 **DONE** |

---

## ✅ Định Nghĩa DONE Sprint 13

- [x] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [x] `flutter test` pass 100% (216/216 tests passed).
- [x] `ShellScreen` render đúng `ClayBottomNav` với 4 tabs và camera FAB nổi.
- [x] `HomePage` hiển thị chuẩn `CalorieProgressArc` và 3 thanh `ChunkyMacroBar` với màu sắc bất biến (Carbs 🩵 `#1CB0F6`, Fat 🍓 `#FF5C8D`, Protein 🧡 `#FF9600`).
- [x] `ManualEntryPage` và `MealDetailPage` thao tác mượt mà, Time-to-Log < 3.2s.
- [x] QA Gate 6 ký duyệt release `v2.2.0`.

## 🗺️ Lộ Trình Sprint Nâng Cấp Giao Diện Theo Màn Hình (Sprint 12–16)

| Sprint | Version | Tên Sprint & Nhóm Màn Hình Trọng Tâm | SP | Màn Hình Chi Tiết | Trạng Thái |
|:--|:--:|:---|:--:|:---|:---|
| **S12** | v2.1.0 | **Foundation & UI Kit Core** | 10 SP | `lib/shared/ui_kit/*` (ClayCard, ClayButton, ChunkyMacroBar, CalorieProgressArc, ClayMealChip, ClayBottomNav, ClayTextField) | 🟢 **DONE** |
| **S13** | v2.2.0 | **Core Daily Loop (Navigation & Tracker)** | 10 SP | `ShellScreen` (ClayBottomNav), `HomePage`, `ManualEntryPage`, `MealDetailPage` | 🟢 **DONE** |
| **S14** | v2.3.0 | **High-Value AI Experience (Scanner & Coach)** | 10 SP | `CameraPage` (AR HUD), `ScanReviewPage` (ClaySheet), `CoachPage` (GenUI Clay Cards) | 🟢 **DONE** |
| **S15** | v2.4.0 | **First Impression & Identity (Auth & Profile)** | 11 SP | `GoalSummaryPage`, `ProfilePage`, `ProfileEditPage`, `HealthConnectionPage` | 🟢 **DONE** |
| **S16** | v2.5.0 | **Deep Domain, Analytics & OS Widgets** | 9 SP | `AnalyticsPage`, `CalorieTrendChart`, `WeightTrendChart`, Android & iOS Home Widgets | 🟢 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 12 — AstroBite v2.1.0 Claymorphic UI Kit Foundation Reset (Hoàn tất 27/09/2026)
- **Mục tiêu**: Xây dựng bộ UI Kit chuẩn (`lib/shared/ui_kit/`), tokens `AppColors` & `AppTheme` Light Theme, `SolarCard`, `ClayButton`, `ChunkyMacroBar`, `CalorieProgressArc`, `ClayMealChip`, `ClayBottomNav`.
- **Kết quả**: **10 / 10 SP (100% Passed)** — 214/214 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/signoff-sprint-12.md`

### 🟢 Sprint 11 — AstroBite v2.0.0 Generative UI Chat Cockpit (Hoàn tất 26/09/2026)
- **Mục tiêu**: A2UI Protocol & Gemini 3.8 Flash Adapter, MealQuickLogCard, MacroBudgetGauge, QuickChoiceChips.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 198/198 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.0.0.md`

### 🟢 Sprint 10 — AstroBite v1.9.0 Custom Recipes & Meal Planning Architecture (Hoàn tất 26/09/2026)
- **Mục tiêu**: Interactive Recipe Builder (`US-01`), Dynamic Portion Scaler (`US-02`), Weekly Meal Planner Calendar (`US-03`), 1-Tap Log to Diary (`US-04`), Offline Resilience & Data Integrity.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 175/175 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.9.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.9.0.md)

### 🟢 Sprint 09 — AstroBite v1.8.0 - v1.8.2 AstroCoach Cockpit & Mascot Navigation (Hoàn tất 24/09/2026)
- **Mục tiêu**: Bảng điều khiển dinh dưỡng Context Header Strip, Holographic Bento Meal Card với 1-Tap Log, AstroBot Mascot Navigation Dock, Fastlane Release CI/CD pipeline.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 168/168 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.8.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.8.0.md)

### 🟢 Sprint 08 — AstroBite v1.7.0 Cinematic Celestial UI & AR HUD Scanner (Hoàn tất 24/09/2026)
- **Mục tiêu**: Kính ngắm AR HUD 60 FPS, telemetry viễn trắc, nhãn AI nổi, Holographic Bento Sheet, radial target gauge, bộ 3 Macro màu bất biến, kết nối Google Stitch MCP.
- **Kết quả**: **12 / 12 SP (100% Passed)** — 159/159 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.7.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.7.0.md)

### 🟢 Sprint 07 — AstroBite v1.6.0 Zero-Friction Ergonomic Logging (Hoàn tất 24/09/2026)
- **Mục tiêu**: Cắt giảm Time-to-Log < 3.5s, khay Recent Foods 1 chạm, Quick Weight Steppers, Sticky Bottom Action Bar trong Thumb Zone, Celestial Radar Pulse Viewfinder.
- **Kết quả**: **9 / 9 SP (100% Passed)** — 152/152 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.6.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.6.0.md)
