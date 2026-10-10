# Kịch Bản Nghiệp Vụ BDD (User Stories) — Sprint 26

### Epic: Gamification, Guilds & Social Modular Clean Architecture

#### Story 1: Xem chi tiết phân tích chuỗi ngày & khiên bảo vệ
- **Given** người dùng đang ở màn hình có hiển thị ngọn lửa Streak
- **When** người dùng chạm vào biểu tượng Streak
- **Then** modal `StreakDetailSheet` xuất hiện với thẻ 3 cột số liệu, banner khiên tinh tú 3D và lưới 4 huy hiệu vũ trụ
- **And** người dùng chạm vào một huy hiệu thì dialog chi tiết điều kiện mở khóa hiển thị rõ ràng.

#### Story 2: Quản trị thông tin và rời/giải tán bang hội
- **Given** người dùng là Bang Chủ của một bang hội
- **When** người dùng mở màn hình `GuildPage` và chạm vào nút Cài đặt Bang hội
- **Then** modal `GuildGovernanceSheet` xuất hiện với các quyền chỉnh sửa thông tin, sao chép mã mời và giải tán bang hội
- **And** nếu người dùng bấm giải tán bang hội, hệ thống yêu cầu xác nhận trước khi thực thi.

#### Story 3: Nhắc nhở cứu streak bạn bè trên Bảng Xếp Hạng
- **Given** người dùng mở màn hình `LeaderboardPage`
- **When** nhìn thấy một người bạn chưa đạt chuẩn ăn uống hôm nay
- **Then** người dùng chạm vào nút "Nhắc ⚡"
- **And** modal `LeaderboardNudgeSheet` hiển thị xác nhận gửi tín hiệu nhắc nhở cứu streak trước khi gửi.
