# 🚀 Release Notes: AstroBite v2.8.0 (Live Social Sync & Streak Nudge)

**Ngày phát hành**: 2026-10-04  
**Sprint**: Sprint 18  
**Version**: `v2.8.0`  
**Chịu trách nhiệm**: Sub-Agent Product Owner (PO) & Sub-Agent Tech Lead  
**Trạng thái**: 🟢 **Gate 7 Released (Production-Ready)**

---

## 🌟 Có Gì Mới Trong Phiên Bản v2.8.0?

Phiên bản **v2.8.0** đánh dấu sự hoàn thiện 100% của `EPIC-COMMUNITY`. Không còn là dữ liệu thử nghiệm cục bộ, toàn bộ hệ thống Bảng Xếp Hạng Bạn Bè và Tương Tác Xã Hội nay đã vận hành trực tiếp trên hạ tầng thời gian thực.

### 1. Live Astro Leaderboard (Bảng Xếp Hạng Thời Gian Thực)
- **Đồng bộ đa thiết bị**: Điểm `Cosmic Streak` và thứ hạng của bạn bè tự động cập nhật ngay khi bạn bè ghi nhận bữa ăn thành công.
- **Tối ưu chi phí Firebase (Ponytail Architecture)**: Sử dụng kiến trúc `StreamProvider` đọc dữ liệu tổng hợp với chi phí đúng **1 Firestore Read / session**, loại bỏ hoàn toàn nguy cơ bùng nổ chi phí truy vấn.
- **Hệ thống danh dự trực quan**: Huy chương vàng 👑, bạc 🥈, đồng 🥉 cho TOP 3; thẻ của chính người dùng được highlight viền xanh `(Bạn)`.
- **Trải nghiệm 5 trạng thái mượt mà**: Hiệu ứng Shimmer `ClaySkeletonLoader`, giao diện phi hành gia cô đơn khi chưa có bạn bè, và cơ chế chuyển đổi dữ liệu cache thông minh khi mất mạng.

### 2. Kết Bạn Thật Hai Chiều Bằng Astro ID
- **Xác thực đám mây**: Nhập mã Astro ID của bạn bè (VD: `#ASTRO-3321`) để kết nối danh bạ tức thì.
- **Bảo mật & Chống gian lận**: Chặn hành vi tự kết bạn với chính mình, chặn mã trùng lặp và xác thực chặt chẽ đầu vào.

### 3. Cơ Chế "Cứu Streak Bạn Bè" (Streak Nudge via FCM)
- **Áp lực bạn bè tích cực (Positive Peer Pressure)**: Nút `⚡ Nhắc` tự động sáng lên bên cạnh những người bạn chưa đạt mục tiêu calo hôm nay.
- **Hộp thoại xác nhận ClaySheet**: Chạm nhẹ vào nút để mở modal xác nhận trước khi gửi tín hiệu.
- **Cơ chế Anti-Spam nghiêm ngặt**: Mỗi người dùng chỉ được phép gửi thông báo nhắc nhở tối đa **1 lần / bạn bè / ngày**. Nút sẽ tự động chuyển sang trạng thái xám *"Đã nhắc"* sau khi gửi thành công.

---

## 🛡️ Chữ Ký Nghiệm Thu (Quality Gates Passed)

- **Gate 0 (Kiến Trúc & Spikes)**: ADR `ADR-S18-LIVE-SOCIAL` được Tech Lead phê chuẩn.
- **Gate 1 (PRD & BDD)**: Đạt chuẩn 100% User Stories BDD Given-When-Then.
- **Gate 2 (UI/UX Design)**: Hệ màu Claymorphic × Duolingo 2D/3D tuân thủ nghiêm ngặt bảng màu `AppColors`.
- **Gate 3 (Test Design)**: 8 kịch bản kiểm thử biên BVA và kiểm thử phá hoại hoàn chỉnh.
- **Gate 4 (Code Craftsman)**: Feature-First Clean Architecture, Riverpod 2.x, 0 over-engineering.
- **Gate 5 (Code Review - Ponytail)**: Reviewer rà soát git diff và đối soát tài liệu đạt chuẩn Zero Doc-Code Drift.
- **Gate 6 (QA & Verification)**: 
  - `flutter analyze`: **0 lỗi, 0 cảnh báo**.
  - `flutter test`: **256/256 bài test tự động vượt qua 100%**.
- **Gate 6.5 (Security)**: Kiểm toán bảo mật Anti-Spam cooldown, bảo vệ dữ liệu cá nhân PII.
- **Gate 7 (Release Gate)**: Hội đồng PO, PM và Tech Lead ký duyệt phát hành toàn diện `v2.8.0`.
