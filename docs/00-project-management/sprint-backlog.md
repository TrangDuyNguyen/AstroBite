# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 28
- **Tên Sprint**: Daily Tracker & Dashboard Clean Architecture
- **Mã Epic / Feature**: `EPIC-REF-07` / `FEAT-S28-TRACKER-DASHBOARD`
- **Phiên bản mục tiêu**: `v3.8.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points hoàn thành**: **13 / 13 SP (100%)**

---

## 🎯 Mục Tiêu Sprint 28: Daily Tracker & Dashboard Clean Architecture

1. **Kiến Trúc & Bóc Tách (Gate 0 & Gate 1 — 3 SP)**: Ban hành Architectural Spec ADR-034 & PRD giải phẫu 4 God Files của phân hệ Tracker:
   - `custom_food_sheet.dart` (682 dòng ➔ 157 dòng)
   - `home_page.dart` (552 dòng ➔ 96 dòng)
   - `celestial_cockpit_card.dart` (452 dòng ➔ 137 dòng)
   - `meal_detail_page.dart` (435 dòng ➔ 166 dòng)
2. **Giải Phẫu `custom_food_sheet.dart` (682 dòng — 4 SP)**: Tách thành 3 components chuyên trách (Header, Basic inputs, Macro pedestals).
3. **Giải Phẫu `home_page.dart` (552 dòng — 3 SP)**: Tách thành 3 components chuyên trách (Coach suggestion card, Quick actions bar, Nutrition log header).
4. **Giải Phẫu `celestial_cockpit_card.dart` & `meal_detail_page.dart` (887 dòng — 3 SP)**: Tách các drawer vi chất, overview card, food item card và empty state.

---

## 📋 Bảng Kanban Sprint 28

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S28-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-28-tracker-dashboard-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-034 | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S28-01-PRD` | `docs/03-prd-features/35-tracker-dashboard-refactoring/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Tracker Dashboard | `business-analyst` | 2 | 🏁 **DONE** |
| `TSK-S28-02-DESIGN` | `docs/03-prd-features/35-tracker-dashboard-refactoring/ui-design.md` | **G2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | 🏁 **DONE** |
| `TSK-S28-03-TEST-PLAN` | `docs/03-prd-features/35-tracker-dashboard-refactoring/gate-3-test.md` | **G3** | QA Tester: Regression Test Plan cho Tracker Dashboard | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S28-04-CUSTOM-FOOD` | `custom_food_sheet.dart` | **G4-G6** | Dev FE & QA: Bóc tách custom_food_sheet.dart (682 ➔ 157 dòng) | `flutter-core-dev` | 3 | 🏁 **DONE** |
| `TSK-S28-05-HOME-PAGE` | `home_page.dart` | **G4-G6** | Dev FE & QA: Bóc tách home_page.dart (552 ➔ 96 dòng) | `flutter-core-dev` | 2 | 🏁 **DONE** |
| `TSK-S28-06-COCKPIT-MEAL` | `celestial_cockpit_card.dart` & `meal_detail_page.dart` | **G4-G6** | Dev FE & QA: Bóc tách cockpit (452 ➔ 137) & meal detail (435 ➔ 166) | `flutter-core-dev` | 2 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 28 — AstroBite v3.8.0 Daily Tracker & Dashboard Clean Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `custom_food_sheet.dart` (682 ➔ 157 dòng), `home_page.dart` (552 ➔ 96 dòng), `celestial_cockpit_card.dart` (452 ➔ 137 dòng), và `meal_detail_page.dart` (435 ➔ 166 dòng).
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, 53/53 tracker tests pass, `flutter analyze` 0 issues, Gate 6.5 & 7 Approved. **QUÉT SẠCH 100% CÁC FILE VƯỢT NGƯỠNG HARD CAP (> 500 DÒNG) TRÊN TOÀN BỘ REPOSITORY!**
- **Biên bản phát hành**: `docs/superpowers/releases/release-v3.8.0.md`

### 🟢 Sprint 27 — AstroBite v3.7.0 Auth & Onboarding Flow Clean Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `clay_3d_food_art.dart` (762 ➔ 84 dòng), `onboarding_page.dart` (677 ➔ 166 dòng), `splash_page.dart` (651 ➔ 241 dòng) và `login_page.dart` (505 ➔ 204 dòng).
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass, `flutter analyze` 0 issues.
- **Biên bản phát hành**: `docs/superpowers/releases/release-v3.7.0.md`

### 🟢 Sprint 26 — AstroBite v3.6.0 Gamification, Guilds & Social Modular Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `streak_detail_sheet.dart` (796 ➔ 208 dòng), `guild_page.dart` (718 ➔ 249 dòng) và `leaderboard_page.dart` (655 ➔ 221 dòng).
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.6.0.md`

### 🟢 Sprint 25 — AstroBite v3.5.0 Camera Scanner Pipeline Refactoring (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `camera_page.dart` (965 ➔ 266 dòng) và `scanning_viewfinder.dart` (616 ➔ 256 dòng).
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.5.0.md`
