# Danh Sách User Stories & Kịch Bản BDD: Social Guilds

> **Dự án**: AstroBite (`astrobite`)  
> **Mã Epic / Feature**: `EPIC-14` / `FEAT-S21-GUILDS`  
> **Người biên soạn**: Sub-Agent Business Analyst (BA) — *The Pedantic Logician*  
> **Định dạng**: Gherkin BDD (Given - When - Then)  

---

## 🎯 US-01: Tạo Bang Hội Mới & Phát Hành Mã Mời
**Là một** người dùng AstroBite năng động,  
**Tôi muốn** tạo một Bang Hội Vũ Trụ và nhận một Mã Mời 6 ký tự,  
**Để** mời bạn bè và đồng nghiệp cùng tham gia thi đua dinh dưỡng.

### Scenario 1.1: Tạo bang hội thành công
- **Given** người dùng đã đăng nhập và hiện chưa tham gia bang hội nào
- **When** người dùng mở màn hình Tạo Bang Hội
- **And** nhập tên "Vệ Binh Sao Hỏa", mô tả "Cùng nhau ăn sạch", chọn biểu tượng "mars"
- **And** nhấn nút "Khởi Tạo Bang Hội"
- **Then** hệ thống khởi tạo bản ghi Guild mới trong Firestore với 1 thành viên (Leader)
- **And** tự động sinh mã mời độc bản 6 ký tự ngẫu nhiên (ví dụ `MARS01`)
- **And** chuyển hướng người dùng đến Guild Dashboard với thông báo thành công.

### Scenario 1.2: Lỗi trùng hoặc tên không hợp lệ
- **Given** người dùng đang ở form tạo bang hội
- **When** người dùng để trống tên hoặc nhập tên dưới 3 ký tự
- **Then** hệ thống chặn submit và hiển thị thông báo lỗi "Tên bang hội phải từ 3 đến 30 ký tự".

---

## 🎯 US-02: Gia Nhập Bang Hội Bằng Mã Mời
**Là một** thành viên mới,  
**Tôi muốn** nhập mã mời nhận được từ bạn bè,  
**Để** gia nhập đúng bang hội của nhóm mình.

### Scenario 2.1: Nhập mã mời hợp lệ
- **Given** người dùng chưa thuộc bang hội nào
- **When** người dùng chọn "Nhập Mã Mời", gõ "MARS01" và nhấn "Gia Nhập"
- **Then** hệ thống xác thực mã mời tồn tại và số thành viên hiện tại $< 20$
- **And** thêm người dùng vào danh sách thành viên với vai trò "member"
- **And** mở ra Guild Dashboard và hiển thị tên nhóm.

### Scenario 2.2: Mã mời không tồn tại hoặc hết hạn
- **Given** người dùng nhập mã "INVALID"
- **When** nhấn "Gia Nhập"
- **Then** hệ thống hiển thị thông báo lỗi thân thiện "Không tìm thấy Bang hội với mã mời này".

### Scenario 2.3: Bang hội đã đủ 20 thành viên
- **Given** bang hội tương ứng đã có đủ 20/20 thành viên
- **When** người dùng nhấn "Gia Nhập"
- **Then** hệ thống từ chối và báo "Bang hội này đã đủ số lượng thành viên tối đa (20/20)".

---

## 🎯 US-03: Xem Tiến Độ Chiến Dịch Hành Tinh & Đóng Góp Tự Động
**Là một** thành viên trong bang hội,  
**Tôi muốn** thấy tiến độ chung của cả nhóm và điểm đóng góp cá nhân tự động tăng khi log bữa ăn,  
**Để** cảm nhận rõ rệt sự đóng góp của mình vào chiến thắng của toàn đội.

### Scenario 3.1: Tự động cộng Starlight XP khi ghi chép bữa ăn
- **Given** người dùng đang thuộc bang hội "Vệ Binh Sao Hỏa"
- **When** người dùng hoàn thành ghi nhật ký 1 bữa ăn trong ngày
- **Then** hệ thống tự động cộng +50 Starlight XP vào `weekly_contribution_xp` của người dùng
- **And** tự động cộng +50 Starlight XP vào `total_starlight_xp` của bang hội qua atomic increment
- **And** cập nhật thanh tiến độ `GuildProgressArc` trên màn hình Dashboard ngay lập tức.

### Scenario 3.2: Hoàn thành Chiến Dịch Tuần Hành Tinh
- **Given** Chiến dịch đang có tiến độ 49,960 / 50,000 XP
- **When** một thành viên bất kỳ đóng góp thêm +50 XP
- **Then** tiến độ đạt 50,000 / 50,000 (100%)
- **And** trạng thái chiến dịch chuyển sang "completed"
- **And** màn hình hiển thị hiệu ứng chúc mừng (Planetary Victory banner).

---

## 🎯 US-04: Bảng Xếp Hạng Nội Bộ & Nhắc Nhở Đồng Đội (Streak Nudge)
**Là một** thành viên trong bang hội,  
**Tôi muốn** xem bảng xếp hạng đóng góp của các thành viên và gửi lời nhắc nhở thân thiện,  
**Để** thúc đẩy đồng đội duy trì chuỗi Streak.

### Scenario 4.1: Xếp hạng thành viên theo điểm đóng góp
- **Given** bang hội có nhiều thành viên
- **When** người dùng cuộn xem danh sách thành viên trên Dashboard
- **Then** các thành viên được sắp xếp giảm dần theo điểm `weekly_contribution_xp`
- **And** thành viên Top 1 được gắn nhãn huy hiệu "MVP".

### Scenario 4.2: Gửi Nudge nhắc nhở đồng đội
- **Given** thành viên B chưa ghi nhật ký hôm nay
- **When** người dùng nhấn nút biểu tượng "Nudge" cạnh tên thành viên B
- **Then** rung haptic phản hồi nhẹ
- **And** hiển thị SnackBar "Đã gửi lời nhắc giữ chuỗi Streak đến [Tên thành viên B]".
