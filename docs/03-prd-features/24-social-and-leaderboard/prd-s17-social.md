# PRD: Sprint 17 - Social Accountability & Leaderboard

- **Mã Epic**: `EPIC-COMMUNITY`
- **Mã Feature**: `FEAT-S17-SOCIAL`
- **Người soạn thảo**: Sub-Agent Business Analyst (BA)
- **Reviewer**: Sub-Agent PO (Gate 1 Sign-Off)
- **Trạng thái**: 🟢 Approved

## 1. Tổng Quan
Tính năng giúp người dùng AstroBite tăng cường kỷ luật ăn uống thông qua **Leaderboard (Bảng Xếp Hạng Bạn Bè)** và cho phép họ khoe thành tích **Daily Goal** lên mạng xã hội dưới dạng thẻ Claymorphic (Image Share).

## 2. Số Đo Lường Thành Công (Metrics)
- **K1 (Viral Coefficient)**: Tỷ lệ người dùng chia sẻ thẻ thành tích lên MXH tăng lên 5%/tuần.
- **K2 (Retention D30)**: Nhóm user có >= 3 bạn bè trong Leaderboard có tỷ lệ D30 Retention cao hơn 20% so với nhóm cô đơn.

## 3. Tính Năng Cốt Lõi (In-Scope)

### 3.1. Thẻ Khoe Thành Tích (Social Share Card)
- **Kích hoạt**: Tại màn hình `AnalyticsPage` hoặc `GoalSummaryPage`, có nút **"Share"** (Nút icon chia sẻ).
- **Trải nghiệm**: Bấm vào nút Share -> UI sẽ render ngay lập tức thẻ báo cáo (ClayCard) kèm logo AstroBite, số Calo đạt được, và Streak của người dùng thành ảnh chất lượng cao.
- **Tương tác**: Kéo Native Dialog của OS lên để người dùng chọn Facebook/Instagram Stories.

### 3.2. Astro Leaderboard
- **Hiển thị**: Có một modal / trang hiển thị Bảng Xếp Hạng Bạn Bè (truy cập từ Cúp Vàng trên AppBar hoặc Streak sheet).
- **Cơ chế điểm**: Dựa vào `Cosmic Streak` (chuỗi ngày ăn đủ mục tiêu Calo +- 100).
- **Phân kỳ phát triển (Phasing)**:
  - **Phase 1 (v2.7.0 — Đang chạy)**: Client in-memory state & mock list (`LeaderboardPage`) để kiểm chứng độ hài lòng và tương tác UX của người dùng.
  - **Phase 2 (v2.8.0 — Planned)**: Kết nối Firestore Stream tĩnh `leaderboard/weekly_top_100` được tính toán định kỳ qua Cloud Functions.

### 3.3. Tìm & Thêm Bạn
- **Cách thức**: Nhập "Astro ID" (chuỗi mã Astro định danh) để kết bạn.
- **Phân kỳ**:
  - **Phase 1 (v2.7.0)**: Thêm tức thì vào bộ nhớ đệm client + Toast thông báo.
  - **Phase 2 (v2.8.0)**: Gọi Cloud Function Callable `social_addFriend` để ghi nhận quan hệ bạn bè trên Firestore backend.

## 4. Ràng Buộc (Out-of-Scope)
- KHÔNG làm bảng xếp hạng toàn cầu (Global Leaderboard) để tránh rủi ro bảo mật PII.
- KHÔNG làm tính năng Chat nội bộ.

---
> **Chữ ký PO**: Đã duyệt PRD. Chấp thuận phân kỳ Phase 1 (UI/UX Mock & Native Share) cho v2.7.0 và Phase 2 (Backend Cloud Sync) cho v2.8.0.

