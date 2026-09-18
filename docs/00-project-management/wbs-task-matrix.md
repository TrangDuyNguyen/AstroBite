# Ma Trận Phân Rã Công Việc 7 Cổng (WBS Task Matrix)

- **Quản lý bởi**: Sub-Agent Project Manager (PM) & Sub-Agent Product Owner (PO)
- **Ánh xạ quy trình**: 7-Gate Delivery Flow (BA ➔ UI/UX Designer ➔ QA ➔ Dev FE ➔ Code Review ➔ Verification ➔ Release)
- **Cập nhật lần cuối**: 2026-09-18

---

## 🏗️ 1. Bảng Ma Trận Phân Rã WBS Sprint 02 (v1.1.0 Enhancements — Active)

| Mã Task | Feature / Epic | Cổng Chất Lượng | Mô Tả Nhiệm Vụ Kỹ Thuật | Sub-Agent Đảm Nhiệm | SP | Phụ Thuộc | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: | :---: | :---: | :---: |
| **`TSK-MUL-01`** | `FEAT-06` Multi-Item | **Gate 1** | Soạn thảo PRD & BDD Given-When-Then nhận diện nhiều món ăn | `business-analyst` | 2 | None | 🟢 Done (PO Approved) |
| **`TSK-OFF-01`** | `FEAT-07` Offline-Sync | **Gate 1** | Soạn thảo PRD & BDD cơ chế đệm dữ liệu cục bộ & tự động sync | `business-analyst` | 1 | None | 🟢 Done (PO Approved) |
| **`TSK-MIC-01`** | `FEAT-08` Micronutrients | **Gate 1** | Soạn thảo PRD & BDD mở rộng theo dõi Natri, Xơ, Đường | `business-analyst` | 1 | None | 🟢 Done (PO Approved) |
| **`TSK-MUL-02`** | `FEAT-06` Multi-Item | **Gate 2** | Thiết kế UI Flow, Layout 4pt và các trạng thái nhận diện đĩa cơm đa món | `ui-ux-designer` | 2 | TSK-MUL-01 | 🟢 Done (BA & PO Signed Off) |
| **`TSK-OFF-02`** | `FEAT-07` Offline-Sync | **Gate 2** | Thiết kế Banner ngoại tuyến, huy hiệu sync và trạng thái cache | `ui-ux-designer` | 1 | TSK-OFF-01 | 🟢 Done (BA & PO Signed Off) |
| **`TSK-MIC-02`** | `FEAT-08` Micronutrients | **Gate 2** | Thiết kế UI Chips vi chất, thanh đo và cảnh báo vượt ngưỡng | `ui-ux-designer` | 1 | TSK-MIC-01 | 🟢 Done (BA & PO Signed Off) |
| **`TSK-MUL-03`** | `FEAT-06` Multi-Item | **Gate 3** | Thiết kế Manual TCs & Gherkin scenarios cho đĩa cơm đa món | `qa-tester` | 2 | TSK-MUL-02 | 🟢 Done (QA & PM Signed Off) |
| **`TSK-OFF-03`** | `FEAT-07` Offline-Sync | **Gate 3** | Thiết kế Manual TCs & kịch bản mất mạng / phục hồi kết nối | `qa-tester` | 1 | TSK-OFF-02 | 🟢 Done (QA & PM Signed Off) |
| **`TSK-MIC-03`** | `FEAT-08` Micronutrients | **Gate 3** | Thiết kế Manual TCs & BDD cảnh báo vượt ngưỡng vi chất | `qa-tester` | 1 | TSK-MIC-02 | 🟢 Done (QA & PM Signed Off) |
| **`TSK-MUL-04`** | `FEAT-06` Multi-Item | **Gate 4** | Cập nhật Gemini 2.0 Vision Prompt & UI danh sách bóc tách món | `flutter-expert` | 4 | TSK-MUL-03 | 🟢 Done (Dev FE Finished) |
| **`TSK-OFF-04`** | `FEAT-07` Offline-Sync | **Gate 4** | Triển khai Local Cache Datasource & Sync Queue, Banner | `flutter-expert` | 3 | TSK-OFF-03 | 🟢 Done (Dev FE Finished) |
| **`TSK-MIC-04`** | `FEAT-08` Micronutrients | **Gate 4** | Cập nhật Freezed FoodLog DTO, DailyMicronutrientCard & UI Chips | `flutter-expert` | 1 | TSK-MIC-03 | 🟢 Done (Dev FE Finished) |
| **`TSK-S2-REV`**  | Toàn bộ Sprint 02 | **Gate 5** | Ponytail Code Review: Kiểm soát phình to code & zero bloat | `code-reviewer` | 2 | TSK-MUL-04, TSK-OFF-04 | 🟢 Done (Reviewer Signed Off: "Lean already. Ship.") |
| **`TSK-S2-VER`**  | Toàn bộ Sprint 02 | **Gate 6** | Chạy automated test suite 100% Pass, test offline & ký sign-off | `qa-tester` | 2 | TSK-S2-REV | 🟢 Done (QA Signed Off: Release Approved) |
| **`TSK-REL-02`** | Release v1.1.0 | **Gate 7** | Nghiệm thu tổng thể, gắn Git Tag `v1.1.0` và đóng Sprint 02 | `project-manager` & `product-owner` | 2 | TSK-S2-VER | ⚡ Ready for Release |

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
1. **Quy tắc chuyển giao Gate**: Task ở Gate sau chỉ được bắt đầu khi Gate trước đã có văn bản nghiệm thu chính thức từ Sub-Agent tương ứng (Gate 1: PO sign-off; Gate 2: BA & PO sign-off; Gate 3: QA Traceability 100%; Gate 4: Flutter analyze 0 error; Gate 5: Reviewer "Lean already. Ship."; Gate 6: QA Release sign-off; Gate 7: PO & PM Release).
2. **Quyền hạn cập nhật**: Chỉ Sub-Agent PM mới có quyền cập nhật trạng thái tiến độ thực thi; chỉ Sub-Agent PO có quyền điều chỉnh phạm vi và ký phát hành.
