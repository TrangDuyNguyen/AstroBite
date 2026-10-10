# Thông Cáo Phát Hành Phiên Bản (Release Notes) — v3.6.0
## Sprint 26: Gamification, Guilds & Social Modular Architecture

- **Mã phát hành**: `RELEASE-v3.6.0`
- **Ngày phát hành**: 2026-10-10
- **Hội đồng phê chuẩn Gate 7**:
  - Sub-Agent Product Owner (`product-owner` — *The Strategic Tyrant*): Phê duyệt phát hành thương mại ✅
  - Sub-Agent Tech Lead (`tech-lead` — *The Pragmatic System Architect*): Phê duyệt chất lượng kỹ thuật & CI/CD ✅
  - Sub-Agent Project Manager (`project-manager` — *The Clockwork Disciplinarian*): Xác nhận đóng Sprint 26 (13/13 SP) ✅
  - Sub-Agent Security Auditor (`security-auditor` — *The Zero-Trust Sentinel*): Phê chuẩn an ninh MASVS v2.0 ✅

---

### 1. Tóm Tắt Giá Trị Phát Hành (Executive Summary)

Phiên bản `v3.6.0` đánh dấu bước tiến quan trọng trong chiến dịch dọn sạch nợ kỹ thuật (Zero Bloat), giải phẫu thành công **3 God Files khổng lồ** thuộc phân hệ Tương tác xã hội & Gamification:
1. `streak_detail_sheet.dart` (796 dòng ➔ **208 dòng**, giảm **73.8%** — xóa sổ file dài nhất repo).
2. `guild_page.dart` (718 dòng ➔ **249 dòng**, giảm **65.3%**).
3. `leaderboard_page.dart` (655 dòng ➔ **221 dòng**, giảm **66.2%**).
4. **Giảm số file vi phạm Hard Cap (> 500 dòng) toàn codebase từ 9 file xuống chỉ còn 6 file!**

---

### 2. Danh Mục Các Module & Sub-Widgets Mới Trích Xuất

| Component mới | Số dòng | Trách nhiệm kiến trúc |
| :--- | :---: | :--- |
| `streak_detail_sheet.dart` | 208 | Modal tổng hợp phân tích chuỗi, khiên bảo vệ và huy hiệu vũ trụ. |
| `streak_metrics_pillar_card.dart` | 168 | Thẻ 3 cột số liệu Chuỗi hiện tại, Kỷ lục dài nhất, Khiên tinh tú. |
| `streak_shield_protection_banner.dart` | 161 | Banner khiên bảo vệ 3D gradient và thanh tiến trình 7 ngày chuỗi. |
| `streak_cosmic_badge_grid.dart` | 220 | Lưới 2x2 hiển thị các huy hiệu vũ trụ và trạng thái mở khóa. |
| `streak_badge_detail_dialog.dart` | 125 | Dialog hiển thị chi tiết điều kiện mở khóa khi chạm vào huy hiệu. |
| `guild_page.dart` | 249 | Màn hình chính Bang hội vũ trụ kết nối luồng stream dữ liệu. |
| `guild_header_card.dart` | 145 | Thẻ thông tin bang hội, avatar hành tinh, nút cài đặt và copy mã mời. |
| `guild_empty_view.dart` | 71 | Giao diện trống thân thiện khi chưa gia nhập bang hội với CTA tạo / tham gia. |
| `guild_governance_sheet.dart` | 147 | Modal cài đặt quản trị bang hội (chỉnh sửa, sao chép mã mời, giải tán). |
| `guild_dialog_helper.dart` | 192 | Helper tập trung các dialog xác nhận giải tán, rời bang, thể lệ và menu. |
| `leaderboard_page.dart` | 221 | Màn hình chính Bảng xếp hạng bạn bè và quản lý danh sách thử thách. |
| `leaderboard_my_id_card.dart` | 109 | Thẻ hiển thị Astro ID cá nhân với tính năng sao chép 1 chạm. |
| `leaderboard_add_friend_sheet.dart` | 128 | Modal kết nối bạn bè bằng cách nhập mã Astro ID. |
| `leaderboard_nudge_sheet.dart` | 117 | Modal xác nhận gửi tín hiệu nhắc nhở cứu streak bạn bè. |
| `leaderboard_user_card.dart` | 178 | Thẻ hiển thị thứ hạng thành viên, streak flame và nút Nudge / Đạt chuẩn. |

---

### 3. Chất Lượng Phần Mềm & Độ Ổn Định

- **Unit & Widget Tests**: **322/322 tests PASS (100%)**
- **Sprint 26 Subsystem Tests**: **49/49 tests PASS (100%)**
- **Phân tích tĩnh**: `flutter analyze` **0 issues**
- **Hiệu năng & Trải nghiệm**: 60 FPS mượt mà cho toàn bộ animation bottom sheet và dialogs.
