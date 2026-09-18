# Kế Hoạch Sprint Hiện Hành (Sprint Backlog)

- **Quản lý bởi**: Sub-Agent Project Manager (PM)
- **Sprint hiện tại**: `Sprint 01`
- **Mục tiêu Sprint (Sprint Goal)**: Hoàn tất kiểm thử, rà soát Ponytail và ký biên bản nghiệm thu Gate 5 cho `FEAT-04` (Analytics & Trends) và `FEAT-05` (User Profile & Goals), chuẩn bị đầy đủ điều kiện để Sub-Agent PO ký duyệt phát hành AstroBite v1.0.0.
- **Thời gian chu kỳ**: 2026-09-18 đến 2026-10-02 (Chu kỳ 2 tuần)
- **Tổng Story Points cam kết**: **13 SP**
- **Trạng thái Sprint**: 🟢 Đang triển khai tích cực

---

## 📋 Bảng Kanban Trực Quan Sprint 01

### 1. 📝 TODO (Chờ xử lý) — [3 SP]
- [ ] `TSK-REL-01` [Gate 6]: Chuẩn bị hồ sơ Release v1.0.0 (Release notes, Git submodule sync, Tag v1.0.0) — *Sub-Agent PM & PO* `(3 SP)`

### 2. ⚡ IN PROGRESS (Đang triển khai) — [5 SP]
- [/] `TSK-ANA-01` [Gate 4]: Rà soát Ponytail cho mô-đun Analytics (`lib/features/analytics/`), tối ưu render FL Chart — *Sub-Agent Reviewer & Dev FE* `(2 SP)`
- [/] `TSK-PRO-01` [Gate 4]: Rà soát Ponytail cho mô-đun Profile & BMR/TDEE calculation (`lib/features/profile/`) — *Sub-Agent Reviewer & Dev FE* `(3 SP)`

### 3. 🔍 IN REVIEW & VERIFY (Đang kiểm thử Gate 5) — [5 SP]
- [?] `TSK-ANA-02` [Gate 5]: Viết Widget & Unit tests cho biểu đồ Analytics, xác thực FPS >= 55 và lập `signoff-analytics.md` — *Sub-Agent QA* `(3 SP)`
- [?] `TSK-PRO-02` [Gate 5]: Thực thi bộ testcases tính toán dinh dưỡng Profile, xác thực BDD và lập `signoff-profile.md` — *Sub-Agent QA* `(2 SP)`

### 4. 🏁 DONE (Đã hoàn thành & Nghiệm thu) — [Đã bàn giao các Sprint trước]
- [x] `TSK-AUT-00` [Gate 6]: Hoàn tất và ký duyệt nghiệm thu `FEAT-01` Auth & Onboarding (`signoff-auth-login.md`) — *PO Approved*
- [x] `TSK-SCN-00` [Gate 6]: Hoàn tất và ký duyệt nghiệm thu `FEAT-02` Gemini Food Scanner AI (`signoff-food-scanner.md`) — *PO Approved*
- [x] `TSK-TRK-00` [Gate 6]: Hoàn tất và ký duyệt nghiệm thu `FEAT-03` Diary & Manual Food Entry (`signoff-manual-entry.md` - 86 tests pass) — *PO Approved*

---

## 📊 Chỉ Số Tiến Độ Sprint (Sprint Metrics)

```
Story Points Phân Bổ:
[██████████░░░░░░░░░░] 5 / 13 SP Đang trong quá trình Verify (Gate 4/5)
- Đã hoàn thành (Done): 0/13 SP (Trong phạm vi Sprint 01)
- Đang kiểm thử (In Verify): 5/13 SP (38.5%)
- Đang rà soát (In Progress): 5/13 SP (38.5%)
- Chưa bắt đầu (Todo): 3/13 SP (23.0%)
```

* **Đánh giá của Sub-Agent PM**: Tiến độ khả quan. Cả hai mô-đun `analytics` và `profile` đã có sẵn mã nguồn giao diện và xử lý dữ liệu, chỉ cần hoàn thiện kiểm thử tự động Gate 5 và cắt tỉa over-engineering ở Gate 4 là có thể đóng gói Release v1.0.0.
