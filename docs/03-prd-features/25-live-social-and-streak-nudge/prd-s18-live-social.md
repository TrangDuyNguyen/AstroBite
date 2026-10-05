# PRD: Sprint 18 - Live Social Sync & Streak Nudge

- **Mã Epic**: `EPIC-COMMUNITY`
- **Mã Feature**: `FEAT-S18-LIVE-SOCIAL`
- **Người soạn thảo**: Sub-Agent Business Analyst (BA)
- **Reviewers**: Sub-Agent PO (Gate 1 Sign-Off) & Sub-Agent Tech Lead (Feasibility Sign-Off)
- **Trạng thái**: 🟢 Approved (Gate 1 Passed)

---

## 1. Tổng Quan & Bối Cảnh Nghiệp Vụ

Tiếp nối thành công của phiên bản v2.7.0 (thử nghiệm giao diện bảng xếp hạng và tính năng chia sẻ thành tích Native Share 3D), **Sprint 18 (AstroBite v2.8.0)** hoàn thiện toàn bộ tầng dữ liệu đám mây (Live Backend) cho hệ thống Cộng đồng:
1. Đưa Bảng Xếp Hạng bạn bè lên dữ liệu thời gian thực từ Firestore.
2. Tích hợp tính năng kết bạn thật thông qua mã định danh **Astro ID**.
3. Bổ sung cơ chế **Streak Nudge ("Cứu Streak bạn bè")** để thúc đẩy áp lực bạn bè tích cực (Positive Peer Pressure), nhắc nhở nhau hoàn thành mục tiêu calo trước giờ chốt sổ hàng ngày.

---

## 2. Mục Tiêu & Chỉ Số Đo Lường Thành Công (OKRs & Metrics)

* **K1 (D30 Retention Booster)**: Tăng tỷ lệ giữ chân D30 thêm **15%** đối với nhóm người dùng kết nối từ 2 bạn bè trở lên.
* **K2 (Daily Active Engagement)**: Tỷ lệ mở app buổi tối (18:00 – 21:00) tăng **25%** nhờ thông báo nhắc nhở Streak Nudge từ bạn bè.
* **K3 (Network Virality)**: Trung bình mỗi người dùng gửi thành công ít nhất 1 mã Astro ID tới bạn bè ngoài đời thực.

---

## 3. Phạm Vi Tính Năng Chi Tiết (In-Scope)

### 3.1. Bảng Xếp Hạng Thời Gian Thực (Live Friends Leaderboard)
* **Nguồn Dữ Liệu**: Đọc snapshot được Cloud Function tính toán sẵn từ Firestore `users/{uid}/social/friends_summary`.
* **Trải Nghiệm**: Khi người dùng hoặc bạn bè vừa ghi nhận bữa ăn và tăng `Cosmic Streak`, bảng xếp hạng tự động phản ánh thứ hạng mới mà không cần kéo vuốt reload thủ công.
* **Hiển Thị**:
  * TOP 1, 2, 3 được gắn icon vương miện danh dự (👑, 🥈, 🥉).
  * Hiển thị trạng thái hoàn thành calo ngày hôm nay: Badge xanh *"Đã đạt mục tiêu"* hoặc Badge cam *"Chưa hoàn thành"*.

### 3.2. Kết Bạn Bằng Astro ID Thật (Cloud Connection)
* **Luồng Tương Tác**: Bấm nút "Thêm bạn", nhập mã Astro ID (VD: `#ASTRO-7721`) ➔ Gọi Callable Function `social_addFriend`.
* **Phản Hồi UI**:
  * Thành công: Animation chúc mừng, danh sách bạn bè nạp thêm người bạn mới ngay lập tức.
  * Thất bại: Báo lỗi chính xác (Mã không tồn tại, đã là bạn bè từ trước, hoặc cố gắng tự kết bạn với chính mình).

### 3.3. Cơ Chế "Cứu Streak Bạn Bè" (Streak Nudge via FCM)
* **Điều Kiện Kích Hoạt**: Nút icon **🔥 Nhắc nhở** chỉ sáng lên bên cạnh những người bạn chưa đạt mục tiêu calo trong ngày hôm nay.
* **Hành Động**: Người dùng bấm "🔥 Nhắc nhở" ➔ Modal xác nhận nhẹ nhàng ➔ Cloud Function gửi Push Notification FCM tức thì tới máy bạn bè.
* **Anti-Spam Guard**: Mỗi ngày chỉ được phép bấm Nudge bạn bè đúng 1 lần. Sau khi bấm, nút chuyển sang trạng thái xám disabled với nhãn *"Đã nhắc nhở hôm nay"*.

---

## 4. Phạm Vi Loại Trừ (Out-of-Scope)
* ❌ Trò chuyện nhắn tin 1-1 (Direct Messaging).
* ❌ Thách đấu đối kháng ăn uống (PvP Battles).

---

> 🟢 **Gate 1 Sign-Off**:
> - **Sub-Agent PO**: Đã thẩm định. Mục tiêu ROI rõ ràng, tác động trực tiếp vào D30 Retention. Phê duyệt!
> - **Sub-Agent Tech Lead**: Khả thi về mặt kỹ thuật, kiến trúc single-read bảo đảm an toàn ngân sách Firebase. Phê duyệt!
