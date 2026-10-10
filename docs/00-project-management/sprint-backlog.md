# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 31
- **Tên Sprint**: Internationalization Foundation (Song Ngữ VI + EN)
- **Mã Epic / Feature**: `EPIC-CORE-10` / `FEAT-S31-I18N-FOUNDATION`
- **Phiên bản mục tiêu**: `v3.11.0`
- **Thời gian Sprint**: 10/10/2026 – 24/10/2026
- **Trạng thái Sprint**: ⚡ **IN PROGRESS**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **0 / 13 SP — 0%**)

---

## 🎯 Mục Tiêu Sprint 31: Nền Tảng Đa Ngôn Ngữ Song Ngữ (VI + EN)

1. **Gate 0 & Gate 1 (2 SP)**: Ban hành ADR-037 & PRD + User Stories BDD cho hệ thống bản địa hóa (Official Flutter SDK `flutter_localizations`, 0 dep bên thứ 3).
2. **Setup Hạ Tầng l10n & ARB (3 SP)**: Cấu hình `pubspec.yaml`, `l10n.yaml`, sinh `app_vi.arb` & `app_en.arb` từ `AppStrings`, cài đặt `appLocaleProvider` lưu `SharedPreferences`.
3. **Tích Hợp MaterialApp & Refactor UI (5 SP)**: Tích hợp `AppLocalizations` vào `AstroBiteApp`, chuyển đổi các chuỗi UI, bổ sung Settings Tile chọn ngôn ngữ trong Profile.
4. **Ponytail Cleanout & Quality Clearance (3 SP)**: Xóa sạch `AppStrings`, đảm bảo 100% tests pass (322/322), 0 linter issue, ký duyệt Gate 5, 6, 6.5 & 7.

---

## 📋 Bảng Kanban Sprint 31

### 1. 📝 BACKLOG / QUEUED — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S31-00-SPIKE` | `docs/superpowers/specs/2026-10-10-sprint-31-internationalization-i18n-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-037 | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S31-01-PRD` | `docs/03-prd-features/38-internationalization-i18n/` | **G1** | BA: Soạn PRD & User Stories BDD luồng i18n | `business-analyst` | 1 | 🏁 **DONE** |
| `TSK-S31-02-DESIGN` | `docs/03-prd-features/38-internationalization-i18n/ui-design.md` | **G2** | UI/UX Designer: Thiết kế Picker chọn ngôn ngữ | `ui-ux-designer` | 1 | 🏁 **DONE** |
| `TSK-S31-03-TEST-PLAN` | `docs/03-prd-features/38-internationalization-i18n/gate-3-test.md` | **G3** | QA Tester: Lập kế hoạch kiểm thử Gate 3 | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S31-04-SETUP-ARB` | `pubspec.yaml`, `l10n.yaml`, `lib/l10n/` | **G4** | Dev Core: Cấu hình l10n, tạo `app_vi.arb` & `app_en.arb` | `flutter-core-dev` | 2 | 📝 **TODO** |
| `TSK-S31-05-PROVIDER` | `lib/core/providers/locale_provider.dart` | **G4** | Dev Core: Viết `appLocaleProvider` + persist prefs | `flutter-core-dev` | 1 | 📝 **TODO** |
| `TSK-S31-06-APP-INTEG` | `lib/app.dart` & Profile Language Setting | **G4** | Dev Core: Nạp locales vào `MaterialApp`, thêm UI Profile | `flutter-core-dev` | 2 | 📝 **TODO** |
| `TSK-S31-07-MIGRATE-CLEAN` | `lib/core/constants/app_strings.dart` | **G4/G5** | Dev Core / Reviewer: Migrate & xóa sạch `AppStrings` | `flutter-core-dev` | 2 | 📝 **TODO** |
| `TSK-S31-08-SIGN-OFF` | Gate 6, 6.5, 7 Sign-offs | **G6/G7** | QA & Security & PO: Kiểm thử 100% pass & Clearance | `qa-tester` | 2 | 📝 **TODO** |

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [4 SP] (G0, G1, G2, G3 documents completed)

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
