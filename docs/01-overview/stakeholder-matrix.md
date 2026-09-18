# Ma Trận Phân Nhiệm Các Bên Liên Quan & Hệ Thống Đa Sub-Agent (RACI Matrix)

> Tài liệu này chuẩn hóa vai trò và quyền hạn của **6 Sub-Agent Độc Lập** trong quy trình quản trị và phát triển ứng dụng AstroBite theo nguyên tắc kiểm soát chéo (Four-Eyes Principle).

---

## 1. Danh Sách 6 Sub-Agents Chuyên Trách

1. **Sub-Agent Product Owner (PO)** (`product-owner`): Định hướng chiến lược, phân loại MoSCoW, phê duyệt Lộ trình 3 Chân trời và ký duyệt phát hành tối cao.
2. **Sub-Agent Project Manager (PM)** (`project-manager`): Điều phối Sprint, phân rã WBS theo 6 Cổng, ước lượng Fibonacci Story Points, giám sát Capacity và giải tỏa điểm nghẽn.
3. **Sub-Agent Business Analyst (BA)** (`business-analyst`): Làm rõ nghiệp vụ, soạn thảo PRD, viết User Stories chuẩn BDD (Given-When-Then), cập nhật Data Dictionary.
4. **Sub-Agent QA Tester (QA)** (`qa-tester` & `flutter-testing`): Thiết kế Master Test Plan, Manual Testcases (EP/BVA), kịch bản Gherkin `.feature`, kiểm thử phi chức năng và lập biên bản Gate 5.
5. **Sub-Agent Flutter Developer (Dev FE)** (`flutter-expert` & `ponytail`): Xây dựng mã nguồn Feature-First Clean Architecture, Riverpod, AutoRoute và giao diện Celestial Dark UI chuẩn Ponytail.
6. **Sub-Agent Code Reviewer (Reviewer)** (`code-reviewer` & `ponytail-review`): Rà soát git diff tại Gate 4, loại bỏ over-engineering, dead code, và cấp chứng chỉ `Lean already. Ship.`.

---

## 2. Ma Trận RACI (Responsible, Accountable, Consulted, Informed)

| Hạng Mục Trách Nhiệm | Sub-Agent PO | Sub-Agent PM | Sub-Agent BA | Sub-Agent Dev FE | Sub-Agent Reviewer | Sub-Agent QA |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Xác định Tầm nhìn & Roadmap 3 Chân trời** | **A** | C | R | I | I | I |
| **Quản lý Epics & Phân loại MoSCoW** | **A** | C | R | I | I | I |
| **Soạn thảo PRD & Tiêu chí Nghiệm thu BDD** | C | I | **R** | C | I | C |
| **Phê duyệt PRD Gate 1 (PRD Sign-off)** | **A** | I | R | I | I | I |
| **Lập kế hoạch Sprint & Phân rã WBS 6 Cổng** | C | **A / R** | C | C | C | C |
| **Ước lượng Story Points & Quản trị Rủi ro** | I | **A / R** | I | C | C | C |
| **Thiết kế Kịch bản Kiểm thử Gate 2 (EP/BVA/BDD)**| I | I | C | I | I | **A / R** |
| **Triển khai Mã nguồn Flutter Gate 3 (Ponytail)** | I | I | I | **A / R** | C | I |
| **Rà soát Mã nguồn Gate 4 (Cắt Over-engineering)**| I | I | I | C | **A / R** | I |
| **Kiểm thử Tự động & Ký duyệt Gate 5 Sign-off** | I | I | I | I | I | **A / R** |
| **Nghiệm thu Tổng thể & Ký duyệt Phát hành Gate 6**| **A** | R | I | I | I | C |

*Ghi chú định nghĩa*:
- **R (Responsible)**: Người/Sub-Agent trực tiếp thực thi công việc.
- **A (Accountable)**: Người/Sub-Agent chịu trách nhiệm giải trình và có quyền ký duyệt tối cao (mỗi việc chỉ có duy nhất 1 Accountable).
- **C (Consulted)**: Bên được tham vấn ý kiến chuyên môn hai chiều trước khi ra quyết định.
- **I (Informed)**: Bên được cập nhật thông tin một chiều về tiến độ và kết quả.

---

## 3. Nguyên Tắc Bất Khả Xâm Phạm (Four-Eyes Principle)
- Tuyệt đối không một Sub-Agent nào được tự đóng vai trò cả **R** và **A** trong cùng một công việc phê duyệt.
- `BA` (R) soạn PRD ➔ Bắt buộc `PO` (A) phê duyệt Gate 1.
- `Dev FE` (R) viết code ➔ Bắt buộc `Reviewer` (A) duyệt Gate 4 và `QA` (A) duyệt Gate 5.
- `PM` (R) phân rã Sprint ➔ Không có quyền tự ý thay đổi phạm vi của `PO` (A).
