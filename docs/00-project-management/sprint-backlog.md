# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 26
- **Tên Sprint**: Gamification, Guilds & Social Modular Architecture
- **Mã Epic / Feature**: `EPIC-REF-05` / `FEAT-S26-GAMIFICATION-GUILDS-SOCIAL`
- **Phiên bản mục tiêu**: `v3.6.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 26: Gamification, Guilds & Social Modular Architecture

1. **Kiến Trúc & Bóc Tách (Gate 0 & Gate 1 — 3 SP)**: Ban hành Architectural Spec ADR-032 & PRD giải phẫu 3 God Files lớn nhất:
   - `streak_detail_sheet.dart` (796 dòng ➔ 208 dòng)
   - `guild_page.dart` (718 dòng ➔ 249 dòng)
   - `leaderboard_page.dart` (655 dòng ➔ 221 dòng)
2. **Giải Phẫu `streak_detail_sheet.dart` (796 dòng ➔ 208 dòng — 4 SP)**: Tách thành 4 sub-widgets (`streak_metrics_pillar_card`, `streak_shield_protection_banner`, `streak_cosmic_badge_grid`, `streak_badge_detail_dialog`).
3. **Giải Phẫu `guild_page.dart` (718 dòng ➔ 249 dòng — 3 SP)**: Tách thành 4 sub-components (`guild_header_card`, `guild_empty_view`, `guild_governance_sheet`, `guild_dialog_helper`).
4. **Giải Phẫu `leaderboard_page.dart` (655 dòng ➔ 221 dòng — 3 SP)**: Tách thành 4 sub-components (`leaderboard_user_card`, `leaderboard_my_id_card`, `leaderboard_add_friend_sheet`, `leaderboard_nudge_sheet`).

---

## 📋 Bảng Kanban Sprint 26

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S26-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-26-gamification-guilds-social-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-032 | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S26-01-PRD` | `docs/03-prd-features/33-gamification-guilds-social-refactoring/` | **G1** | BA: Soạn PRD & User Stories BDD luồng Streak & Guild & Social | `business-analyst` | 2 | 🏁 **DONE** |
| `TSK-S26-02-DESIGN` | `docs/03-prd-features/33-gamification-guilds-social-refactoring/ui-design.md` | **G2** | UI/UX Designer: Component Layout Blueprint lưới 4pt | `ui-ux-designer` | 2 | 🏁 **DONE** |
| `TSK-S26-03-TEST-PLAN` | `docs/03-prd-features/33-gamification-guilds-social-refactoring/gate-3-test.md` | **G3** | QA Tester: Regression Test Plan cho Gamification & Social | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S26-04-STREAK` | `gamification/presentation/widgets/streak_detail_sheet.dart` | **G4** | Dev FE: Bóc tách `streak_detail_sheet.dart` (796 ➔ 208 dòng) | `flutter-core-dev` | 3 | 🏁 **DONE** |
| `TSK-S26-05-GUILD` | `guilds/presentation/pages/guild_page.dart` | **G4** | Dev FE: Bóc tách `guild_page.dart` (718 ➔ 249 dòng) | `flutter-core-dev` | 2 | 🏁 **DONE** |
| `TSK-S26-06-LEADERBOARD` | `social/presentation/pages/leaderboard_page.dart` | **G4** | Dev FE: Bóc tách `leaderboard_page.dart` (655 ➔ 221 dòng) | `flutter-core-dev` | 2 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 26 — AstroBite v3.6.0 Gamification, Guilds & Social Modular Architecture (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `streak_detail_sheet.dart` (796 ➔ 208 dòng), `guild_page.dart` (718 ➔ 249 dòng) và `leaderboard_page.dart` (655 ➔ 221 dòng) thành 12 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, 49/49 gamification & social tests pass, `flutter analyze` 0 issues, Gate 7 Approved. Giảm số file vi phạm Hard Cap (> 500L) từ 9 xuống còn 6.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.6.0.md`

### 🟢 Sprint 25 — AstroBite v3.5.0 Camera Scanner Pipeline Refactoring (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `camera_page.dart` (965 ➔ 266 dòng) và `scanning_viewfinder.dart` (616 ➔ 256 dòng) thành 8 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, 34/34 scanner tests pass, `flutter analyze` 0 issues, Gate 7 Approved. Phân hệ Scanner sạch 100% God files.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.5.0.md`

### 🟢 Sprint 24 — AstroBite v3.4.0 Recipes Feature God Files Elimination (Hoàn tất 10/10/2026)
- **Mục tiêu**: Bóc tách `recipe_builder_page.dart` (984 ➔ 245 dòng) và `recipes_page.dart` (646 ➔ 161 dòng) thành 8 sub-widgets chuyên trách.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 322/322 tests pass thực chất, `flutter analyze` 0 issues, Gate 7 Approved.
- **Biên bản phát hành**: `docs/05-change-management/release-v3.4.0.md`
