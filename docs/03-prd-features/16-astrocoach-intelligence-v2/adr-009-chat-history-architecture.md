# ADR-009: Kiến Trúc Lưu Trữ & Truy Xuất Lịch Sử Hội Thoại AstroCoach

- **Feature**: `FEAT-16-EXT` (AstroCoach Conversation History & Multi-Session Review)
- **Status**: **ACCEPTED**
- **Date**: 2026-09-24
- **Author**: Sub-Agent Tech Lead (`tech-lead`) — *"The Pragmatic System Architect"*

---

## 1. Ngữ Cảnh Kỹ Thuật (Context)

AstroBite hiện đang lưu trữ tin nhắn theo từng ngày trong Firestore collection:
`users/{userId}/chat_sessions/{yyyy-MM-dd}`
Mỗi document lưu trữ:
- `date`: `String` (định dạng `yyyy-MM-dd`)
- `last_message_at`: `Timestamp`
- `message_count`: `int`
- `messages`: `List<Map<String, dynamic>>`

Tuy nhiên, `CoachController` và `CoachPage` hiện mới chỉ truy vấn document của ngày hôm nay (`loadTodaySession`). Người dùng cần xem lại lịch sử các buổi tư vấn dinh dưỡng trước đó để đối chiếu thực đơn và lời khuyên.

---

## 2. Các Phương Án Kiến Trúc

### Phương án A: Tải toàn bộ messages của 30 ngày cùng lúc vào RAM
- **Ưu điểm**: Chuyển session nhanh.
- **Nhược điểm**: Lãng phí RAM di động, vi phạm Ponytail, chi phí đọc Firestore cao không cần thiết.

### Phương án B (Được Chọn): Phân tách Danh sách Phiên (Metadata List) & Chi tiết Phiên (On-Demand Fetch)
- **Cơ chế**:
  1. Khi người dùng mở khay Lịch sử, chỉ truy vấn danh sách metadata các document trong `chat_sessions` (giới hạn 30 ngày gần nhất qua `orderBy('date', descending: true)`), chỉ đọc `date`, `message_count`, và trích xuất tin nhắn cuối cùng (`last_message`).
  2. Khi người dùng bấm chọn một ngày cụ thể, mới gọi `loadSessionByDate(userId, date)` để nạp chi tiết danh sách `ChatMessage`.
  3. Quản lý trạng thái xem bằng `selectedSessionDate` (nếu `null` hoặc bằng hôm nay: Chế độ Live Chat; nếu là ngày trong quá khứ: Chế độ Review Mode với banner thông báo).
- **Đánh giá**:
  - Tuân thủ nghiêm ngặt **Ponytail**: Không thêm model phức tạp, tái sử dụng `ChatMessage.fromMap`.
  - Tối ưu chi phí Firestore: Chỉ đọc session chi tiết khi người dùng thực sự bấm xem.
  - Phản hồi cực nhanh: List sessions nhẹ chỉ vài KB.

---

## 3. Quyết Định Kỹ Thuật (Decision)

1. Mở rộng `CoachRepository`:
   - `loadChatSessionsList(String userId)`: Trả về `Future<List<ChatSessionSummary>>` (hoặc `Map<String, dynamic>`).
   - `loadSessionByDate(String userId, String date)`: Trả về `Future<List<ChatMessage>>`.
2. Mở rộng `CoachController`:
   - State quản lý tin nhắn của phiên đang được chọn.
   - Thêm `selectedDate` và hàm `selectSessionDate(String? date)`.
3. Bổ sung giao diện trên `CoachPage`:
   - Nút `Icons.history_rounded` trên AppBar.
   - Khay `CelestialHistoryBottomSheet` hiển thị danh sách các ngày trò chuyện.
   - Banner `Đang xem lại phiên ngày dd/MM/yyyy • [Quay lại Hôm nay]`.
