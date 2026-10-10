# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 30 (Đã hoàn tất)
- **Tên Sprint**: Ultimate Warning Cleanout (Toàn Diện Vùng An Toàn < 350L)
- **Mã Epic / Feature**: `EPIC-REF-09` / `FEAT-S30-ULTIMATE-CLEANOUT`
- **Phiên bản mục tiêu**: `v3.10.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026 (Hoàn thành xuất sắc ngày 10/10/2026)
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 30: Ultimate Warning Cleanout (307/307 Files Safe)

1. **Kiến Trúc & Phân Tích (Gate 0 & Gate 1 — 3 SP)**: ADR-036 & PRD giải phẫu 4 file cảnh báo cuối cùng:
   - `mock_guild_repository.dart` (448 dòng ➔ 332 dòng)
   - `zero_gravity_food_background.dart` (415 dòng ➔ 174 dòng)
   - `health_cards.dart` (354 dòng ➔ 5 dòng)
   - `member_action_sheet.dart` (354 dòng ➔ 190 dòng)
2. **Giải Phẫu `mock_guild_repository.dart` (448 dòng — 3 SP)**: Tách `guild_mock_seeds.dart`.
3. **Giải Phẫu `zero_gravity_food_background.dart` (415 dòng — 2 SP)**: Tách `zero_gravity_food_specs.dart` và `cosmic_stardust_painter.dart`.
4. **Giải Phẫu `health_cards.dart` & `member_action_sheet.dart` (708 dòng — 2 SP)**: Tách `energy_balance_card.dart`, `steps_activity_card.dart`, `member_action_header_card.dart`, `member_action_dialogs.dart`.
5. **Quality & Release Clearance (Gate 5, 6, 6.5 & 7 — 3 SP)**: 100% tests pass, `flutter analyze` 0 issue, **0 file > 350L trên toàn bộ 307 files**!

---

## 📋 Bảng Kanban Sprint 30

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S30-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-30-ultimate-warning-cleanout-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-036 | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S30-01-PRD` | `docs/03-prd-features/37-ultimate-warning-cleanout/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Cleanout | `business-analyst` | 2 | 🏁 **DONE** |
| `TSK-S30-02-DESIGN` | `docs/03-prd-features/37-ultimate-warning-cleanout/ui-design.md` | **G2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | 🏁 **DONE** |
| `TSK-S30-03-TEST-PLAN` | `docs/03-prd-features/37-ultimate-warning-cleanout/gate-3-test.md` | **G3** | QA Tester: Regression Test Plan cho Sprint 30 | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S30-04-GUILD-REPO` | `mock_guild_repository.dart` | **G4** | Dev Core: Tách hạt giống dữ liệu `guild_mock_seeds.dart` | `flutter-core-dev` | 3 | 🏁 **DONE** |
| `TSK-S30-05-ZERO-GRAV` | `zero_gravity_food_background.dart`| **G4** | Dev FE: Tách `zero_gravity_food_specs.dart` & painter | `flutter-core-dev` | 2 | 🏁 **DONE** |
| `TSK-S30-06-HEALTH-MEMBER`| `health_cards.dart` & `member_action_sheet.dart` | **G4** | Dev FE: Tách health cards & member action components | `flutter-core-dev` | 2 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 30 — AstroBite v3.10.0 Ultimate Warning Cleanout (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách 4 file cảnh báo cuối cùng: `mock_guild_repository.dart`, `zero_gravity_food_background.dart`, `health_cards.dart`, `member_action_sheet.dart`.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass, 0 issue analyze, **100% (307/307) file trong repo đạt vùng an toàn < 350 lines**.
- **Biên bản phát hành**: `docs/03-prd-features/37-ultimate-warning-cleanout/release-v3.10.0.md`

### 🟢 Sprint 29 — AstroBite v3.9.0 Deep Clean Polish & Warning Elimination (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách 4 file cảnh báo cao: `analytics_page.dart`, `clay_bottom_nav.dart`, `coach_history_sheet.dart`, `meal_quick_log_card.dart`.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass, 0 issue analyze.
- **Biên bản phát hành**: `docs/03-prd-features/36-deep-clean-refactoring/release-v3.9.0.md`

### 🟢 Sprint 28 — AstroBite v3.8.0 Daily Tracker & Dashboard Clean Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `custom_food_sheet.dart`, `home_page.dart`, `celestial_cockpit_card.dart` và `meal_detail_page.dart`.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass, 0 hard cap violations trên toàn repo.
- **Biên bản phát hành**: `docs/superpowers/releases/release-v3.8.0.md`

### 🟢 Sprint 27 — AstroBite v3.7.0 Auth & Onboarding Flow Clean Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `clay_3d_food_art.dart`, `onboarding_page.dart`, `splash_page.dart` và `login_page.dart`.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass.
- **Biên bản phát hành**: `docs/superpowers/releases/release-v3.7.0.md`
