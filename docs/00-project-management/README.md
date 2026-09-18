# Quản Trị Dự Án & Điều Phối Thực Thi (Project Management Governance)

> Thư mục này do **Sub-Agent Project Manager (PM) / Scrum Master** trực tiếp quản lý và vận hành. Đây là trung tâm điều phối nhịp độ giao hàng, phân rã công việc WBS qua 6 Cổng, kiểm soát dung lượng Sprint theo Story Points và ghi vết điểm nghẽn kỹ thuật.

---

## 📁 Cấu Trúc Tài Liệu Trong Thư Mục

1. **[`sprint-backlog.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/00-project-management/sprint-backlog.md)**:
   - Kế hoạch và bảng Kanban của Sprint hiện hành.
   - Xác định rõ **Sprint Goal**, tổng Story Points cam kết, và trạng thái từng đầu việc theo 4 cột (`Todo`, `In Progress`, `Review/Verify`, `Done`).

2. **[`wbs-task-matrix.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/00-project-management/wbs-task-matrix.md)**:
   - Bảng phân rã cấu trúc công việc (**Work Breakdown Structure**) ánh xạ trực tiếp vào quy trình 6 Cổng Chất Lượng.
   - Gán đích danh Sub-Agent chịu trách nhiệm (RACI) và chấm điểm Story Points Fibonacci (`1, 2, 3, 5, 8`).

3. **[`risk-blocker-log.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/00-project-management/risk-blocker-log.md)**:
   - Nhật ký theo dõi rủi ro và các điểm nghẽn kỹ thuật (Blockers).
   - Đưa ra cảnh báo sớm và kế hoạch tháo gỡ cho các Sub-Agents.

---

## 🧭 Kỷ Luật Điều Phối Của Sub-Agent PM
- **Nguyên tắc phân rã**: Bất kỳ task nào có độ phức tạp ước lượng `>= 13 SP` đều bị PM từ chối đưa vào Sprint và yêu cầu chia nhỏ `<= 8 SP`.
- **Nguyên tắc không tự duyệt**: PM không thay thế vai trò của Tester hay Reviewer. Mọi task chỉ được chuyển sang cột `Done` khi đã có xác nhận hợp lệ từ Gate tương ứng:
  - Gate 1: PO ký duyệt PRD.
  - Gate 3: FE Dev hoàn thành `flutter analyze` 0 lỗi.
  - Gate 4: Code Reviewer xác nhận `Lean already. Ship.`.
  - Gate 5: QA ký duyệt `signoff-<feature>.md`.
  - Gate 6: PO ký duyệt Release.
