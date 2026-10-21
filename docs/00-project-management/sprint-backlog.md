# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 33
- **Tên Sprint**: Water Intake & Hydration Tracker (Theo dõi lượng nước uống, Claymorphic 60 FPS, đồng bộ Dashboard)
- **Mã Epic / Feature**: `EPIC-HYDRATE-01` / `FEAT-S33-WATER-TRACKER`
- **Phiên bản mục tiêu**: `v3.5.0`
- **Thời gian Sprint**: 19/10/2026 – 02/11/2026
- **Trạng thái Sprint**: ⚡ **IN_PROGRESS**
- **Trạng thái Sprint**: ⚡ **IN_PROGRESS**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **6 / 13 SP — 46%**)

---

## 🎯 Mục Tiêu Sprint 33: Theo Dõi & Nhắc Nhở Uống Nước Tự Động (Water Intake Tracker)

1. **Gate 0 & Gate 1 (2 SP)**: Ban hành ADR-039 (Kiến trúc lưu trữ Hydration: Local SharedPreferences/Hive cache + Cloud Firestore sync ngầm, reset 00:00) & PRD + User Stories BDD luồng Water Tracker.
2. **Gate 2 & Gate 3 (2 SP)**: Thiết kế Claymorphic Hydration Card, Animated Water Cup / Wave indicator 60 FPS chuẩn 4pt grid, 5 UI states và Master Test Plan bao phủ edge cases (qua ngày mới, sửa mốc nước, offline).
3. **Gate 4 (6 SP)**: Triển khai Domain Entity `WaterLog`, Enhanced Enum `WaterQuickPreset`, `WaterRepository`, `WaterController` (Riverpod) và UI Widget `ClayWaterCard` trên Home Dashboard + `WaterTrackingSheet`.
4. **Gate 5, 6, 6.5 & 7 (3 SP)**: Ponytail Clean Review, Automated Tests 100% xanh (> 340 tests), Security Clearance và phát hành `v3.5.0`.

---

## 📋 Bảng Kanban Sprint 33

### 1. 📝 BACKLOG / QUEUED — [5 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S33-06-UI` | `lib/features/tracker/presentation/widgets/clay_water_card.dart` | **G4** | Dev Core: ClayWaterCard trên Home & Bottom Sheet Quick Add (+250/+500ml) | `flutter-core-dev` | 2 | ⏳ **Queued G4** |
| `TSK-S33-07-REVIEW` | Codebase & Git Diff | **G5** | Reviewer: Ponytail Diff Review, kiểm soát line count < 200 | `code-reviewer` | 1 | ⏳ **Queued G5** |
| `TSK-S33-08-SIGN-OFF` | Gate 6, 6.5, 7 Sign-offs | **G6/G7** | QA & Security & PO: Kiểm thử 100% pass (> 340 tests) & Release v3.5.0 | `qa-tester` | 2 | ⏳ **Queued G6/7** |

### 2. ⚡ IN PROGRESS — [2 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S33-05-REPO` | `lib/features/tracker/data/water_repository.dart` | **G4** | Dev Core & Cloud AI: WaterRepository (Local Cache + Firestore Stream) | `flutter-core-dev` | 2 | ⚡ **IN_PROGRESS** |

### 3. 🏁 DONE — [6 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S33-00-SPIKE` | `docs/superpowers/specs/2026-10-19-sprint-33-water-tracker-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-039 (Local Cache + Firestore Sync) | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S33-01-PRD` | `docs/03-prd-features/40-water-intake-tracker/prd-water-tracker.md` | **G1** | BA: Soạn PRD & User Stories BDD luồng Water Tracker | `business-analyst` | 1 | 🏁 **DONE** |
| `TSK-S33-02-DESIGN` | `docs/03-prd-features/40-water-intake-tracker/ui-design.md` | **G2** | UI/UX Designer: ClayWaterCard & Animated Wave Indicator (4pt grid, 5 states) | `ui-ux-designer` | 1 | 🏁 **DONE** |
| `TSK-S33-03-TEST-PLAN` | `docs/03-prd-features/40-water-intake-tracker/gate-3-test.md` | **G3** | QA Tester: Lập kế hoạch kiểm thử BDD Gherkin & Edge Cases | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S33-04-DOMAIN` | `lib/features/tracker/domain/water_log.dart` | **G4** | Dev Core: Entity WaterLog, Enum WaterQuickPreset, WaterGoalCalculator | `flutter-core-dev` | 2 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 32 — AstroBite v3.4.0 Smart Packaged Food Scanning (Hoàn tất 19/10/2026)
- **Mục tiêu**: Quét mã vạch Open Food Facts API & OCR bảng thành phần dinh dưỡng nhãn hộp bằng Gemini 2.0 Flash Vision (Dual-mode Camera, 0 new packages).
- **Kết quả**: **13 / 13 SP (100% Passed)** — 333/333 tests pass, 0 issue analyze, latency quét < 0.8s, PO ký duyệt phát hành v3.4.0.
- **Biên bản phát hành**: `docs/03-prd-features/39-barcode-nutrition-label-ocr/` & Git tag `v3.4.0`.


### 🟢 Sprint 31 — AstroBite v3.3.0 Internationalization Foundation (Hoàn tất 11/10/2026)
- **Mục tiêu**: Thiết lập nền tảng đa ngôn ngữ chính quy Flutter SDK `flutter_localizations` (Song ngữ VI + EN), chuyển đổi toàn bộ UI strings sang `AppLocalizations`, xóa sạch nợ kỹ thuật `AppStrings`.
- **Kết quả**: **13 / 13 SP (100% Passed)** — 327/327 tests pass, 0 linter issue, hoàn thành cài đặt `LanguageSettingsCard` trong Profile.
- **Biên bản phát hành**: `docs/03-prd-features/38-internationalization-i18n/` & Git tag `v3.3.0`.

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
