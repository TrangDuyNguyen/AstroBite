# Kế Hoạch Triển Khai Cấu Trúc Thư Mục & Git Submodules — AstroBite

Tài liệu này xác định các bước cụ thể để hiện thực hóa kiến trúc đã được thẩm định tại [2026-09-14-project-structure-git-submodules-design.md](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/superpowers/specs/2026-09-14-project-structure-git-submodules-design.md).

---

## Mục Tiêu Cần Đạt Được
1. **Thiết lập Super-Repo Tooling**: Cung cấp file `.gitmodules`, `Makefile`, và các script tự động hóa trong `scripts/` (`setup-workspace.sh`, `sync-submodules.sh`, `check-status.sh`, `migrate-frontend-submodule.sh`).
2. **Khởi tạo Khung Thư mục & Mẫu Tài liệu Chuẩn BA (`docs/`)**: Khởi tạo trọn vẹn cây thư mục chuẩn BABOK/Agile, bao gồm các tài liệu tổng quan, quy tắc nghiệp vụ dinh dưỡng/AI, đặc tả 5 feature chính, từ điển dữ liệu và templates mẫu.
3. **Khởi tạo Khung Thư mục & Kịch bản Kiểm Thử Chuẩn QA (`tests/`)**: Khởi tạo đầy đủ Master Test Plan, testcase thủ công cho 5 module, kịch bản BDD Gherkin (`.feature`), kiểm thử phi chức năng và templates báo cáo lỗi/nghiệm thu.
4. **Chuẩn bị Cấu trúc FE Flutter (`frontend/`)**: Đảm bảo toàn vẹn mã nguồn Flutter hiện có, cung cấp kịch bản di chuyển an toàn sang thư mục con `frontend/` và kết nối với submodule `astrobite-frontend`.

---

## Các Thay Đổi Đề Xuất (Proposed Changes)

### 1. Tầng Root Super-Repo

#### [NEW] `Makefile`
- Cung cấp các lệnh: `make setup`, `make update`, `make status`, `make pull`, `make test-fe`.

#### [NEW] `scripts/setup-workspace.sh`
- Script tự động khởi tạo và cập nhật toàn bộ submodule khi clone mới.

#### [NEW] `scripts/sync-submodules.sh`
- Script kéo code mới nhất từ remote của cả 3 submodule với kiểm tra nhánh an toàn.

#### [NEW] `scripts/check-status.sh`
- Script hiển thị trực quan nhánh, commit hash và tình trạng thay đổi của từng submodule.

#### [NEW] `scripts/migrate-frontend-submodule.sh`
- Kịch bản hỗ trợ di dời code Flutter sang thư mục `frontend/` hoặc repo `astrobite-frontend`.

#### [NEW] `.gitmodules`
- Khai báo 3 submodule: `docs` (`astrobite-ba-docs`), `tests` (`astrobite-testcases`), `frontend` (`astrobite-frontend`).

---

### 2. Submodule 1: Tài liệu Chuẩn BA (`docs/`)

#### [NEW] Khung Thư mục & Mẫu Tài liệu:
- `docs/README.md`: Giới thiệu chuẩn Docs-as-Code.
- `docs/01-overview/`:
  - `product-vision.md`
  - `stakeholder-matrix.md`
  - `glossary-terms.md`
- `docs/02-business-rules/`:
  - `nutrition-algorithms.md`
  - `ai-vision-policy.md`
  - `compliance-privacy.md`
- `docs/03-prd-features/`:
  - `01-auth-onboarding/` (`prd-auth-onboarding.md`, `user-stories.md`, `ui-ux-screen-specs.md`)
  - `02-food-scanner-ai/` (`prd-food-scanner.md`, `user-stories.md`, `ui-ux-screen-specs.md`)
  - `03-diary-calorie-tracker/` (`prd-calorie-tracker.md`, `user-stories.md`, `ui-ux-screen-specs.md`)
  - `04-analytics-insights/` (`prd-analytics.md`, `user-stories.md`, `ui-ux-screen-specs.md`)
  - `05-user-profile-goals/` (`prd-user-profile.md`, `user-stories.md`, `ui-ux-screen-specs.md`)
- `docs/04-specifications/`:
  - `data-dictionary.md`
  - `third-party-integrations.md`
- `docs/05-change-management/`:
  - `change-request-log.md`
- `docs/templates/`:
  - `template-prd.md`
  - `template-user-story.md`
  - `template-change-request.md`

---

### 3. Submodule 2: Testcases & QA (`tests/`)

#### [NEW] Khung Thư mục & Mẫu Kiểm Thử:
- `tests/README.md`: Chiến lược kiểm thử.
- `tests/01-test-strategy-plan/`:
  - `master-test-plan.md`
  - `test-environment-matrix.md`
  - `defect-management-matrix.md`
- `tests/02-manual-testcases/`:
  - `01-auth-onboarding/TC-auth-functional.md`
  - `02-food-scanner-ai/TC-scanner-camera-gallery.md`
  - `03-diary-calorie-tracker/TC-diary-logging.md`
  - `04-analytics-insights/TC-analytics-charts.md`
  - `05-user-profile-goals/TC-profile-goal-setting.md`
- `tests/03-bdd-gherkin-scenarios/`:
  - `auth_onboarding.feature`
  - `food_scanner_gemini.feature`
  - `calorie_diary.feature`
  - `profile_management.feature`
- `tests/04-non-functional-tests/`:
  - `performance-testing.md`
  - `security-compliance.md`
  - `network-offline-testing.md`
  - `ui-ux-design-consistency.md`
- `tests/05-test-execution-reports/`:
  - `release-sign-offs/`
  - `sprint-reports/`
- `tests/templates/`:
  - `template-testcase.md`
  - `template-bug-report.md`
  - `template-release-checklist.md`

---

## Kế Hoạch Kiểm Tra & Xác Minh (Verification Plan)

### Kiểm tra Tự động
1. **Kiểm tra quyền thực thi của Scripts**:
   ```bash
   chmod +x scripts/*.sh
   ls -la scripts/
   ```
2. **Kiểm tra cú pháp Makefile**:
   ```bash
   make status
   ```
3. **Kiểm tra tính toàn vẹn của mã nguồn Flutter**:
   ```bash
   flutter test
   ```
