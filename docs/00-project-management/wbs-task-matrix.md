# Ma Trận Phân Rã Công Việc 6 Cổng (WBS Task Matrix)

- **Quản lý bởi**: Sub-Agent Project Manager (PM) & Sub-Agent Product Owner (PO)
- **Ánh xạ quy trình**: 6-Gate Delivery Flow (BA ➔ QA ➔ Dev FE ➔ Code Review ➔ Verification ➔ Release)
- **Cập nhật lần cuối**: 2026-09-18

---

## 🏗️ 1. Bảng Ma Trận Phân Rã WBS Sprint 02 (v1.1.0 Enhancements — Active)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-MUL-01`** | `FEAT-06` Multi-Item | **Gate 1** | Soạn thảo PRD & BDD Given-When-Then nhận diện nhiều món ăn | `business-analyst` | 2 | None | 🟡 Ready for BA |
| **`TSK-OFF-01`** | `FEAT-07` Offline-Sync | **Gate 1** | Soạn thảo PRD & BDD cơ chế đệm dữ liệu cục bộ & tự động sync | `business-analyst` | 1 | None | 🟡 Ready for BA |
| **`TSK-MIC-01`** | `FEAT-08` Micronutrients | **Gate 1** | Soạn thảo PRD & BDD mở rộng theo dõi Natri, Xơ, Đường | `business-analyst` | 1 | None | 🟡 Ready for BA |
| **`TSK-MUL-02`** | `FEAT-06` Multi-Item | **Gate 2** | Thiết kế Manual TCs & Gherkin scenarios cho đĩa cơm đa món | `qa-tester` | 2 | TSK-MUL-01 | ⚪ Pending |
| **`TSK-OFF-02`** | `FEAT-07` Offline-Sync | **Gate 2** | Thiết kế Manual TCs & kịch bản mất mạng / phục hồi kết nối | `qa-tester` | 1 | TSK-OFF-01 | ⚪ Pending |
| **`TSK-MIC-02`** | `FEAT-08` Micronutrients | **Gate 2** | Thiết kế Manual TCs & BDD cảnh báo vượt ngưỡng vi chất | `qa-tester` | 1 | TSK-MIC-01 | ⚪ Pending |
| **`TSK-MUL-03`** | `FEAT-06` Multi-Item | **Gate 3** | Cập nhật Gemini 2.0 Vision Prompt & UI danh sách bóc tách món | `flutter-expert` | 4 | TSK-MUL-02 | ⚪ Pending |
| **`TSK-OFF-03`** | `FEAT-07` Offline-Sync | **Gate 3** | Triển khai Local Hive Repository & Connectivity Sync Notifier | `flutter-expert` | 3 | TSK-OFF-02 | ⚪ Pending |
| **`TSK-MIC-03`** | `FEAT-08` Micronutrients | **Gate 3** | Cập nhật Freezed FoodLog DTO & UI Chips Vi chất | `flutter-expert` | 1 | TSK-MIC-02 | ⚪ Pending |
| **`TSK-S2-REV`**  | Toàn bộ Sprint 02 | **Gate 4** | Ponytail Code Review: Kiểm soát phình to code & zero bloat | `code-reviewer` | 2 | TSK-MUL-03, TSK-OFF-03 | ⚪ Pending |
| **`TSK-S2-VER`**  | Toàn bộ Sprint 02 | **Gate 5** | Chạy automated test suite 100% Pass, test offline & ký sign-off | `qa-tester` | 2 | TSK-S2-REV | ⚪ Pending |
| **`TSK-REL-02`** | Release v1.1.0 | **Gate 6** | Nghiệm thu tổng thể, gắn Git Tag `v1.1.0` và đóng Sprint 02 | `project-manager` & `product-owner` | 2 | TSK-S2-VER | ⚪ Pending |

---

## 🏛️ 2. Lưu Trữ Ma Trận WBS Sprint 01 (v1.0.0 MVP — 100% Done)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: |
| **`TSK-AUT-01..05`** | `FEAT-01` Auth | **Gate 1 - 5** | PRD, TCs, UI LoginPage, Riverpod, Sign-off | Đa Sub-Agents | 11 | 🟢 Done |
| **`TSK-SCN-01..05`** | `FEAT-02` Scanner | **Gate 1 - 5** | PRD Vision AI, TCs, FoodScannerPage, Latency < 2.5s | Đa Sub-Agents | 19 | 🟢 Done |
| **`TSK-TRK-01..05`** | `FEAT-03` Diary | **Gate 1 - 5** | PRD Diary, TCs Slider, ManualEntryPage, 86 tests pass | Đa Sub-Agents | 13 | 🟢 Done |
| **`TSK-ANA-01..02`** | `FEAT-04` Analytics | **Gate 4 - 5** | Ponytail Review, RepaintBoundary FL Chart, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-PRO-01..02`** | `FEAT-05` Profile | **Gate 4 - 5** | Ponytail Review, BMR/TDEE calculations, Sign-off | Đa Sub-Agents | 5 | 🟢 Done |
| **`TSK-REL-01`** | Release v1.0.0 | **Gate 6** | Release notes, Git Tag v1.0.0, PO sign-off phát hành | PO & PM | 3 | 🟢 Done |

---

## 🧭 Quy Định Vận Hành Của Sub-Agent PM & PO
1. **Quy tắc chuyển giao Gate**: Task ở Gate sau chỉ được bắt đầu khi Gate trước đã có văn bản nghiệm thu chính thức từ Sub-Agent tương ứng.
2. **Quyền hạn cập nhật**: Chỉ Sub-Agent PM mới có quyền cập nhật trạng thái tiến độ thực thi; chỉ Sub-Agent PO có quyền điều chỉnh phạm vi và ký phát hành.
