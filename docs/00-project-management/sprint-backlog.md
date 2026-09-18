# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: `Sprint 02`
- **Phiên bản mục tiêu**: `v1.1.0` (Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline)
- **Thời gian chu kỳ**: 2026-10-03 đến 2026-10-17 (Chu kỳ 2 tuần)
- **Mục tiêu Sprint (Sprint Goal)**: Nâng cấp năng lực Gemini Vision AI nhận diện đồng thời nhiều món ăn trên một mâm (`EPIC-06`), kiến tạo bộ nhớ đệm Offline-First Resilience tự đồng bộ Cloud Firestore (`EPIC-09`), và mở rộng theo dõi vi chất dinh dưỡng (`EPIC-08`), bảo đảm tiêu chuẩn 6 Cổng Chất Lượng.
- **Tổng Story Points cam kết (Target Capacity)**: **16 SP**
- **Trạng thái Sprint**: 🟡 **Khởi động Sprint 02 — Chuyển giao Gate 1 cho Sub-Agent BA**

---

## 📋 Bảng Kanban Trực Quan Sprint 02 (v1.1.0)

### 1. 📝 TODO (Chờ phân tích PRD Gate 1 & Thiết kế Test Gate 2) — [16 SP]
- [ ] `TSK-MUL-01` [Gate 1]: Soạn thảo PRD & User Stories BDD cho Multi-Item Food Scanner AI (`FEAT-06`) — *Sub-Agent BA* `(2 SP)`
- [ ] `TSK-OFF-01` [Gate 1]: Soạn thảo PRD & User Stories BDD cho Offline-First Local Cache & Sync (`FEAT-07`) — *Sub-Agent BA* `(1 SP)`
- [ ] `TSK-MIC-01` [Gate 1]: Soạn thảo PRD & User Stories BDD cho Micronutrients Tracking (`FEAT-08`) — *Sub-Agent BA* `(1 SP)`
- [ ] `TSK-MUL-02` [Gate 2]: Thiết kế Manual Testcases & kịch bản BDD Gherkin cho nhận diện nhiều món — *Sub-Agent QA* `(2 SP)`
- [ ] `TSK-OFF-02` [Gate 2]: Thiết kế Manual Testcases & kịch bản BDD cho tình huống mất mạng đột ngột — *Sub-Agent QA* `(1 SP)`
- [ ] `TSK-MIC-02` [Gate 2]: Thiết kế Manual Testcases & kịch bản BDD cho vi chất và ngưỡng khuyến nghị — *Sub-Agent QA* `(1 SP)`
- [ ] `TSK-MUL-03` [Gate 3]: Mở rộng Prompt Gemini 2.0 Flash Vision & UI hiển thị đa món — *Sub-Agent Dev FE* `(4 SP)`
- [ ] `TSK-OFF-03` [Gate 3]: Triển khai Local Hive/Cache Food Log & Background Sync Notifier — *Sub-Agent Dev FE* `(3 SP)`
- [ ] `TSK-MIC-03` [Gate 3]: Mở rộng Freezed Entity & UI Chips Vi chất trên màn hình Food Log — *Sub-Agent Dev FE* `(1 SP)`

### 2. ⚡ IN PROGRESS — [0 SP]
*(Chờ Sub-Agent BA nhận bàn giao để triển khai Gate 1)*

### 3. 🔍 IN REVIEW & VERIFY — [0 SP]
*(Chờ các Gate 4 & 5)*

### 4. 🏁 DONE — [0 SP]
*(Sprint 02 mới khởi tạo)*

---

## 📊 Chỉ Số Tiến Độ Sprint 02 (Sprint Metrics)

```
Story Points Phân Bổ:
[░░░░░░░░░░░░░░░░░░░░] 0 / 16 SP Hoàn Thành
- Chưa thực hiện (Todo): 16/16 SP (100%)
- Đang triển khai (In Progress): 0/16 SP (0%)
- Đang kiểm thử (In Verify): 0/16 SP (0%)
- Đã hoàn thành (Done): 0/16 SP (0%)
```

---

## 🏛️ Lịch Sử Các Sprint Đã Hoàn Thành (Sprint Archive)

### 🟢 Sprint 01 — AstroBite v1.0.0 MVP Release (Hoàn tất 18/09/2026)
- **Mục tiêu**: Hoàn tất kiểm thử, rà soát Ponytail và ký nghiệm thu Gate 5 cho Analytics & Profile, đóng gói v1.0.0.
- **Kết quả**: **13 / 13 SP (100% Passed)**, 94/94 tests tự động passed, 0 lỗi static analysis.
- **Git Tag**: [`v1.0.0`](file:///Users/nguyenduytrang/flutter_project/AstroBite)
- **Biên bản phát hành**: [`docs/05-change-management/release-v1.0.0.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/05-change-management/release-v1.0.0.md)
