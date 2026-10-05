# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 19
- **Tên Sprint**: Multi-Region Food Culture Intelligence (Vietnamese Culinary Decomposition & Broth/Topping Engine)
- **Mã Epic / Feature**: `EPIC-GLOBAL` / `FEAT-S19-GLOBAL-CUISINE`
- **Phiên bản mục tiêu**: `v2.9.0`
- **Thời gian Sprint**: 05/10/2026 – 19/10/2026
- **Trạng thái Sprint**: 🟡 **IN PROGRESS**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **5 / 13 SP — 38%**)

---

## 🎯 Mục Tiêu Sprint 19: Multi-Region Food Culture Intelligence

1. **One-Pass Vietnamese Food Vision Prompt (`TSK-S19-04-BACKEND-AI` — 3 SP)**: Tinh chỉnh Gemini 2.0 Flash System Prompt và mở rộng `DishDto`, `SubDishDto` để bóc tách nước dùng (`has_broth`, `broth_calories`, `broth_sodium_mg`) và các topping món combo (`sub_items`) trong 1 lượt gọi duy nhất (độ trễ < 2.2s).
2. **Interactive Broth Toggle & Topping Checklist (`TSK-S19-05-CLIENT-UI` — 4 SP)**: Tích hợp công tắc 1 chạm `[🍜 Ăn cả nước] ⟷ [🥢 Chỉ ăn cái]` và danh sách chọn/bỏ topping ngay trên thẻ món ăn tại `ScanReviewPage`, trừ trực tiếp calo/sodium theo thời gian thực.
3. **Nutrition Engine Zero-Drift Calculation**: Cập nhật logic trừ calo, chất béo và natri khi người dùng không ăn nước dùng hoặc bỏ topping, phản ánh ngay lập tức lên `ChunkyMacroBar` và `CalorieProgressArc`.

---

## 📋 Bảng Kanban Sprint 19

### 1. 📝 BACKLOG / QUEUED — [8 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S19-03-TEST-PLAN` | Master Test Plan Sprint 19 | **G3** | QA Tester: Thiết kế test biên BVA và kịch bản BDD Gherkin món Việt | `qa-tester` | 1 | 🟡 **QUEUED** |
| `TSK-S19-04-BACKEND-AI` | `gemini_remote_datasource.dart`, `scan_result_dto.dart` | **G4** | Cloud Dev: Mở rộng DTO, tinh chỉnh One-Pass Prompt bóc tách món Việt | `cloud-ai-dev` | 3 | 🟡 **QUEUED** |
| `TSK-S19-05-CLIENT-UI` | `scan_review_page.dart` | **G4** | Dev FE: Tích hợp Broth Toggle & Topping Checklist tương tác thời gian thực | `flutter-core-dev` | 4 | 🟡 **QUEUED** |
| `TSK-S19-06-REVIEW` | Git diff Sprint 19 | **G5** | Reviewer: Ponytail Diff Review & Zero Doc-Code Drift Check | `code-reviewer` | - | 🟡 **QUEUED** |
| `TSK-S19-07-VERIFY` | Automated Test Suite | **G6** | QA Tester: 100% test pass, 0 analyze error, 0 memory leak, latency < 2.2s | `qa-tester` | - | 🟡 **QUEUED** |
| `TSK-S19-08-SECURITY` | Security Audit & Rules | **G6.5** | Security Auditor: Kiểm toán parsing JSON, Prompt Injection & Trust boundary | `security-auditor` | - | 🟡 **QUEUED** |
| `TSK-S19-09-RELEASE` | Tag release `v2.9.0` | **G7** | Hội đồng PO, PM, Tech Lead & Security: Thông cáo phát hành v2.9.0 | `product-owner` | - | 🟡 **QUEUED** |

### 2. ⚡ IN PROGRESS — [0 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| Không có task | | | | | | |

### 3. 🏁 DONE — [5 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S19-00-SPIKE` | `docs/superpowers/specs/2026-10-05-multi-region-food-culture-intelligence-design.md` | **G0** | PO & Tech Lead: Brainstorming & Architectural Design Spec bóc tách món Việt | `product-owner` | 1 | 🟢 **DONE** |
| `TSK-S19-01-PRD` | `docs/03-prd-features/26-multi-region-food-intelligence/` | **G1** | BA: Soạn PRD & User Stories BDD cho Broth Toggle & Topping Checklist | `business-analyst` | 2 | 🟢 **DONE** |
| `TSK-S19-02-DESIGN` | `docs/03-prd-features/26-multi-region-food-intelligence/ui-ux-design.md` | **G2** | UI/UX Designer: Thiết kế Claymorphic Broth Toggle & Topping Chips 5 States | `ui-ux-designer` | 2 | 🟢 **DONE** |

---

## ✅ Định Nghĩa DONE Sprint 19

- [ ] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [ ] `flutter test` pass 100% (bao gồm regression tests hiện hữu và tests mới).
- [ ] Gemini Vision bóc tách được nước dùng và toppings món Việt trong 1 request duy nhất (độ trễ AI ≤ 2.2s).
- [ ] Công tắc `[🍜 Ăn cả nước] ⟷ [🥢 Chỉ ăn cái]` hoạt động mượt mà, trừ chính xác calo và natri.
- [ ] Checklist Topping cho phép chọn/bỏ topping và cập nhật Macro bar tức thì.
- [ ] Giao diện 5 trạng thái đạt chuẩn Claymorphic, không vỡ layout trên bất kỳ kích thước màn hình nào.
- [ ] Quy tắc Docs-as-Code (Zero Doc-Code Drift): Toàn bộ tài liệu trong `docs/` được cập nhật đồng bộ trước khi đóng Gate 7.


---


## 🗺️ Lộ Trình Sprint Nâng Cấp Giao Diện Theo Màn Hình (Sprint 12–16)

| Sprint | Version | Tên Sprint & Nhóm Màn Hình Trọng Tâm | SP | Màn Hình Chi Tiết | Trạng Thái |
|:--|:--:|:---|:--:|:---|:---|
| **S12** | v2.1.0 | **Foundation & UI Kit Core** | 10 SP | `lib/shared/ui_kit/*` | 🟢 **DONE** |
| **S13** | v2.2.0 | **Core Daily Loop (Navigation & Tracker)** | 10 SP | `ShellScreen`, `HomePage`, `ManualEntryPage` | 🟢 **DONE** |
| **S14** | v2.3.0 | **High-Value AI Experience (Scanner & Coach)** | 10 SP | `CameraPage`, `ScanReviewPage`, `CoachPage` | 🟢 **DONE** |
| **S15** | v2.5.2 | **First Impression & Identity (Auth & Profile)** | 14 SP | `GoalSummaryPage`, `ProfilePage`, `ProfileEditPage` | 🟢 **DONE** |
| **S17** | v2.7.0 | **Social Accountability & Leaderboard** | 11 SP | `LeaderboardPage`, `ShareImageService` | 🟢 **DONE** |
| **S18** | v2.8.0 | **Live Social Sync & Streak Nudge** | 13 SP | `LeaderboardPage`, `SocialRepository` | 🟢 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

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
