# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 27
- **Tên Sprint**: Auth & Onboarding Flow Clean Architecture
- **Mã Epic / Feature**: `EPIC-REF-06` / `FEAT-S27-AUTH-ONBOARDING`
- **Phiên bản mục tiêu**: `v3.7.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points hoàn thành**: **13 / 13 SP (100%)**

---

## 🎯 Mục Tiêu Sprint 27: Auth & Onboarding Flow Clean Architecture

1. **Kiến Trúc & Bóc Tách (Gate 0 & Gate 1 — 3 SP)**: Ban hành Architectural Spec ADR-033 & PRD giải phẫu 4 God Files:
   - `clay_3d_food_art.dart` (762 dòng ➔ 84 dòng)
   - `onboarding_page.dart` (677 dòng ➔ 166 dòng)
   - `splash_page.dart` (651 dòng ➔ 241 dòng)
   - `login_page.dart` (505 dòng ➔ 204 dòng)
2. **Giải Phẫu `clay_3d_food_art.dart` (762 dòng — 4 SP)**: Tách thành 2 engine họa sĩ `clay_3d_fruits_pastry_painters.dart` và `clay_3d_meals_drinks_painters.dart`.
3. **Giải Phẫu `onboarding_page.dart` (677 dòng — 3 SP)**: Tách thành các sub-steps `onboarding_step_gender.dart`, `onboarding_step_metrics.dart`, `onboarding_step_lifestyle.dart`, `onboarding_select_card.dart`.
4. **Giải Phẫu `splash_page.dart` & `login_page.dart` (1,154 dòng — 3 SP)**: Tách các constellation layers, hero view, login form card, reset password dialog.

---

## 📋 Bảng Kanban Sprint 27

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S27-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-27-auth-onboarding-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-033 | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S27-01-PRD` | `docs/03-prd-features/34-auth-onboarding-refactoring/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Auth & Onboarding | `business-analyst` | 2 | 🏁 **DONE** |
| `TSK-S27-02-DESIGN` | `docs/03-prd-features/34-auth-onboarding-refactoring/ui-design.md` | **G2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | 🏁 **DONE** |
| `TSK-S27-03-TEST-PLAN` | `docs/03-prd-features/34-auth-onboarding-refactoring/gate-3-test.md` | **G3** | QA Tester: Regression Test Plan cho Auth & Onboarding | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S27-04-FOOD-ART` | `auth/presentation/widgets/clay_3d_food_art.dart` | **G4-G6** | Dev FE & QA: Bóc tách `clay_3d_food_art.dart` (762 ➔ 84 dòng) | `flutter-core-dev` | 3 | 🏁 **DONE** |
| `TSK-S27-05-ONBOARDING` | `auth/presentation/pages/onboarding_page.dart` | **G4-G6** | Dev FE & QA: Bóc tách `onboarding_page.dart` (677 ➔ 166 dòng) | `flutter-core-dev` | 2 | 🏁 **DONE** |
| `TSK-S27-06-SPLASH-LOGIN`| `splash_page.dart` & `login_page.dart` | **G4-G6** | Dev FE & QA: Bóc tách `splash_page.dart` (651 ➔ 241 dòng) & `login_page.dart` (505 ➔ 204 dòng) | `flutter-core-dev` | 2 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 27 — AstroBite v3.7.0 Auth & Onboarding Flow Clean Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `clay_3d_food_art.dart` (762 ➔ 84 dòng), `onboarding_page.dart` (677 ➔ 166 dòng), `splash_page.dart` (651 ➔ 241 dòng) và `login_page.dart` (505 ➔ 204 dòng) thành 12 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, 27/27 auth tests pass, `flutter analyze` 0 issues, Gate 6.5 & 7 Approved. Giảm số file vi phạm Hard Cap (> 500L) từ 6 xuống còn duy nhất 2 file!
- **Biên bản phát hành**: `docs/superpowers/releases/release-v3.7.0.md`

### 🟢 Sprint 26 — AstroBite v3.6.0 Gamification, Guilds & Social Modular Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `streak_detail_sheet.dart` (796 ➔ 208 dòng), `guild_page.dart` (718 ➔ 249 dòng) và `leaderboard_page.dart` (655 ➔ 221 dòng) thành 12 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, 49/49 gamification & social tests pass, `flutter analyze` 0 issues, Gate 7 Approved.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.6.0.md`

### 🟢 Sprint 25 — AstroBite v3.5.0 Camera Scanner Pipeline Refactoring (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `camera_page.dart` (965 ➔ 266 dòng) và `scanning_viewfinder.dart` (616 ➔ 256 dòng) thành 8 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, 34/34 scanner tests pass, `flutter analyze` 0 issues, Gate 7 Approved. Phân hệ Scanner sạch 100% God files.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.5.0.md`
