---
name: feature-lifecycle
description: "Unified End-to-End Feature Delivery Lifecycle skill for AstroBite. Orchestrates the 6 independent sub-agents: PO strategy -> BA requirements (PRD/BDD) -> PM sprint & WBS -> QA test design -> FE Flutter Clean Architecture -> Code Review (Ponytail) -> Verification -> Super-repo Release."
license: MIT
metadata:
  version: "2.0.0"
  domain: product-engineering
  triggers: progress feature, new feature, feature lifecycle, quy trinh feature, develop feature, release feature, end-to-end delivery, 6 gates
  role: technical-delivery-director
  scope: multi-subagent-lifecycle-orchestration
  output-format: markdown
  related-skills: product-owner, project-manager, business-analyst, qa-tester, flutter-expert, code-reviewer, flutter-testing, brainstorming
---

# Unified Feature Delivery Lifecycle Skill (6-Gate SOP & Multi Sub-Agent)

Kỹ năng điều phối quy trình phát triển tính năng toàn diện cho dự án **AstroBite**, kết nối nhịp nhàng **6 Sub-Agents độc lập** theo nguyên tắc kiểm soát chéo (Four-Eyes Principle / Checks & Balances):

```
[Sub-Agent PO] ──────────► [Gate 1: Sub-Agent BA] ──────────► [Sub-Agent PO Duyệt]
(Roadmap & Epics)           (PRD & User Stories BDD)            (Gate 1 Sign-Off)
                                                                       │
                                                                       ▼
[Gate 4: Sub-Agent Review] ◄── [Gate 3: Sub-Agent Dev] ◄──── [Sub-Agent PM]
(Ponytail Diff Review)         (Flutter Clean Architecture)     (Sprint & WBS Tasks)
       │                                                               │
       ▼                                                               ▼
[Gate 5: Sub-Agent QA] ──────► [Gate 6: PO & PM Release] ◄─── [Gate 2: Sub-Agent QA]
(Verification 100% Pass)       (Final Release Sign-Off)         (Manual TCs & BDD .feature)
```

---

## 🎯 Khi Nào Kích Hoạt Skill Này?
- Khi bắt đầu triển khai một tính năng mới từ đầu (từ ý tưởng đến khi phát hành).
- Khi người dùng hỏi: *"Quy trình phát triển feature gồm những bước nào?"* hoặc yêu cầu *"triển khai feature X theo 6 Cổng"*.
- Để kiểm tra xem một tính năng đã vượt qua đủ các cổng chất lượng và có chữ ký nghiệm thu hợp lệ hay chưa.

---

## 🧭 Vận Hành 6 Cổng Chất Lượng & Phân Nhiệm Sub-Agent

### 👑 Chiến Lược & Độ Ưu Tiên (Product Strategy — Sub-Agent PO)
- **Sub-Agent đảm nhiệm**: `product-owner`
- **Thư mục mục tiêu**: `docs/00-roadmap/`
- **Sản phẩm**: Cập nhật `product-roadmap.md` và phân loại MoSCoW trong `epics-backlog.md`.
- **Hành động**: Định hình phạm vi và kích hoạt Sub-Agent BA khởi động Gate 1.

### 🚪 CỔNG 1: Phân Tích Nghiệp Vụ (BA Gate)
- **Sub-Agent đảm nhiệm**: `business-analyst`
- **Thư mục mục tiêu**: `docs/03-prd-features/<id>-<feature>/`
- **Các sản phẩm bắt buộc**:
  1. `prd-<feature>.md`: Bối cảnh, mục tiêu kinh doanh, User Personas, Functional Requirements.
  2. `user-stories.md`: User Stories kèm Acceptance Criteria chuẩn BDD (`Given - When - Then`).
  3. `ui-ux-screen-specs.md`: Đặc tả màn hình, Celestial Dark UI tokens.
  4. Cập nhật `docs/04-specifications/data-dictionary.md` nếu có dữ liệu mới.
- **Quy tắc vượt cổng (Four-Eyes)**: **Sub-Agent PO thẩm định và ký duyệt Gate 1 Sign-Off**. BA không tự duyệt sản phẩm của mình.

### 🏃 Lập Kế Hoạch Sprint & Phân Rã WBS (Delivery Planning — Sub-Agent PM)
- **Sub-Agent đảm nhiệm**: `project-manager`
- **Thư mục mục tiêu**: `docs/00-project-management/`
- **Sản phẩm**: Đưa tính năng vào `sprint-backlog.md`, lập ma trận phân rã `wbs-task-matrix.md` ánh xạ các task từ Gate 2 đến Gate 6, chấm điểm Fibonacci Story Points (`1, 2, 3, 5, 8`).

### 🚪 CỔNG 2: Thiết Kế Kiểm Thử (QA Gate)
- **Sub-Agent đảm nhiệm**: `qa-tester`
- **Thư mục mục tiêu**: `tests/`
- **Các sản phẩm bắt buộc**:
  1. `tests/02-manual-testcases/<id>-<feature>/TC-<feature>-*.md`: Bao phủ Happy Path, Boundary Value Analysis (BVA), và Negative Cases.
  2. `tests/03-bdd-gherkin-scenarios/<feature>.feature`: Kịch bản BDD chuẩn Gherkin khớp 100% với Acceptance Criteria của BA.
- **Quy tắc vượt cổng**: Ma trận truy vết (Traceability Matrix) đạt 100% độ bao phủ User Story. Sub-Agent QA bàn giao kịch bản test cho Dev FE.

### 🚪 CỔNG 3: Phát Triển Mã Nguồn (Frontend Dev Gate — Powered by Ponytail)
- **Kỹ năng sử dụng**: `flutter-expert` & `ponytail`
- **Thư mục mục tiêu**: `frontend/lib/features/<feature>/`
- **Kỷ luật phát triển**: Bắt buộc tuân thủ triết lý Ponytail:
  1. YAGNI: Không tạo class, abstraction trừu tượng chỉ có 1 implementation.
  2. Tái sử dụng helper/widgets có sẵn trong `lib/core/` và `lib/shared/`.
  3. Dùng Dart/Flutter stdlib trước khi tạo hàm mới hoặc cài dependency ngoài.
  4. Diff ngắn nhất, tối giản nhất, ít file nhất.
- **Các sản phẩm bắt buộc**:
  1. **Domain**: Entities (`@freezed`), Value Objects, Abstract Repositories.
  2. **Data**: Data Sources, DTOs, Repository Implementation.
  3. **Presentation**: Controllers (`@riverpod`), Screens (`@RoutePage`), Custom Widgets.
  4. Tuân thủ bảng màu dinh dưỡng bất biến: Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`.
- **Quy tắc vượt cổng**: `flutter analyze` đạt 0 lỗi, 0 cảnh báo; code tinh gọn chuẩn Ponytail.

### 🚪 CỔNG 4: Rà Soát Mã Nguồn Tối Giản (Code Review Gate — Ponytail)
- **Kỹ năng sử dụng**: `code-reviewer` & `ponytail-review`
- **Thao tác**: Quét diff so với nhánh `main`:
  - Tìm và loại bỏ triệt để: dead code (`delete:`), tự chế lại stdlib (`stdlib:`), dependency thừa (`native:`), abstraction rác 1 caller (`yagni:`), gom gọn code (`shrink:`).
  - Xuất định dạng 1 dòng/phát hiện: `<file>:L<line>: <tag> <what>. <replacement>.`
  - Đánh giá điểm rút gọn dòng: `net: -<N> lines possible.`
- **Quy tắc vượt cổng**: Hoàn tất cắt giảm over-engineering hoặc nhận: `Lean already. Ship.`

### 🚪 CỔNG 5: Kiểm Thử Tự Động & Nghiệm Thu (Verification Gate)
- **Kỹ năng sử dụng**: `flutter-testing` & `qa-tester`
- **Thư mục mục tiêu**: `frontend/test/`, `frontend/integration_test/`, `tests/05-test-execution-reports/`
- **Các sản phẩm bắt buộc**:
  1. Unit tests và Widget tests cho feature mới: `flutter test` đạt 100% Pass.
  2. Integration tests ánh xạ từ file `.feature`: `frontend/integration_test/<feature>_flow_test.dart`.
  3. Kiểm thử phi chức năng: Hiệu năng (FPS >= 55, AI latency <= 2.5s), Offline persistence, App Check.
  4. Biên bản nghiệm thu: `tests/05-test-execution-reports/release-sign-offs/signoff-<feature>.md`.
- **Quy tắc vượt cổng**: 0 Bug nghiêm trọng (Blocker/Critical), QA Lead & PO ký duyệt Sign-off.

### 🚪 CỔNG 6: Tích Hợp Super-Repo & Phát Hành (Release Gate)
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
3. Xin duyệt Cổng 1, sau đó kích hoạt **Cổng 2 (`qa-tester`)** để viết Testcases và file `.feature`.
4. Xin duyệt Cổng 2, sau đó kích hoạt **Cổng 3 (`flutter-expert`)** để viết code Clean Architecture.
5. Kích hoạt **Cổng 4 (`code-reviewer`)** để rà soát over-engineering theo chuẩn Ponytail.
6. Kích hoạt **Cổng 5 (`flutter-testing`)** để chạy test và tạo checklist nghiệm thu.
7. Hướng dẫn chạy các lệnh Git Submodule ở **Cổng 6** để hoàn tất phát hành.
