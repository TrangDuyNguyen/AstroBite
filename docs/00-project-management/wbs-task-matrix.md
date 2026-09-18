# Ma Trận Phân Rã Công Việc 6 Cổng (WBS Task Matrix)

- **Quản lý bởi**: Sub-Agent Project Manager (PM)
- **Ánh xạ quy trình**: 6-Gate Delivery Flow (BA ➔ QA ➔ Dev FE ➔ Code Review ➔ Verification ➔ Release)
- **Cập nhật lần cuối**: 2026-09-18

---

## 🏗️ Bảng Ma Trận Phân Rã WBS Chi Tiết

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-AUT-01`** | `FEAT-01` Auth | **Gate 1** | Soạn thảo PRD & User Stories luồng Auth / Onboarding | `business-analyst` | 3 | None | 🟢 Done |
| **`TSK-AUT-02`** | `FEAT-01` Auth | **Gate 2** | Thiết kế manual testcases & kịch bản BDD login | `qa-tester` | 2 | TSK-AUT-01 | 🟢 Done |
| **`TSK-AUT-03`** | `FEAT-01` Auth | **Gate 3** | Triển khai giao diện LoginPage & AuthRiverpodNotifier | `flutter-expert` | 3 | TSK-AUT-02 | 🟢 Done |
| **`TSK-AUT-04`** | `FEAT-01` Auth | **Gate 4** | Rà soát mã nguồn Ponytail, dọn dẹp import thừa | `code-reviewer` | 1 | TSK-AUT-03 | 🟢 Done |
| **`TSK-AUT-05`** | `FEAT-01` Auth | **Gate 5** | Chạy automated test suite & lập `signoff-auth-login.md` | `qa-tester` | 2 | TSK-AUT-04 | 🟢 Done |
| **`TSK-SCN-01`** | `FEAT-02` Scanner | **Gate 1** | Soạn thảo PRD Vision AI Gemini 2.0 Flash | `business-analyst` | 3 | None | 🟢 Done |
| **`TSK-SCN-02`** | `FEAT-02` Scanner | **Gate 2** | Thiết kế testcase nhận diện món ăn & BDD | `qa-tester` | 3 | TSK-SCN-01 | 🟢 Done |
| **`TSK-SCN-03`** | `FEAT-02` Scanner | **Gate 3** | Triển khai FoodScannerPage, Gemini Vision Client | `flutter-expert` | 8 | TSK-SCN-02 | 🟢 Done |
| **`TSK-SCN-04`** | `FEAT-02` Scanner | **Gate 4** | Review diff, cắt bỏ abstraction rác trong AI parser | `code-reviewer` | 2 | TSK-SCN-03 | 🟢 Done |
| **`TSK-SCN-05`** | `FEAT-02` Scanner | **Gate 5** | Test độ trễ AI (<2.5s) & ký `signoff-food-scanner.md` | `qa-tester` | 3 | TSK-SCN-04 | 🟢 Done |
| **`TSK-TRK-01`** | `FEAT-03` Diary | **Gate 1** | Soạn PRD Calorie Diary & Manual Food Entry | `business-analyst` | 3 | None | 🟢 Done |
| **`TSK-TRK-02`** | `FEAT-03` Diary | **Gate 2** | Thiết kế testcase BVA slider gram & BDD feature | `qa-tester` | 2 | TSK-TRK-01 | 🟢 Done |
| **`TSK-TRK-03`** | `FEAT-03` Diary | **Gate 3** | Triển khai ManualEntryPage & CustomFoodSheet | `flutter-expert` | 5 | TSK-TRK-02 | 🟢 Done |
| **`TSK-TRK-04`** | `FEAT-03` Diary | **Gate 4** | Ponytail code review, loại bỏ code dư thừa | `code-reviewer` | 1 | TSK-TRK-03 | 🟢 Done |
| **`TSK-TRK-05`** | `FEAT-03` Diary | **Gate 5** | Chạy test (86 tests pass) & ký `signoff-manual-entry.md` | `qa-tester` | 2 | TSK-TRK-04 | 🟢 Done |
| **`TSK-ANA-01`** | `FEAT-04` Analytics | **Gate 4** | Review diff và dọn dẹp over-engineering trong Analytics | `code-reviewer` | 2 | Mã nguồn có sẵn | 🟢 Done |
| **`TSK-ANA-02`** | `FEAT-04` Analytics | **Gate 5** | Kiểm thử Widget FL Chart, đo FPS >= 55 & lập sign-off | `qa-tester` | 3 | TSK-ANA-01 | 🟢 Done |
| **`TSK-PRO-01`** | `FEAT-05` Profile | **Gate 4** | Review mã nguồn Profile, tối ưu hóa công thức BMR/TDEE | `code-reviewer` | 3 | Mã nguồn có sẵn | 🟢 Done |
| **`TSK-PRO-02`** | `FEAT-05` Profile | **Gate 5** | Chạy automated test suite Profile & lập sign-off | `qa-tester` | 2 | TSK-PRO-01 | 🟢 Done |
| **`TSK-REL-01`** | Release v1.0.0 | **Gate 6** | Đồng bộ submodules, verify test toàn hệ thống, tạo git tag | `project-manager` & `product-owner` | 3 | TSK-ANA-02, TSK-PRO-02 | 🟢 Done |

---

## 🧭 Quy Định Vận Hành Của Sub-Agent PM
1. **Liên kết phụ thuộc (Pre-requisites)**: Một task ở Gate sau tuyệt đối không được bắt đầu nếu task ở Gate trước chưa hoàn thành.
2. **Quyền hạn cập nhật**: Chỉ Sub-Agent PM mới có quyền cập nhật trạng thái cột `Trạng Thái` của bảng WBS này sau khi nhận được bằng chứng nghiệm thu từ Sub-Agent tương ứng.
