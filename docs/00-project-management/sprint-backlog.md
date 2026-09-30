# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 14
- **Tên Sprint**: High-Value AI Experience — Camera Scanner & GenUI Coach UI Overhaul
- **Mã Epic / Feature**: `EPIC-UI-REFRESH` / `FEAT-S14-AI-EXPERIENCE`
- **Phiên bản mục tiêu**: `v2.3.0`
- **Thời gian Sprint**: 29/09/2026 – 12/10/2026
- **Trạng thái Sprint**: 🟢 **DONE (10 / 10 SP — 100% Passed)**
- **Tổng Story Points cam kết**: **10 SP** (Tiến độ: **10 / 10 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 14: High-Value AI Experience

1. **Camera Viewfinder & Chunky Shutter (`TSK-S14-01` — 3 SP)**: 🟢 **DONE** — Viewfinder bo góc mềm mại 24pt, nút chụp ảnh Shutter tròn 3D nhô cao với hiệu ứng đàn hồi tactile squash `0.92`, rung `mediumImpact`, nút Flash và Gallery dạng `ClayIconButton` nổi $\ge 48\times 48\text{pt}$.
2. **Scan Review ClaySheet & Dishes (`TSK-S14-02` — 3 SP)**: 🟢 **DONE** — Tái cấu trúc `ScanReviewPage` trên nền Warm Milk `#FAF8F5`, thẻ kết quả `ClayCard`, `ClayMealChip`, thanh đa lượng `ChunkyMacroBar`, nút lưu 3D `ClayButton.primary` với tactile squash và haptic feedback.
3. **AI Coach Chat Cockpit & GenUI Clay Cards (`TSK-S14-03` — 4 SP)**: 🟢 **DONE** — Khung chat với bong bóng `ClayCard` mềm mại, 3 widget Generative UI A2UI Protocol (`MealQuickLogCard`, `MacroBudgetGauge`, `QuickChoiceChips`) bọc trong `ClayCard` với nút 1-tap ghi nhật ký phản hồi $< 150\text{ms}$.

---

## 📋 Bảng Kanban Sprint 14

### 1. 📝 BACKLOG / QUEUED — [0 SP]
*(Toàn bộ các task đã hoàn thành)*

### 2. ⚡ IN PROGRESS — [0 SP]
*(Không còn task đang thực hiện)*

### 3. 🏁 DONE — [10 SP]

| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|:---:|:---:|:---|
| `TSK-S14-00-SPIKE` | Kiến trúc AI UI Kit | **G0** | Tech Lead: Spike kiến trúc tích hợp `ClayCard` vào Camera HUD & GenUI widgets | `tech-lead` | 1 | 🟢 **DONE** |
| `TSK-S14-00-PRD` | `prd-s14-ai-experience.md` | **G1** | BA: Soạn PRD & User Stories BDD chi tiết; PO & Tech Lead ký Gate 1 Sign-Off | `business-analyst` | 1 | 🟢 **DONE** |
| `TSK-S14-00-DESIGN` | `ui-ux-design-spec.md` | **G2** | UI/UX Designer: Lập Layout Blueprint lưới 4pt, 5 trạng thái cho 3 màn hình AI | `ui-ux-designer` | 1 | 🟢 **DONE** |
| `TSK-S14-00-TEST-PLAN` | `gate-3-test-plan.md` | **G3** | QA Tester: Thiết kế Master Test Plan, Manual TCs (EP & BVA) và kịch bản BDD Gherkin | `qa-tester` | 1 | 🟢 **DONE** |
| `TSK-S14-01-CAMERA` | `camera_page.dart` | **G4** | Dev FE: Viewfinder bo góc, cụm shutter button 3D, flash & gallery controls | `flutter-core-dev` | 3 | 🟢 **DONE** |
| `TSK-S14-02-SCAN-REVIEW` | `scan_review_page.dart` | **G4** | Dev FE: Sheet duyệt món `ClayCard`, `ChunkyMacroBar`, `ClayMealChip`, nút lưu 3D | `flutter-core-dev` | 3 | 🟢 **DONE** |
| `TSK-S14-03-COACH-GENUI` | `coach_page.dart` & widgets | **G4** | Dev FE: Chat bubbles, `MealQuickLogCard`, `MacroBudgetGauge`, `QuickChoiceChips` | `flutter-core-dev` | 4 | 🟢 **DONE** |
| `TSK-S14-04-REVIEW` | Git diff Sprint 14 | **G5** | Reviewer: Ponytail Diff Review, triệt tiêu code rác, đảm bảo 0 bloat | `code-reviewer` | - | 🟢 **DONE** |
| `TSK-S14-05-QA-VERIFY` | Automated Test Suite | **G6** | QA Tester: Test pass 100% (242/242 tests), FPS $\ge 55$, 0 memory leak | `qa-tester` | - | 🟢 **DONE** |
| `TSK-S14-06-RELEASE` | Tag release `v2.3.0` | **G7** | PO, Tech Lead & PM: Thông cáo phát hành phiên bản thương mại `v2.3.0` | `product-owner` | - | 🟢 **DONE** |

---

## ✅ Định Nghĩa DONE Sprint 14

- [x] `flutter analyze` 0 lỗi, 0 cảnh báo.
- [x] `flutter test` pass 100% (242/242 tests passed).
- [x] `CameraPage` hiển thị cụm điều khiển Shutter 3D lồi và haptic feedback khi chụp, 0 memory leak.
- [x] `ScanReviewPage` hiển thị danh sách món trên thẻ `ClayCard`, `ChunkyMacroBar` cập nhật dynamic khi đổi gram.
- [x] `CoachPage` hiển thị bong bóng chat Claymorphic mượt mà, các widget GenUI (`MealQuickLogCard`) cho phép 1-tap log tức thì $< 150\text{ms}$.
- [x] QA Gate 6 và Security Auditor Gate 6.5 ký duyệt release `v2.3.0`.


---

## 🗺️ Lộ Trình Sprint Nâng Cấp Giao Diện Theo Màn Hình (Sprint 12–16)

| Sprint | Version | Tên Sprint & Nhóm Màn Hình Trọng Tâm | SP | Màn Hình Chi Tiết | Trạng Thái |
|:--|:--:|:---|:--:|:---|:---|
| **S12** | v2.1.0 | **Foundation & UI Kit Core** | 10 SP | `lib/shared/ui_kit/*` (ClayCard, ClayButton, ChunkyMacroBar, CalorieProgressArc, ClayMealChip, ClayBottomNav, ClayTextField) | 🟢 **DONE** |
| **S13** | v2.2.0 | **Core Daily Loop (Navigation & Tracker)** | 10 SP | `ShellScreen` (ClayBottomNav), `HomePage`, `ManualEntryPage`, `MealDetailPage` | 🟢 **DONE** |
| **S14** | v2.3.0 | **High-Value AI Experience (Scanner & Coach)** | 10 SP | `CameraPage` (AR HUD), `ScanReviewPage` (ClaySheet), `CoachPage` (GenUI Clay Cards) | 🟢 **DONE** |
| **S15** | v2.4.0 | **First Impression & Identity (Auth & Profile)** | 11 SP | `GoalSummaryPage`, `ProfilePage`, `ProfileEditPage`, `HealthConnectionPage` | ⏳ Queued |
| **S16** | v2.5.0 | **Deep Domain, Analytics & OS Widgets** | 9 SP | `AnalyticsPage`, `CalorieTrendChart`, `WeightTrendChart`, Android & iOS Home Widgets | ⏳ Queued |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

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
