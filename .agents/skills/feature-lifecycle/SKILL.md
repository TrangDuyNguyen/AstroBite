---
name: feature-lifecycle
description: "Unified End-to-End Feature Delivery Lifecycle skill for AstroBite. Orchestrates the full 5-gate pipeline: BA requirements (PRD/BDD) -> QA test design (Manual/Gherkin) -> FE Flutter Clean Architecture -> Automated & Manual Verification -> Super-repo Git Submodule release."
license: MIT
metadata:
  version: "1.0.0"
  domain: product-engineering
  triggers: progress feature, new feature, feature lifecycle, quy trinh feature, develop feature, release feature, end-to-end delivery
  role: technical-product-lead
  scope: full-lifecycle-orchestration
  output-format: markdown
  related-skills: business-analyst, qa-tester, flutter-expert, flutter-testing, brainstorming
---

# Unified Feature Delivery Lifecycle Skill (SOP)

Kỹ năng điều phối quy trình phát triển tính năng toàn diện cho dự án **AstroBite**, kết nối nhịp nhàng 5 cổng chất lượng (5-Gate Delivery Flow) giữa **BA ➔ QA ➔ Frontend Dev ➔ Verification ➔ Super-repo Release**.

---

## 🎯 Khi Nào Kích Hoạt Skill Này?
- Khi người dùng muốn bắt đầu phát triển một tính năng mới từ đầu (từ ý tưởng đến khi phát hành).
- Khi người dùng hỏi: *"Quy trình phát triển 1 feature mới gồm những bước nào?"* hoặc yêu cầu *"triển khai feature X"*.
- Để kiểm tra xem một tính năng đã vượt qua đủ các cổng chất lượng (Gates) trước khi merge vào nhánh chính hay chưa.

---

## 🧭 Vận Hành 5 Cổng Chất Lượng (The 5 Quality Gates)

```
[Gate 1: BA] ➔ [Gate 2: QA] ➔ [Gate 3: FE Dev] ➔ [Gate 4: Verify] ➔ [Gate 5: Release]
```

### 🚪 CỔNG 1: Phân Tích Nghiệp Vụ (BA Gate)
- **Kỹ năng sử dụng**: `business-analyst`
- **Thư mục mục tiêu**: `docs/03-prd-features/<id>-<feature>/`
- **Các sản phẩm bắt buộc**:
  1. `prd-<feature>.md`: Bối cảnh, mục tiêu kinh doanh, User Personas, Functional Requirements.
  2. `user-stories.md`: User Stories kèm Acceptance Criteria chuẩn BDD (`Given - When - Then`).
  3. `ui-ux-screen-specs.md`: Đặc tả màn hình, Celestial Dark UI tokens.
  4. Cập nhật `docs/04-specifications/data-dictionary.md` nếu có dữ liệu mới.
- **Quy tắc vượt cổng**: PO và Tech Lead phê duyệt PRD.

### 🚪 CỔNG 2: Thiết Kế Kiểm Thử (QA Gate)
- **Kỹ năng sử dụng**: `qa-tester`
- **Thư mục mục tiêu**: `tests/`
- **Các sản phẩm bắt buộc**:
  1. `tests/02-manual-testcases/<id>-<feature>/TC-<feature>-*.md`: Bao phủ Happy Path, Boundary Value Analysis (BVA), và Negative Cases.
  2. `tests/03-bdd-gherkin-scenarios/<feature>.feature`: Kịch bản BDD chuẩn Gherkin khớp 100% với Acceptance Criteria của BA.
- **Quy tắc vượt cổng**: Ma trận truy vết (Traceability Matrix) đạt 100% độ bao phủ User Story.

### 🚪 CỔNG 3: Phát Triển Mã Nguồn (Frontend Dev Gate)
- **Kỹ năng sử dụng**: `flutter-expert`
- **Thư mục mục tiêu**: `frontend/lib/features/<feature>/`
- **Các sản phẩm bắt buộc**:
  1. **Domain**: Entities (`@freezed`), Value Objects, Abstract Repositories.
  2. **Data**: Data Sources, DTOs, Repository Implementation.
  3. **Presentation**: Controllers (`@riverpod`), Screens (`@RoutePage`), Custom Widgets.
  4. Tuân thủ bảng màu dinh dưỡng bất biến: Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`.
- **Quy tắc vượt cổng**: `flutter analyze` đạt 0 lỗi, 0 cảnh báo.

### 🚪 CỔNG 4: Kiểm Thử Tự Động & Nghiệm Thu (Verification Gate)
- **Kỹ năng sử dụng**: `flutter-testing` & `qa-tester`
- **Thư mục mục tiêu**: `frontend/test/`, `frontend/integration_test/`, `tests/05-test-execution-reports/`
- **Các sản phẩm bắt buộc**:
  1. Unit tests và Widget tests cho feature mới: `flutter test` đạt 100% Pass.
  2. Integration tests ánh xạ từ file `.feature`: `frontend/integration_test/<feature>_flow_test.dart`.
  3. Kiểm thử phi chức năng: Hiệu năng (FPS >= 55, AI latency <= 2.5s), Offline persistence, App Check.
  4. Biên bản nghiệm thu: `tests/05-test-execution-reports/release-sign-offs/signoff-<feature>.md`.
- **Quy tắc vượt cổng**: 0 Bug nghiêm trọng (Blocker/Critical), QA Lead & PO ký duyệt Sign-off.

### 🚪 CỔNG 5: Tích Hợp Super-Repo & Phát Hành (Release Gate)
- **Thư mục mục tiêu**: Root Super-Repo `AstroBite/`
- **Các lệnh thực thi**:
  1. Đồng bộ toàn bộ submodule:
     ```bash
     make update
     ```
  2. Chạy test toàn hệ thống:
     ```bash
     make test-fe
     make status
     ```
  3. Commit cập nhật con trỏ Submodules:
     ```bash
     git add docs tests frontend
     git commit -m "feat(release): ship <feature-name> (vX.Y.Z)"
     git push origin main
     ```
  4. Gắn Tag phiên bản phát hành:
     ```bash
     git tag -a vX.Y.Z -m "Release vX.Y.Z: Added <feature-name>"
     git push origin vX.Y.Z
     ```

---

## ⚡ Hướng Dẫn Hội Thoại Khi Triển Khai Tính Năng
Khi người dùng yêu cầu: *"Hãy triển khai tính năng X theo quy trình chuẩn"*, Agent sẽ:
1. Hỏi người dùng các thông tin cơ bản của tính năng (Ý tưởng, mục tiêu, đối tượng).
2. Tự động kích hoạt **Cổng 1 (`business-analyst`)** để viết PRD và User Stories.
3. Xin duyệt Cổng 1, sau đó kích hoạt **Cổng 2 (`qa-tester`)** để viết Testcase và file `.feature`.
4. Xin duyệt Cổng 2, sau đó kích hoạt **Cổng 3 (`flutter-expert`)** để viết code Clean Architecture.
5. Kích hoạt **Cổng 4 (`flutter-testing`)** để chạy test và tạo checklist nghiệm thu.
6. Hướng dẫn chạy các lệnh Git Submodule ở **Cổng 5** để hoàn tất phát hành.
