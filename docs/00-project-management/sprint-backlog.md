# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 25
- **Tên Sprint**: Camera Scanner Pipeline Refactoring
- **Mã Epic / Feature**: `EPIC-REF-04` / `FEAT-S25-CAMERA-SCANNER`
- **Phiên bản mục tiêu**: `v3.5.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 25: Camera Scanner Pipeline Refactoring

1. **Kiến Trúc & Bóc Tách Scanner Pipeline (Gate 0 & Gate 1 — 3 SP)**: Ban hành Architectural Spec ADR-031 & PRD giải phẫu 2 God Files còn lại của Scanner: `camera_page.dart` (965 dòng) và `scanning_viewfinder.dart` (616 dòng).
2. **Giải Phẫu God File `camera_page.dart` (965 dòng ➔ 266 dòng — 5 SP)**: Bóc tách thành các sub-widgets chuyên biệt (`camera_dock_controls`, `camera_quota_badge`, `camera_scanning_tips_sheet`, `camera_error_dialog_handler`, `camera_app_bar`), đưa file chính về `< 280 dòng` (thực tế 266 dòng).
3. **Giải Phẫu God File `scanning_viewfinder.dart` (616 dòng ➔ 256 dòng — 5 SP)**: Bóc tách thành các sub-widgets (`viewfinder_hud_painters`, `viewfinder_laser_scanner`, `viewfinder_detected_tag`), đưa file chính về `< 260 dòng` (thực tế 256 dòng).

---

## 📋 Bảng Kanban Sprint 25

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S25-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-25-camera-scanner-pipeline-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-031 cho Scanner Pipeline | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S25-01-PRD` | `docs/03-prd-features/32-camera-scanner-refactoring/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Camera & Viewfinder | `business-analyst` | 2 | 🏁 **DONE** |
| `TSK-S25-02-DESIGN` | `docs/03-prd-features/32-camera-scanner-refactoring/ui-design.md` | **G2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | 🏁 **DONE** |
| `TSK-S25-03-TEST-PLAN` | `docs/03-prd-features/32-camera-scanner-refactoring/gate-3-test.md` | **G3** | QA Tester: Regression Test Plan cho Scanner Pipeline | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S25-04-CAMERA` | `features/scanner/presentation/pages/camera_page.dart` | **G4** | Dev FE: Bóc tách `camera_page.dart` (965 ➔ 266 dòng) | `flutter-native-dev` | 4 | 🏁 **DONE** |
| `TSK-S25-05-VIEWFINDER` | `features/scanner/presentation/widgets/scanning_viewfinder.dart` | **G4** | Dev FE: Bóc tách `scanning_viewfinder.dart` (616 ➔ 256 dòng) | `flutter-core-dev` | 3 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 25 — AstroBite v3.5.0 Camera Scanner Pipeline Refactoring (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `camera_page.dart` (965 ➔ 266 dòng) và `scanning_viewfinder.dart` (616 ➔ 256 dòng) thành 8 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, 34/34 scanner tests pass, `flutter analyze` 0 issues, Gate 7 Approved. Phân hệ Scanner sạch 100% God files.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.5.0.md`

### 🟢 Sprint 24 — AstroBite v3.4.0 Recipes Feature God Files Elimination (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `recipe_builder_page.dart` (984 ➔ 245 dòng) và `recipes_page.dart` (646 ➔ 161 dòng) thành 8 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, `flutter analyze` 0 issues, Gate 7 Approved.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.4.0.md`

### 🟢 Sprint 23 — AstroBite v3.3.0 AI Coach & Scanner God Files Elimination (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `coach_page.dart` (2,153 ➔ 344 dòng) và `scan_review_page.dart` (1,482 ➔ 340 dòng) thành 19 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 320/320 tests pass thực chất, `flutter analyze` 0 issues, Gate 7 Approved.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.3.0.md`
