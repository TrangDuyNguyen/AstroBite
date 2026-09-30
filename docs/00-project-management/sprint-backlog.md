# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 15
- **Tên Sprint**: First Impression & Identity (Auth, Onboarding, Profile)
- **Mã Epic / Feature**: `EPIC-UI-REFRESH` / `FEAT-S15-FTUX`
- **Phiên bản mục tiêu**: `v2.4.0`
- **Thời gian Sprint**: 30/09/2026 – 14/10/2026
- **Trạng thái Sprint**: 🏁 **DONE**
- **Tổng Story Points cam kết**: **14 SP** (Tiến độ: **14 / 14 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 15: First Impression & Identity

1. **Auth UI Update (`TSK-S15-AUTH` — 3 SP)**: Nâng cấp trải nghiệm đăng nhập, đăng ký với `ClayCard` và nút bấm 3D Duolingo.
2. **Onboarding & Goal Setup (`TSK-S15-ONBOARD` — 4 SP)**: Tái thiết kế luồng nhập dữ liệu cá nhân, tính toán BMR/TDEE trực quan với Celestial UI.
3. **Profile & Health Connection (`TSK-S15-PROFILE` — 4 SP)**: Cải tiến trang hồ sơ và giao diện đồng bộ HealthKit/HealthConnect với các widget Claymorphic.

---

## 📋 Bảng Kanban Sprint 15

### 1. 📝 BACKLOG / QUEUED — [0 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| Không có task | | | | | | |

### 2. ⚡ IN PROGRESS — [0 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| Không có task | | | | | | |

### 3. 🏁 DONE — [11 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S15-00-SPIKE` | Kiến trúc FTUX UI Kit | **G0** | Tech Lead: Spike kiến trúc `ClayCard` | `tech-lead` | 1 | 🟢 **DONE** |
| `TSK-S15-00-PRD` | `prd-s15.md` | **G1** | BA: Soạn PRD & User Stories BDD chi tiết | `business-analyst` | 1 | 🟢 **DONE** |
| `TSK-S15-00-DESIGN` | `ui-ux-design-spec.md` | **G2** | UI/UX Designer: Lập Layout Blueprint lưới 4pt, 5 trạng thái | `ui-ux-designer` | 1 | 🟢 **DONE** |
| `TSK-S15-00-TEST-PLAN` | `gate-3-test-plan.md` | **G3** | QA Tester: Thiết kế Master Test Plan, Manual TCs | `qa-tester` | 1 | 🟢 **DONE** |
| `TSK-S15-AUTH` | `auth_page.dart` | **G4** | Dev FE: Nâng cấp UI Đăng nhập/Đăng ký | `flutter-core-dev` | 3 | 🟢 **DONE** |
| `TSK-S15-ONBOARD` | `onboarding.dart` | **G4** | Dev FE: Luồng thiết lập BMR/TDEE | `flutter-core-dev` | 4 | 🟢 **DONE** |
| `TSK-S15-PROFILE` | `profile_page.dart` | **G4** | Dev FE: ProfilePage, HealthConnectionPage | `flutter-core-dev` | 3 | 🟢 **DONE** |
| `TSK-S15-04-REVIEW` | Git diff Sprint 15 | **G5** | Reviewer: Ponytail Diff Review | `code-reviewer` | - | 🟢 **DONE** |
| `TSK-S15-05-QA-VERIFY` | Automated Test Suite | **G6** | QA Tester: Test pass 100%, FPS $\ge 55$, 0 memory leak | `qa-tester` | - | 🟢 **DONE** |
| `TSK-S15-06-RELEASE` | Tag release `v2.4.0` | **G7** | PO, Tech Lead & PM: Thông cáo phát hành | `product-owner` | - | 🟢 **DONE** |

---

## ✅ Định Nghĩa DONE Sprint 15

- [x] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [x] `flutter test` pass 100%.
- [x] Các màn hình Auth, Onboarding, Profile hiển thị đúng chuẩn Claymorphic Celestial.
- [x] QA Gate 6 và Security Auditor Gate 6.5 ký duyệt release `v2.4.0`.

---

## 🗺️ Lộ Trình Sprint Nâng Cấp Giao Diện Theo Màn Hình (Sprint 12–16)

| Sprint | Version | Tên Sprint & Nhóm Màn Hình Trọng Tâm | SP | Màn Hình Chi Tiết | Trạng Thái |
|:--|:--:|:---|:--:|:---|:---|
| **S12** | v2.1.0 | **Foundation & UI Kit Core** | 10 SP | `lib/shared/ui_kit/*` | 🟢 **DONE** |
| **S13** | v2.2.0 | **Core Daily Loop (Navigation & Tracker)** | 10 SP | `ShellScreen`, `HomePage`, `ManualEntryPage` | 🟢 **DONE** |
| **S14** | v2.3.0 | **High-Value AI Experience (Scanner & Coach)** | 10 SP | `CameraPage`, `ScanReviewPage`, `CoachPage` | 🟢 **DONE** |
| **S15** | v2.4.0 | **First Impression & Identity (Auth & Profile)** | 14 SP | `GoalSummaryPage`, `ProfilePage`, `ProfileEditPage` | 🟢 **DONE** |
| **S16** | v2.5.0 | **Deep Domain, Analytics & OS Widgets** | 9 SP | `AnalyticsPage`, `CalorieTrendChart` | ⏳ Queued |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 15 — AstroBite v2.4.0 First Impression & Identity (Hoàn tất 30/09/2026)
- **Mục tiêu**: Nâng cấp trải nghiệm FTUX (First Time User Experience), Auth, Onboarding, và Profile với UI Kit `ClayCard` và nút bấm Duolingo.
- **Kết quả**: **14 / 14 SP (100% Passed)** — 242/242 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/05-change-management/release-v2.4.0.md`

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
