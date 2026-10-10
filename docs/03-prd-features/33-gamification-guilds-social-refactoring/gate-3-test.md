# Kế Hoạch Kiểm Thử Hồi Quy (Test Plan) — Gate 3 Sign-Off
## Sprint 26: Gamification, Guilds & Social Modular Architecture

- **Chủ trì kiểm thử**: Sub-Agent QA Tester (`qa-tester` — *The Paranoid Inquisitor*)
- **Phê duyệt**: Sub-Agent Tech Lead & Reviewer
- **Ngày ký duyệt**: 2026-10-10
- **Trạng thái**: 🧪 **GATE 3 APPROVED — ZERO DU DI**

---

### 1. Ma Trận Test Cases Bắt Buộc

| Mã TC | Phân hệ kiểm thử | Kịch bản chi tiết | Tiêu chuẩn pass |
| :--- | :--- | :--- | :--- |
| **TC-S26-01** | `StreakDetailSheet` | Hiển thị 3 số liệu: Chuỗi, Kỷ lục, Khiên với đúng giá trị từ entity `StreakRecord`. | Thẻ metric hiển thị đúng giá trị, semantic icon '🔥', '⭐', '🛡️' hiện diện. |
| **TC-S26-02** | `StreakDetailSheet` | Chạm vào từng Cosmic Badge mở dialog chi tiết giải thích điều kiện ngày chuỗi. | Dialog hiện thông tin badge, nút "Đã Hiểu" đóng dialog. |
| **TC-S26-03** | `GuildPage` | Trạng thái Empty hiển thị 2 nút Tạo bang hội và Nhập mã mời. | Finder tìm thấy đúng 2 nút `create_guild_button` và `join_guild_button`. |
| **TC-S26-04** | `GuildPage` | Trạng thái Active hiển thị tên bang hội, mã mời, avatar hành tinh và danh sách thành viên. | Finder tìm thấy các component và render mượt mà. |
| **TC-S26-05** | `LeaderboardPage` | Hiển thị thẻ My Astro ID, danh sách bạn bè với rank 👑, 🥈, 🥉 và nút Nhắc ⚡. | Copy clipboard hoạt động, tap Nhắc mở nudge sheet. |

---

### 2. Kiểm Tra Chặn Cứng Mã Nguồn
- **`flutter analyze`**: 0 errors, 0 warnings.
- **`check_file_length.sh`**: Cả 3 file chính `streak_detail_sheet.dart`, `guild_page.dart`, `leaderboard_page.dart` phải $< 200$ dòng.
- **`flutter test`**: Toàn bộ 322 tests hiện tại tiếp tục PASS 100%.
