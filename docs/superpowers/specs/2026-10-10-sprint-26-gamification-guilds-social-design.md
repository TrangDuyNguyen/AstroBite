# Architectural Decision Record (ADR-032) & System Design Spec
## Sprint 26: Gamification, Guilds & Social Modular Architecture (v3.6.0)

- **Trạng thái**: 🟢 **APPROVED** (Sub-Agent Tech Lead & System Architect Sign-Off)
- **Mã Epic / Feature**: `EPIC-REF-05` / `FEAT-S26-GAMIFICATION-GUILDS-SOCIAL`
- **Quy mô cam kết**: **13 Story Points**
- **Mục tiêu chính**: Giải phẫu 3 "God Files" lớn nhất phân hệ Tương tác xã hội & Gamification:
  1. `lib/features/gamification/presentation/widgets/streak_detail_sheet.dart` (796 dòng ➔ $< 160$ dòng)
  2. `lib/features/guilds/presentation/pages/guild_page.dart` (718 dòng ➔ $< 200$ dòng)
  3. `lib/features/social/presentation/pages/leaderboard_page.dart` (655 dòng ➔ $< 160$ dòng)

---

### 1. Bối Cảnh & Vấn Đề Kỹ Thuật (Context & Problem Statement)

1. **`streak_detail_sheet.dart` (796 dòng)**: File dài nhất toàn bộ repository hiện tại. Ôm đồm 3-pillar metrics card, starlight shield calculation, badge grid layout 2x2, badge detail modal dialog và celestial styling.
2. **`guild_page.dart` (718 dòng)**: Trộn lẫn giao diện Empty State, Guild Header, Bảng xếp hạng đóng góp, Modal quản trị bang hội (Governance), Dialog giải tán bang (Disband), Dialog rời bang (Leave), Thể lệ thử thách (Rules) và Menu tùy chọn tạo/gia nhập.
3. **`leaderboard_page.dart` (655 dòng)**: Trộn lẫn thẻ hiển thị Astro ID của tôi, Dialog kết nối bạn bè, Bottom sheet xác nhận Nudge (Cứu Streak), Card thành viên BXH và danh sách người dùng.

---

### 2. Thiết Kế Module Bóc Tách (Decomposition Blueprint)

#### Phân hệ Gamification (`lib/features/gamification/presentation/widgets/`):
- `streak_metrics_pillar_card.dart` (~100 dòng): Card 3 cột hiển thị Chuỗi hiện tại, Kỷ lục dài nhất, Khiên tinh tú.
- `streak_shield_protection_banner.dart` (~130 dòng): Banner Khiên tinh tú 3D gradient và thanh tiến trình 7 ngày chuỗi.
- `streak_cosmic_badge_grid.dart` (~150 dòng): Lưới huy hiệu 2x2, tile avatar disc, và logic kích hoạt chi tiết.
- `streak_badge_detail_dialog.dart` (~90 dòng): Dialog hiển thị chi tiết huy hiệu khi người dùng chạm vào.
- `streak_detail_sheet.dart` (< 160 dòng): Modal chính làm nhiệm vụ composition và điều phối.

#### Phân hệ Guilds (`lib/features/guilds/presentation/`):
- `widgets/guild_header_card.dart` (~130 dòng): Card thông tin bang hội, avatar hành tinh, nút cài đặt và copy invite code.
- `widgets/guild_empty_view.dart` (~80 dòng): Giao diện trống khi chưa tham gia bang hội với CTA tạo / gia nhập.
- `widgets/guild_governance_sheet.dart` (~140 dòng): Modal cài đặt quản trị bang hội (đổi thông tin, sao chép mã, giải tán).
- `widgets/guild_dialog_helper.dart` (~110 dòng): Dialog xác nhận rời bang, giải tán bang, thể lệ thử thách và menu tạo/gia nhập.
- `pages/guild_page.dart` (< 200 dòng): Màn hình chính điều phối stream và hiển thị trạng thái bang hội.

#### Phân hệ Social (`lib/features/social/presentation/`):
- `widgets/leaderboard_user_card.dart` (~150 dòng): Thẻ thành viên BXH, rank badge (👑, 🥈, 🥉), streak flame, nút Nudge / Đạt chuẩn.
- `widgets/leaderboard_my_id_card.dart` (~90 dòng): Thẻ hiển thị Astro ID của tôi kèm tính năng sao chép clipboard.
- `widgets/leaderboard_add_friend_sheet.dart` (~100 dòng): Modal kết nối bạn bè bằng Astro ID.
- `widgets/leaderboard_nudge_sheet.dart` (~95 dòng): Modal xác nhận gửi tín hiệu nhắc nhở cứu streak bạn bè.
- `pages/leaderboard_page.dart` (< 160 dòng): Màn hình chính điều phối stream BXH và các tương tác xã hội.

---

### 3. Nguyên Tắc Ponytail & Tuân Thủ Clean Code

- **Zero Tolerance Bloat**: Tuyệt đối không thêm abstraction hay package bên thứ ba nào. Tái sử dụng `ui_kit.dart` (`ClayCard`, `ClayButton`, `ClayAppBar`, `Clay3DPlanet`, `Clay3DShield`).
- **File Length Constraint**: Không có bất kỳ file nào sau khi bóc tách vượt quá 350 dòng. Màn hình chính phải $< 200$ dòng.
- **Regression Zero**: 100% tests hiện tại (322 tests) phải giữ nguyên kết quả PASS xanh.
