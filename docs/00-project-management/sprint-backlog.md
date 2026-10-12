# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: Sprint 32
- **Tên Sprint**: Smart Packaged Food Scanning (Barcode & Nutrition Label OCR)
- **Mã Epic / Feature**: `EPIC-SCAN-02` / `FEAT-S32-BARCODE-OCR`
- **Phiên bản mục tiêu**: `v3.4.0`
- **Thời gian Sprint**: 11/10/2026 – 25/10/2026
- **Trạng thái Sprint**: 🏁 **COMPLETED**
- **Tổng Story Points cam kết**: **13 SP** (Tiến độ: **13 / 13 SP — 100%**)

---

## 🎯 Mục Tiêu Sprint 32: Quét Mã Vạch & Bóc Tách Bảng Dinh Dưỡng Thực Phẩm Đóng Gói (Hoàn Thành)

1. **Gate 0 & Gate 1 (2 SP)**: Ban hành ADR-038 & PRD + User Stories BDD cho luồng Barcode & Nutrition Label OCR (Hybrid Ponytail Vision + Open Food Facts API, 0 new packages).
2. **Gate 2 & Gate 3 (2 SP)**: Thiết kế Smart Bounding Box HUD, Mode Switcher Pill và Master Test Plan bao phủ edge cases (mã mờ, nhãn cong, thiếu mạng).
3. **Gate 4 (5 SP)**: Triển khai Dual-mode `CameraPage`, Vision Prompt chuyên biệt cho bảng dinh dưỡng, `BarcodeLookupService` và tích hợp `ScanReviewPage`.
4. **Gate 5, 6, 6.5 & 7 (4 SP)**: Ponytail Clean Review, Automated Tests 100% xanh (333/333 tests), Security Clearance quyền Camera và phát hành `v3.4.0`.

---

## 📋 Bảng Kanban Sprint 32

### 1. 📝 BACKLOG / QUEUED — [0 SP]

### 2. ⚡ IN PROGRESS — [0 SP]

### 3. 🏁 DONE — [13 SP]
| Mã Task | Màn Hình / File | Gate | Mô Tả | Sub-Agent Phụ Trách | SP | Trạng Thái |
|:---|:---|:---:|:---|---|:---:|:---|
| `TSK-S32-00-SPIKE` | `docs/superpowers/specs/2026-10-11-sprint-32-barcode-nutrition-label-ocr-design.md` | **G0** | Tech Lead: Architectural Spec & ADR-038 (Hybrid Ponytail Vision) | `tech-lead` | 1 | 🏁 **DONE** |
| `TSK-S32-01-PRD` | `docs/03-prd-features/39-barcode-nutrition-label-ocr/prd-barcode-nutrition-label-ocr.md` | **G1** | BA: Soạn PRD & Data Dictionary luồng Barcode/OCR | `business-analyst` | 1 | 🏁 **DONE** |
| `TSK-S32-02-DESIGN` | `docs/03-prd-features/39-barcode-nutrition-label-ocr/ui-design.md` | **G2** | UI/UX Designer: Smart Bounding Box & Mode Switcher Pill | `ui-ux-designer` | 1 | 🏁 **DONE** |
| `TSK-S32-03-TEST-PLAN` | `docs/03-prd-features/39-barcode-nutrition-label-ocr/gate-3-test.md` | **G3** | QA Tester: Lập kế hoạch kiểm thử BDD Gherkin | `qa-tester` | 1 | 🏁 **DONE** |
| `TSK-S32-04-VISION-PROMPT` | `lib/features/scanner/data/nutrition_label_prompt.dart` | **G4** | Cloud AI Dev: Xây dựng System Prompt parse bảng nhãn | `cloud-ai-dev` | 2 | 🏁 **DONE** |
| `TSK-S32-05-BARCODE-SVC` | `lib/features/scanner/data/barcode_lookup_service.dart` | **G4** | Dev Core: Tích hợp Open Food Facts REST API client | `flutter-core-dev` | 1 | 🏁 **DONE** |
| `TSK-S32-06-SCAN-MODE-UI` | `lib/features/scanner/presentation/pages/camera_page.dart` | **G4** | Dev Core: Bổ sung Mode Pill Switcher & Smart Viewfinder | `flutter-core-dev` | 2 | 🏁 **DONE** |
| `TSK-S32-07-REVIEW` | Codebase & Git Diff | **G5** | Reviewer: Ponytail Diff Review, kiểm soát line count | `code-reviewer` | 1 | 🏁 **DONE** |
| `TSK-S32-08-SIGN-OFF` | Gate 6, 6.5, 7 Sign-offs | **G6/G7** | QA & Security & PO: Kiểm thử 100% pass (333/333) & Release | `qa-tester` | 3 | 🏁 **DONE** |

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

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
