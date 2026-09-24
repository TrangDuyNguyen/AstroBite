# PRD — AstroCoach Conversation History & Multi-Session Review

- **Feature**: `FEAT-16-EXT` / `EPIC-18`
- **Sub-Agent**: Business Analyst (`business-analyst`) — *"The Pedantic Logician"*
- **Status**: **GATE 1 APPROVED**

---

## 1. User Stories & Acceptance Criteria (BDD Given-When-Then)

### US-H01: Mở Khay Danh Sách Lịch Sử Hội Thoại
- **Given**: Người dùng đang ở màn hình AstroCoach.
- **When**: Người dùng nhấn vào biểu tượng Lịch sử (`Icons.history_rounded`) trên AppBar.
- **Then**: Hệ thống mở `CelestialHistoryBottomSheet` hiển thị danh sách các ngày trò chuyện đã qua sắp xếp giảm dần theo thời gian.
- **And**: Mỗi thẻ hiển thị Ngày (định dạng thân thiện: "Hôm nay", "Hôm qua", hoặc "dd/MM/yyyy"), số lượng tin nhắn, và trích đoạn câu hỏi/trả lời gần nhất.

### US-H02: Tải & Xem Lại Cuộc Hội Thoại Cũ
- **Given**: Khay lịch sử đang hiển thị danh sách các phiên.
- **When**: Người dùng chọn một phiên ngày trong quá khứ (ví dụ: "2026-09-22").
- **Then**: Khay lịch sử tự động đóng, màn hình chat tải toàn bộ danh sách tin nhắn của ngày đã chọn.
- **And**: Một banner thông báo xuất hiện phía trên: `"📅 Đang xem lại phiên ngày 22/09/2026 • [Quay lại Hôm nay]"`.

### US-H03: Trở Lại Phiên Trò Chuyện Trực Tiếp Của Ngày Hôm Nay
- **Given**: Người dùng đang ở chế độ xem lại phiên cũ.
- **When**: Người dùng nhấn vào nút `[Quay lại Hôm nay]` trên banner hoặc chọn lại ngày hôm nay trong khay lịch sử.
- **Then**: Màn hình lập tức tải lại phiên chat của ngày hôm nay, ẩn banner lịch sử và mở lại khung chat để người dùng tiếp tục trò chuyện.
