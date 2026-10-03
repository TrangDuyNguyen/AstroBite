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
- **Hiển thị**: Có một tab (hoặc trang) "Cộng Đồng" hiển thị Bảng Xếp Hạng Bạn Bè.
- **Cơ chế điểm**: Dựa vào `Cosmic Streak` (chuỗi ngày ăn đủ mục tiêu Calo +- 100).
- **Kiến trúc**: Dữ liệu lấy từ file tĩnh do Cloud Functions tạo ra (cập nhật 1 giờ 1 lần) để tiết kiệm Read.

### 3.3. Tìm & Thêm Bạn
- **Cách thức**: Nhập "Astro ID" (một chuỗi 6 ký tự) để gửi lời mời.

## 4. Ràng Buộc (Out-of-Scope)
- KHÔNG làm bảng xếp hạng toàn cầu (Global Leaderboard) để tránh rủi ro bảo mật PII.
- KHÔNG làm tính năng Chat nội bộ.

---
> Chữ ký PO: Đã duyệt PRD. Rõ ràng, đo lường được, không ngốn tài nguyên vô ích.
