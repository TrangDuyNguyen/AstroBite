# Product Requirement Document (PRD) — Gate 1 Sign-Off
## Sprint 26: Gamification, Guilds & Social Modular Architecture (v3.6.0)

- **Mã tính năng**: `PRD-S26-GAMIFICATION-GUILDS-SOCIAL`
- **Chủ trì nghiệp vụ**: Sub-Agent BA (`business-analyst` — *The Pedantic Logician*)
- **Phê duyệt nghiệp vụ**: Sub-Agent PO (`product-owner` — *The Strategic Tyrant*)
- **Phê duyệt khả thi**: Sub-Agent Tech Lead (`tech-lead` — *The Pragmatic System Architect*)
- **Ngày phê duyệt**: 2026-10-10
- **Trạng thái**: 🟢 **GATE 1 APPROVED — ZERO SCOPE CREEP**

---

### 1. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (Metrics & ROI)

1. **D30 Retention Booster**: Phân hệ Gamification (Streak, Shields, Badges) và Social (Guilds, Leaderboard, Nudge) là xương sống duy trì thói quen ăn uống lành mạnh của người dùng.
2. **Kỹ thuật sạch (Code Quality & Maintainability)**: Loại bỏ vĩnh viễn file dài nhất codebase (`streak_detail_sheet.dart` 796L) cùng với `guild_page.dart` (718L) và `leaderboard_page.dart` (655L), đưa tất cả về $< 200$ dòng.
3. **Hiệu năng UI (Non-functional SLA)**: 60 FPS mượt mà cho tất cả các modal sheet và dialog animation.

---

### 2. Danh Mục Yêu Cầu Chức Năng (Functional Requirements)

#### FR-01: Streak Detail Analytics Modal
- **FR-01.1**: Hiển thị thẻ 3 cột số liệu (Chuỗi hiện tại, Kỷ lục dài nhất, Khiên tinh tú) với các icon 3D và thẻ trạng thái.
- **FR-01.2**: Hiển thị banner bảo vệ Khiên tinh tú với thanh tiến trình tích lũy 7 ngày chuỗi.
- **FR-01.3**: Hiển thị lưới 2x2 huy hiệu vũ trụ, khi bấm vào từng huy hiệu mở dialog chi tiết giải thích điều kiện đạt được.
- **FR-01.4**: Các nút CTA điều hướng sang Bảng Xếp Hạng hoặc tiếp tục kỷ luật.

#### FR-02: Bang Hội Vũ Trụ (Cosmic Guilds)
- **FR-02.1**: Trạng thái Empty: Hiển thị minh họa và nút tạo bang hội mới hoặc nhập mã mời của bạn bè.
- **FR-02.2**: Trạng thái Active: Hiển thị thẻ thông tin bang hội (avatar hành tinh, tên, mô tả, số lượng thành viên, nút copy mã mời, nút cài đặt bang hội).
- **FR-02.3**: Danh sách đóng góp thành viên và tương tác Nudge / Phân quyền.
- **FR-02.4**: Quản trị bang hội: Modal quản trị, dialog giải tán bang (Disband) và rời bang (Leave).

#### FR-03: Bảng Xếp Hạng & Cứu Streak (Social Leaderboard & Nudge)
- **FR-03.1**: Thẻ hiển thị Astro ID cá nhân với tính năng sao chép 1 chạm vào clipboard.
- **FR-03.2**: Danh sách thành viên thử thách hiển thị huy hiệu thứ hạng (👑, 🥈, 🥉), ngọn lửa chuỗi ngày và trạng thái hoàn thành.
- **FR-03.3**: Tương tác Nudge: Modal xác nhận gửi tín hiệu nhắc nhở cứu streak bạn bè khi bạn bè chưa log ăn uống.
- **FR-03.4**: Modal kết nối bạn bè bằng cách nhập mã Astro ID.
