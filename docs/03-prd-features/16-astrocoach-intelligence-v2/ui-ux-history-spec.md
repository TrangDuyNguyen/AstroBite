# UI/UX Design Specification — AstroCoach Conversation History

- **Feature**: `FEAT-16-EXT` / `EPIC-18`
- **Sub-Agent**: UI/UX Designer (`ui-ux-designer`) — *"The Celestial Aesthetic Purist"*
- **Design System**: Celestial Dark UI

---

## 1. Screen Layout Blueprint

### AppBar Action Button
- Nút tròn `IconButton` (44x44pt touch target) chứa biểu tượng `Icons.history_rounded` màu `AppColors.onSurface`.

### Celestial History Bottom Sheet
- Bề mặt: `AppColors.surfaceContainer` (`#112240`) với viền mờ `glass-border` (`rgba(255, 255, 255, 0.08)`), bán kính bo cong 20pt.
- Header:
  - Icon `Icons.history_rounded` phát sáng xanh Electric (`#1A73E8`).
  - Tiêu đề `Lịch sử hội thoại AstroCoach`.
  - Nút đóng `IconButton(icon: Icon(Icons.close_rounded))`.
- Danh sách Session Card:
  - Thẻ Container: `AppColors.surface` (`#0A192F`), viền 1px mờ.
  - Hàng trên: Ngày ("Hôm nay, 24/09" hoặc "22/09/2026") + Capsule badge số tin nhắn (`8 tin nhắn`).
  - Nếu là session đang chọn: Thêm badge xanh `Đang xem` (Electric Blue).
  - Hàng dưới: Đoạn tóm tắt tin nhắn cuối cùng (1 dòng, truncate với ellipsis) màu `AppColors.onSurfaceVariant`.

### Active Session Notice Banner
- Khi xem ngày cũ:
  - Container mờ đặt ngay dưới Context Header Strip:
  - Icon `Icons.event_note_rounded` màu `AppColors.primary`.
  - Text: `Đang xem lại phiên ngày dd/MM/yyyy`.
  - Nút bấm nhỏ dạng TextButton: `Quay lại Hôm nay ↺`.
