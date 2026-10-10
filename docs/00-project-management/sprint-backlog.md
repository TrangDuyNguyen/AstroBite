# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 29 (Đã hoàn tất)
- **Tên Sprint**: Deep Clean Polish & Warning Elimination
- **Mã Epic / Feature**: `EPIC-REF-08` / `FEAT-S29-DEEP-CLEAN`
- **Phiên bản mục tiêu**: `v3.9.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026 (Hoàn thành sớm ngày 10/10/2026)
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 29: Deep Clean Polish & Warning Elimination

1. **Kiến Trúc & Bóc Tách (Gate 0 & Gate 1 — 3 SP)**: Ban hành Architectural Spec ADR-035 & PRD giải phẫu 4 file trong dải cảnh báo cao (> 400 dòng):
   - `analytics_page.dart` (498 dòng ➔ 258 dòng)
   - `clay_bottom_nav.dart` (478 dòng ➔ 175 dòng)
   - `coach_history_sheet.dart` (427 dòng ➔ 209 dòng)
   - `meal_quick_log_card.dart` (402 dòng ➔ 204 dòng)
2. **Giải Phẫu `analytics_page.dart` (498 dòng — 3 SP)**: Tách Period Selector, KPI Overview Row, và Macro Breakdown Card.
3. **Giải Phẫu `clay_bottom_nav.dart` (478 dòng — 2 SP)**: Tách Hero Camera FAB và Nav Item.
4. **Giải Phẫu `coach_history_sheet.dart` & `meal_quick_log_card.dart` (829 dòng — 2 SP)**: Tách Delete confirmation dialog, History session card, Quick log props, Stepper bar và Macro indicators.
5. **Quality & Security Sign-Off (Gate 5, 6, 6.5 & 7 — 3 SP)**: 322/322 unit/widget tests pass, 0 issue analyze, ký duyệt release clearance.

---

## 📋 Bảng Kanban Sprint 29

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S29-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-29-deep-clean-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-035 | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S29-01-PRD` | `docs/03-prd-features/36-deep-clean-refactoring/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Deep Clean | `business-analyst` | 2 | 🏁 **DONE** |
| `TSK-S29-02-DESIGN` | `docs/03-prd-features/36-deep-clean-refactoring/ui-design.md` | **G2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | 🏁 **DONE** |
| `TSK-S29-03-TEST-PLAN` | `docs/03-prd-features/36-deep-clean-refactoring/gate-3-test.md` | **G3** | QA Tester: Regression Test Plan cho Deep Clean | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S29-04-ANALYTICS` | `analytics_page.dart` | **G4** | Dev FE: Bóc tách `analytics_page.dart` (498 ➔ 258 dòng) | `flutter-core-dev` | 3 | 🏁 **DONE** |
| `TSK-S29-05-BOTTOM-NAV` | `clay_bottom_nav.dart` | **G4** | Dev FE: Bóc tách `clay_bottom_nav.dart` (478 ➔ 175 dòng) | `flutter-core-dev` | 2 | 🏁 **DONE** |
| `TSK-S29-06-COACH-WIDGETS`| `coach_history_sheet.dart` & `meal_quick_log_card.dart` | **G4** | Dev FE: Bóc tách history (427 ➔ 209) & quick log (402 ➔ 204) | `flutter-core-dev` | 2 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 29 — AstroBite v3.9.0 Deep Clean Polish & Warning Elimination (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách 4 file cảnh báo cao: `analytics_page.dart`, `clay_bottom_nav.dart`, `coach_history_sheet.dart`, `meal_quick_log_card.dart`.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass, 0 issue analyze, toàn repo sạch sẽ chỉ còn 4 file cảnh báo > 350L.
- **Biên bản phát hành**: `docs/03-prd-features/36-deep-clean-refactoring/release-v3.9.0.md`

### 🟢 Sprint 28 — AstroBite v3.8.0 Daily Tracker & Dashboard Clean Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `custom_food_sheet.dart` (682 ➔ 157 dòng), `home_page.dart` (552 ➔ 96 dòng), `celestial_cockpit_card.dart` (452 ➔ 137 dòng) và `meal_detail_page.dart` (435 ➔ 166 dòng).
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass, 0 hard cap violations trên toàn repo.
- **Biên bản phát hành**: `docs/superpowers/releases/release-v3.8.0.md`

### 🟢 Sprint 27 — AstroBite v3.7.0 Auth & Onboarding Flow Clean Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `clay_3d_food_art.dart` (762 ➔ 84 dòng), `onboarding_page.dart` (677 ➔ 166 dòng), `splash_page.dart` (651 ➔ 241 dòng) và `login_page.dart` (505 ➔ 204 dòng).
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass.
- **Biên bản phát hành**: `docs/superpowers/releases/release-v3.7.0.md`
