# PRD: Sprint 21 - Social Guilds & Planetary Challenges

- **Mã Epic**: `EPIC-14`
- **Mã Feature**: `FEAT-S21-GUILDS`
- **Người soạn thảo**: Sub-Agent Business Analyst (BA) — *The Pedantic Logician*
- **Người thẩm định**: Sub-Agent Product Owner (PO) — *The Strategic Tyrant* & Sub-Agent Tech Lead — *The Pragmatic System Architect*
- **Trạng thái**: 🟢 **GATE 1 APPROVED**
- **Phiên bản mục tiêu**: `v3.1.0`
- **Đối chiếu QA**: `test/features/guilds/`
- **Đối chiếu FE**: `lib/features/guilds/`

---

## 1. Bối Cảnh Nghiệp Vụ & Nỗi Đau Người Dùng (Problem Statement)

1. **Sự Đơn Độc Trong Hành Trình Dinh Dưỡng (Diet Fatigue & Isolation)**:
   - Nghiên cứu hành vi cho thấy 64% người dùng bỏ thói quen ghi chép calo sau ngày thứ 7 (D7 Drop-off) vì cảm thấy "chỉ có một mình", không có ai cùng phấn đấu hoặc kiểm tra chéo (Lack of Social Accountability).
   - Mặc dù tính năng Bảng Xếp Hạng cá nhân (`LeaderboardPage` ở Sprint 17-18) đã giúp tăng tính cạnh tranh, người dùng mới hoặc người có tiến độ chậm dễ bị áp đảo bởi các "top user" điểm cao ngất ngưởng.
2. **Sức Mạnh Của Đội Nhóm Nhỏ (Dunbar's Micro-Teams)**:
   - Các nhóm bạn, gia đình, đồng nghiệp văn phòng (5 - 20 thành viên) có nhu cầu lập bang hội cùng giảm cân, thi đua ăn sạch và chia sẻ thành tích.
   - Khi cùng gánh vác một mục tiêu chung (ví dụ: Cả đội cùng tích lũy 50,000 calo lành mạnh để mở khóa một hành tinh), áp lực từ bạn bè (Friendly Peer Pressure) sẽ ngăn chặn việc bỏ log.

👉 **Giải pháp**: Xây dựng phân hệ **Social Guilds & Planetary Challenges** — Nơi người dùng thành lập hoặc gia nhập Bang Hội Vũ Trụ bằng mã mời độc bản (Invite Code), cùng đồng đội chinh phục các Chiến Dịch Hành Tinh theo tuần và tích lũy điểm năng lượng Starlight XP tự động mỗi khi ghi chép bữa ăn.

---

## 2. Mục Tiêu Nghiệp Vụ Đo Lường Được (OKRs & Success Metrics)

* **M1 (Nâng Cao Tỷ Lệ Giữ Chân D30)**: Tăng tỷ lệ D30 Retention của người dùng tham gia Guild từ 35% lên **$\ge 48\%$** (+13% điểm phần trăm).
* **M2 (Tần Suất Tương Tác Hằng Ngày)**: Tăng tỷ lệ DAU/MAU từ 45% lên **$\ge 55\%$** nhờ thói quen mở app xem tiến độ cả bang hội.
* **M3 (Tỷ Lệ Hoàn Thành Chiến Dịch)**: Đạt tỷ lệ **$\ge 60\%$** các Bang hội kích hoạt hoàn thành mục tiêu Chiến Dịch Hành Tinh trong tuần.
* **M4 (Hiệu Năng & SLA Kỹ Thuật)**:
  - Thời gian tải Guild Dashboard: **$\le 800ms$** với local cache.
  - Tỷ lệ xung đột/lệch điểm khi nhiều thành viên log đồng thời: **$0\%$** nhờ Firestore atomic increment.
  - FPS cuộn danh sách thành viên: **$\ge 55$ FPS**.

---

## 3. Chân Dung Người Dùng Mục Tiêu (Personas)

1. **Persona 1: Thủ Lĩnh Bang Hội (Guild Leader - Lan, 27 tuổi, Trưởng nhóm công nghệ)**:
   - Thích tổ chức các hoạt động nhóm, muốn lập bang hội 8 người cho phòng ban để cùng ăn eat-clean và uống đủ nước.
   - Hành vi: Tạo Guild "Vệ Binh Sao Hỏa", sao chép Invite Code gửi vào nhóm chat công ty, theo dõi ai chưa log để nhắc nhở.
2. **Persona 2: Thành Viên Đồng Hành (Guild Member - Hoàng, 24 tuổi, Lập trình viên)**:
   - Dễ quên ghi nhật ký ăn uống nếu bận việc, nhưng rất sợ làm tụt điểm thi đua của cả phòng.
   - Hành vi: Nhập mã mời để vào đội, mỗi bữa ăn xong lập tức log để nhận +50 Starlight XP đóng góp cho đội.

---

## 4. Phạm Vi & Phân Loại MoSCoW Khắt Khe

### 4.1. In-Scope (Must-Have 61% & Should-Have 23%)
- **Tạo & Gia nhập Bang hội**:
  - Tạo Bang hội mới: Nhập Tên bang, Mô tả ngắn, chọn Avatar Hành Tinh (Mars, Venus, Jupiter, Saturn, Neptune).
  - Tự động sinh mã mời độc bản 6 ký tự viết hoa (VD: `ASTRO9`).
  - Gia nhập bằng cách nhập mã mời hợp lệ hoặc duyệt danh sách công khai (Public Guilds).
  - Giới hạn tối đa 20 thành viên / Guild.
- **Guild Dashboard & Vòng Cung Tiến Độ (Planetary Challenge Arc)**:
  - Hiển thị thông tin Bang hội, cấp bậc và tổng Starlight XP.
  - Thẻ Chiến Dịch Hành Tinh hiện hành (VD: "Chiến dịch Sao Hỏa: 50,000 Kcal Lành Mạnh").
  - Thanh tiến độ nhóm `GuildProgressArc` màu xanh Duolingo Lime Green (`#58CC02`).
- **Cơ Chế Đóng Góp Tự Động (Auto-Contribution)**:
  - Bất cứ khi nào thành viên log 1 bữa ăn hợp lệ: Tự động cộng +50 Starlight XP vào điểm cá nhân và quỹ điểm chung của Bang hội mà không cần bấm thêm nút nào.
- **Bảng Xếp Hạng Đóng Góp Nội Bộ (Guild Member Leaderboard)**:
  - Danh sách thành viên xếp theo điểm đóng góp trong tuần, gắn nhãn MVP cho top 1.
  - Hiển thị số ngày streak cá nhân của từng thành viên.
  - Nút Nudge 1-chạm để gửi lời nhắc đồng đội.

### 4.2. Out-of-Scope (Won't-Have 0% - Anti-Bloat)
- ❌ Không xây dựng chat voice hoặc tin nhắn văn bản tự do trong Guild (tránh chi phí kiểm duyệt nội dung độc hại).
- ❌ Không có mua bán/chuyển nhượng vật phẩm hoặc nạp tiền tệ ảo.
- ❌ Không có cơ chế chiến tranh bang hội PvP gây độc hại tâm lý (chỉ tập trung vào thử thách tích cực hỗ trợ lẫn nhau).

---

## 5. Từ Điển Dữ Liệu Chi Tiết (Data Dictionary)

| Trường Dữ Liệu | Kiểu Dữ Liệu | Ràng Buộc & Mặc Định | Ý Nghĩa Nghiệp Vụ |
| :--- | :--- | :--- | :--- |
| `guild_id` | String | UUID v4, Bắt buộc | Khóa chính định danh duy nhất Bang hội |
| `name` | String | 3 - 30 ký tự, Bắt buộc | Tên hiển thị của Bang hội |
| `description` | String | $\le 120$ ký tự | Tuyên ngôn/Mô tả mục tiêu của bang hội |
| `avatar_planet` | String Enum | `mars`, `venus`, `jupiter`, `saturn`, `neptune` | Hành tinh biểu tượng của đội |
| `invite_code` | String | 6 ký tự alphanumeric in hoa (A-Z, 0-9) | Mã mời gia nhập độc bản |
| `owner_id` | String | Bắt buộc | ID người dùng giữ vai trò Trưởng bang (Leader) |
| `member_count` | Integer | $1 \le N \le 20$ | Số lượng thành viên hiện tại |
| `member_ids` | List<String> | Tối đa 20 phần tử | Danh sách user_id thành viên để query nhanh |
| `total_starlight_xp` | Integer | $\ge 0$, Mặc định 0 | Tổng điểm năng lượng tích lũy của toàn bang |
| `active_challenge` | Map / Model | Nullable | Chiến dịch tuần hiện hành |
| `challenge_target` | Integer | Mặc định 50,000 | Mục tiêu số (Calo hoặc Điểm) cần đạt trong tuần |
| `challenge_current` | Integer | $\ge 0$, tăng tự động | Tiến độ điểm đạt được của cả đội |
