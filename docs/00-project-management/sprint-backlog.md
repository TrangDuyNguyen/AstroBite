# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 17
- **Tên Sprint**: Social Accountability & Astro Leaderboard
- **Mã Epic / Feature**: `EPIC-COMMUNITY` / `FEAT-S17-SOCIAL`
- **Phiên bản mục tiêu**: `v2.7.0`
- **Thời gian Sprint**: 04/10/2026 – 18/10/2026
- **Trạng thái Sprint**: 🏁 **DONE**
- **Tổng Story Points cam kết**: **11 SP** (Tiến độ: **11 / 11 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 17: Social Accountability & Astro Leaderboard

1. **Astro Leaderboard (`TSK-S17-RANKING` — 4 SP)**: Xây dựng bảng xếp hạng bạn bè dựa trên số điểm "Cosmic Streak" và tỷ lệ hoàn thành mục tiêu.
2. **Social Sharing (`TSK-S17-SHARE` — 4 SP)**: Tính năng xuất (export) bữa ăn xuất sắc hoặc mục tiêu đạt được thành một thẻ hình ảnh tĩnh (Image Card) chuẩn Claymorphic để share lên Instagram/Facebook.
3. **Friend System (`TSK-S17-FRIENDS` — 3 SP)**: Tìm kiếm bạn bè, gửi lời mời và kết bạn qua Firestore.

---

## 📋 Bảng Kanban Sprint 16

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
| `TSK-S17-00-SPIKE` | Kiến trúc Social & Share | **G0** | Tech Lead: Spike kiến trúc chụp ảnh UI Widget & Cloud Functions ranking | `tech-lead` | 1 | 🟢 **DONE** |
| `TSK-S17-00-PRD` | `prd-s17.md` | **G1** | BA: Soạn PRD & User Stories BDD cho Leaderboard | `business-analyst` | 1 | 🟢 **DONE** |
| `TSK-S17-00-DESIGN` | `ui-ux-design.md` | **G2** | UI/UX Designer: Layout Leaderboard, Share Card Blueprint | `ui-ux-designer` | 2 | 🟢 **DONE** |
| `TSK-S17-00-TEST-PLAN` | `gate-3-test.md` | **G3** | QA Tester: Thiết kế Test Plan, Manual TCs | `qa-tester` | 1 | 🟢 **DONE** |
| `TSK-S17-RANKING` | `leaderboard_page.dart` | **G4** | Dev FE: UI Leaderboard và kết nối Cloud Functions | `flutter-core-dev` | 3 | 🟢 **DONE** |
| `TSK-S17-SHARE` | `share_service.dart` | **G4** | Dev Native: Render Widget thành Image và Native Share | `flutter-native-dev` | 3 | 🟢 **DONE** |
| `TSK-S17-05-REVIEW` | Git diff Sprint 17 | **G5** | Reviewer: Ponytail Diff Review | `code-reviewer` | - | 🟢 **DONE** |
| `TSK-S17-06-QA-VERIFY`| Automated Test Suite | **G6** | QA Tester: Test pass 100%, check Share Native dialog | `qa-tester` | - | 🟢 **DONE** |
| `TSK-S17-07-RELEASE` | Tag release `v2.7.0` | **G7** | PO, Tech Lead & PM: Thông cáo phát hành | `product-owner` | - | 🟢 **DONE** |

---

## ✅ Định Nghĩa DONE Sprint 17

- [x] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [x] `flutter test` pass 100%, bao gồm test render hình ảnh và share.
- [x] Tính năng chụp ảnh Widget ra file đạt hiệu năng tốt (< 300ms).
- [x] QA Gate 6 và Security Auditor Gate 6.5 ký duyệt release `v2.7.0`.

---

## 🗺️ Lộ Trình Sprint Nâng Cấp Giao Diện Theo Màn Hình (Sprint 12–16)

| Sprint | Version | Tên Sprint & Nhóm Màn Hình Trọng Tâm | SP | Màn Hình Chi Tiết | Trạng Thái |
|:--|:--:|:---|:--:|:---|:---|
| **S12** | v2.1.0 | **Foundation & UI Kit Core** | 10 SP | `lib/shared/ui_kit/*` | 🟢 **DONE** |
| **S13** | v2.2.0 | **Core Daily Loop (Navigation & Tracker)** | 10 SP | `ShellScreen`, `HomePage`, `ManualEntryPage` | 🟢 **DONE** |
| **S14** | v2.3.0 | **High-Value AI Experience (Scanner & Coach)** | 10 SP | `CameraPage`, `ScanReviewPage`, `CoachPage` | 🟢 **DONE** |
| **S15** | v2.5.2 | **First Impression & Identity (Auth & Profile)** | 14 SP | `GoalSummaryPage`, `ProfilePage`, `ProfileEditPage` | 🟢 **DONE** |
| **S17** | v2.7.0 | **Social Accountability & Leaderboard** | 11 SP | `LeaderboardPage`, `ShareImageService` | 🟢 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

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
