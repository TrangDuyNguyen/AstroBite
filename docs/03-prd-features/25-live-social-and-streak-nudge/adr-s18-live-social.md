# ADR: S18 Live Social Sync & Streak Nudge Architecture

- **Mã Quyết Định**: `ADR-S18-LIVE-SOCIAL`
- **Feature**: `FEAT-S18-LIVE-SOCIAL` (Epic: `EPIC-COMMUNITY`)
- **Status**: 🟢 Accepted
- **Author**: Sub-Agent Tech Lead (*The Pragmatic System Architect*)
- **Date**: 2026-10-04
- **Sprint**: Sprint 18 (AstroBite `v2.8.0`)

---

## 1. Bối Cảnh (Context)

Ở Sprint 17, chúng ta đã release Phase 1 với In-Memory Mock Leaderboard và Thẻ chia sẻ thành tích 3D (Native Share). Sang Sprint 18, mục tiêu là đưa toàn bộ hệ thống Social lên Cloud thật với 2 bài toán kỹ thuật trọng yếu:
1. **Astro Leaderboard Realtime Sync**: Làm thế nào để hàng ngàn người dùng xem được thứ hạng của bạn bè theo thời gian thực mà **không làm nổ số lượng Firestore Reads** (Vượt ngân sách Firebase Spark/Blaze)?
2. **Streak Nudge (Peer Accountability)**: Làm thế nào để người dùng có thể gửi thông báo "Hích nhẹ / Cứu Streak" cho bạn bè qua Firebase Cloud Messaging (FCM) một cách bảo mật, tức thì và **chống spam tuyệt đối**?

---

## 2. Quyết Định Kiến Trúc (Architectural Decisions)

### A. Tối Ưu Hóa Dữ Liệu Leaderboard (Single-Read Snapshot Stream)
* **Vấn Đề**: Nếu mỗi khi mở app, thiết bị lại query `firestore.collection('users').whereIn('id', friendIds).orderBy('streak')`, chi phí đọc sẽ tăng theo cấp số nhân theo số bạn bè và tần suất mở app.
* **Giải Pháp Được Chọn**:
  1. **Tài Liệu Tổng Hợp (Pre-aggregated Document)**:
     - Tạo Firestore document: `leaderboard/weekly_top_100` lưu danh sách top 100 phi hành gia xuất sắc nhất toàn hệ thống.
     - Tạo Firestore subcollection cá nhân: `users/{uid}/social/friends_summary` lưu danh sách bạn bè kèm `streak`, `avatarUrl`, `lastActive` đã được Cloud Function tính toán sẵn.
  2. **Cập Nhật Ngầm (Cloud Function Cron & Triggers)**:
     - Cloud Function `onSchedule('every 1 hours')` tổng hợp bảng xếp hạng chung.
     - Cloud Function `onDocumentWritten('users/{uid}/daily_logs/{date}')` tự động cập nhật trường `streak` và bắn snapshot sang các bạn bè liên quan.
  3. **Client Consumption**:
     - Client Flutter sử dụng Riverpod `StreamProvider` lắng nghe trực tiếp document `users/{uid}/social/friends_summary`.
     - **Chi phí**: Đúng **1 Firestore Read** cho mỗi phiên mở màn hình Leaderboard.

---

### B. Kết Nối Bạn Bè Hai Chiều (Callable Cloud Function `social_addFriend`)
* **Vấn Đề**: Client không được quyền ghi trực tiếp vào dữ liệu của người dùng khác vì vi phạm Security Rules.
* **Giải Pháp Được Chọn**:
  1. Sử dụng Firebase Cloud Functions Callable `social_addFriend`:
     - **Input**: `{ "targetAstroId": "ASTRO-XXXX" }`
     - **Validation**: Kiểm tra Auth token, kiểm tra `targetAstroId` có tồn tại trong hệ thống, không cho phép tự kết bạn với chính mình.
     - **Atomic Transaction**: Ghi đồng thời vào `users/{uid}/friends/{targetUid}` và `users/{targetUid}/friends/{uid}`.
     - **Rate Limiting**: Giới hạn tối đa 10 lời mời kết bạn / ngày / user để chống brute-force quét ID.

---

### C. Cơ Chế Streak Nudge (Peer Accountability qua FCM)
* **Vấn Đề**: Cho phép người dùng hích bạn bè mà không để lộ Token FCM của người nhận, đồng thời ngăn chặn quấy rối (Spam notification).
* **Giải Pháp Được Chọn**:
  1. **Callable Endpoint**: `social_nudgeFriend`
     - **Input**: `{ "friendUid": "target_user_id" }`
  2. **Kiểm Tra Điều Kiện Nghiệp Vụ (Backend Guard)**:
     - Người nhận và người gửi phải có quan hệ bạn bè hợp lệ.
     - Người nhận chưa hoàn thành mục tiêu calo trong ngày hôm nay.
     - **Cooldown Anti-Spam**: Mỗi người dùng chỉ được gửi tối đa **1 lần Nudge / bạn bè / ngày**. (Lưu cờ `lastNudgeAt` trong Firestore).
  3. **FCM Payload**:
     - Cloud Function đọc FCM Device Token của người nhận từ `users/{targetUid}/devices/` và gửi Data Message:
     ```json
     {
       "notification": {
         "title": "🚨 Tín hiệu vũ trụ từ bạn bè!",
         "body": "Phi hành gia TrangNguyen vừa nhắc bạn: Đừng để đứt Cosmic Streak! Ghi nhật ký bữa tối ngay 🥑"
       },
       "data": {
         "type": "STREAK_NUDGE",
         "senderId": "uid_123"
       }
     }
     ```

---

## 3. Đánh Giá Rủi Ro & Tuân Thủ Ponytail (YAGNI & Simplicity)

1. **YAGNI**: Không xây dựng hệ thống Chat nội bộ, không làm WebSocket phức tạp. Tận dụng tối đa Firebase Cloud Messaging và Firestore Stream có sẵn.
2. **Chi Phí Firestore**: Nhờ kiến trúc pre-aggregated document, chi phí đọc Firestore giảm > 90% so với query trực tiếp.
3. **Hiệu Năng**: Thời gian phản hồi của Callable Function `social_addFriend` và `social_nudgeFriend` < 600ms.

---

> 🟢 **Gate 0 Sign-Off**: Sub-Agent Tech Lead phê chuẩn thiết kế kiến trúc kỹ thuật Sprint 18. Đủ điều kiện bàn giao cho Sub-Agent BA soạn thảo PRD (Gate 1).
