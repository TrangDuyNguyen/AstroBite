# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: `Sprint 02`
- **Phiên bản mục tiêu**: `v1.1.0` (Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline)
- **Thời gian chu kỳ**: 2026-10-03 đến 2026-10-17 (Chu kỳ 2 tuần)
- **Mục tiêu Sprint (Sprint Goal)**: Nâng cấp năng lực Gemini Vision AI nhận diện đồng thời nhiều món ăn trên một mâm (`EPIC-06`), kiến tạo bộ nhớ đệm Offline-First Resilience tự đồng bộ Cloud Firestore (`EPIC-09`), và mở rộng theo dõi vi chất dinh dưỡng (`EPIC-08`), bảo đảm tiêu chuẩn 7 Cổng Chất Lượng (7-Gate SOP).
- **Tổng Story Points cam kết (Target Capacity)**: **20 SP**
- **Trạng thái Sprint**: 🟢 **Hoàn Tất Gate 6 — Sẵn Sàng Kích Hoạt Gate 7 (PO & PM Super-Repo Release)**

---

## 📋 Bảng Kanban Trực Quan Sprint 02 (v1.1.0)

### 1. 📝 TODO — [0 SP]
*(Toàn bộ các tác vụ kỹ thuật đã hoàn tất 100%)*

### 2. ⚡ IN PROGRESS (Sẵn Sàng Gate 7 Phát Hành) — [2 SP]
- [ ] `TSK-REL-02` [Gate 7]: Nghiệm thu tổng thể, gắn Git Tag `v1.1.0` và đóng Sprint 02 — *Sub-Agent PO & PM* `(2 SP)` — *Sẵn sàng kích hoạt*

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]
*(Gate 5 & Gate 6 đã hoàn tất nghiệm thu và ký biên bản)*

### 4. 🏁 DONE (Gate 1, Gate 2, Gate 3, Gate 4, Gate 5 & Gate 6 Hoàn Tất) — [24 SP]
- [x] `TSK-S2-VER` [Gate 6]: Chạy automated test suite 100% Pass, kiểm thử phi chức năng & ký Release Sign-Off — *Sub-Agent qa-tester* `(2 SP)` — *QA Đã Ký Duyệt Sign-Off*
- [x] `TSK-S2-REV` [Gate 5]: Ponytail Code Review: Kiểm soát phình to code & zero bloat — *Sub-Agent code-reviewer* `(2 SP)` — *Reviewer Đã Ký Duyệt: Lean already. Ship.*
- [x] `TSK-MUL-01` [Gate 1]: Soạn thảo PRD & User Stories BDD cho Multi-Item Food Scanner AI (`FEAT-06`) — *Sub-Agent BA* `(2 SP)` — *PO Đã Ký Duyệt*
- [x] `TSK-OFF-01` [Gate 1]: Soạn thảo PRD & User Stories BDD cho Offline-First Local Cache & Sync (`FEAT-07`) — *Sub-Agent BA* `(1 SP)` — *PO Đã Ký Duyệt*
- [x] `TSK-MIC-01` [Gate 1]: Soạn thảo PRD & User Stories BDD cho Micronutrients Tracking (`FEAT-08`) — *Sub-Agent BA* `(1 SP)` — *PO Đã Ký Duyệt*
- [x] `TSK-MUL-02` [Gate 2]: Thiết kế UI Flow, Layout 4pt và các trạng thái nhận diện đĩa cơm đa món — *Sub-Agent UI/UX Designer* `(2 SP)` — *BA & PO Đã Ký Duyệt*
- [x] `TSK-OFF-02` [Gate 2]: Thiết kế Banner ngoại tuyến, huy hiệu sync và trạng thái cache — *Sub-Agent UI/UX Designer* `(1 SP)` — *BA & PO Đã Ký Duyệt*
- [x] `TSK-MIC-02` [Gate 2]: Thiết kế UI Chips vi chất, thanh đo và cảnh báo vượt ngưỡng — *Sub-Agent UI/UX Designer* `(1 SP)` — *BA & PO Đã Ký Duyệt*
- [x] `TSK-MUL-03` [Gate 3]: Thiết kế Manual Testcases & kịch bản BDD Gherkin cho nhận diện nhiều món — *Sub-Agent QA* `(2 SP)` — *QA & PM Đã Ký Duyệt*
- [x] `TSK-OFF-03` [Gate 3]: Thiết kế Manual Testcases & kịch bản BDD cho tình huống mất mạng đột ngột — *Sub-Agent QA* `(1 SP)` — *QA & PM Đã Ký Duyệt*
- [x] `TSK-MIC-03` [Gate 3]: Thiết kế Manual Testcases & kịch bản BDD cho vi chất và ngưỡng khuyến nghị — *Sub-Agent QA* `(1 SP)` — *QA & PM Đã Ký Duyệt*
- [x] `TSK-MUL-04` [Gate 4]: Mở rộng Prompt Gemini 2.0 Flash Vision & UI hiển thị đa món — *Sub-Agent Dev FE* `(4 SP)` — *Dev FE Hoàn tất (110 Tests Pass)*
- [x] `TSK-OFF-04` [Gate 4]: Triển khai Local Cache Food Log & Background Sync Notifier — *Sub-Agent Dev FE* `(3 SP)` — *Dev FE Hoàn tất (110 Tests Pass)*
- [x] `TSK-MIC-04` [Gate 4]: Mở rộng Freezed Entity & UI Chips Vi chất trên màn hình Food Log — *Sub-Agent Dev FE* `(1 SP)` — *Dev FE Hoàn tất (110 Tests Pass)*

---

## 📊 Chỉ Số Tiến Độ Sprint 02 (Sprint Metrics)

```
Story Points Phân Bổ:
[██████████████████████] 24 / 24 SP (24 SP Done Gate 1..6)
- 🟢 Đã hoàn tất Gate 1, 2, 3, 4, 5, 6 (Done):    24/24 SP (100% test & review)
- ⚡ Sẵn sàng Gate 7 Release (In Progress):         2 SP
- 📝 Hàng đợi backlog (Todo):                       0 SP
```

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 01 — AstroBite v1.0.0 MVP Release (Hoàn tất 18/09/2026)
- **Mục tiêu**: Hoàn tất kiểm thử, rà soát Ponytail và ký nghiệm thu Gate 5 cho Analytics & Profile, đóng gói v1.0.0.
- **Kết quả**: **13 / 13 SP (100% Passed)**, 94/94 tests tự động passed, 0 lỗi static analysis.
- **Git Tag**: [`v1.0.0`](file:///Users/nguyenduytrang/flutter_project/AstroBite)
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.0.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.0.0.md)
