# User Stories BDD: Sprint 18 Live Social Sync & Streak Nudge

- **Người soạn thảo**: Sub-Agent BA (*The Pedantic Logician*)
- **Chuẩn kiểm thử**: BDD (Behavior-Driven Development)
- **Traceability**: `EPIC-COMMUNITY` / `FEAT-S18-LIVE-SOCIAL`

---

## 🎯 User Story 1: Xem Bảng Xếp Hạng Bạn Bè Thời Gian Thực (Live Stream)

**Là một** người dùng tham gia cộng đồng AstroBite,  
**Tôi muốn** xem bảng xếp hạng cập nhật realtime theo điểm Streak của tôi và bạn bè,  
**Để** tôi cảm nhận được sự ganh đua lành mạnh và có động lực giữ chuỗi ăn sạch.

### Kịch bản 1.1: Tải danh sách bạn bè qua Stream thành công
- **Given** người dùng đã đăng nhập và đang kết nối internet
- **When** người dùng mở màn hình Bảng Xếp Hạng (Astro Leaderboard)
- **Then** ứng dụng kết nối tới `StreamProvider` lắng nghe snapshot bạn bè từ Firestore
- **And** danh sách hiển thị trong dưới 500ms, xếp hạng giảm dần theo `Cosmic Streak`
- **And** vị trí của chính người dùng được ghim viền xanh nổi bật `(Bạn)`.

### Kịch bản 1.2: Bạn bè vừa hoàn thành bữa ăn và tăng Streak
- **Given** người dùng đang mở màn hình Leaderboard
- **When** một người bạn trong danh sách vừa log bữa ăn và Streak tăng từ 5 lên 6
- **Then** thẻ của người bạn đó lập tức cập nhật số 6 và tự động đẩy lên vị trí xếp hạng mới mà người dùng không cần reload màn hình.

---

## 🎯 User Story 2: Kết Bạn Hai Chiều Bằng Astro ID Thật

**Là một** người dùng muốn rủ bạn bè cùng kiêng khem,  
**Tôi muốn** nhập mã Astro ID của bạn tôi để kết nối vào danh sách bạn bè,  
**Để** chúng tôi có thể theo dõi và thúc đẩy lẫn nhau.

### Kịch bản 2.1: Nhập đúng mã Astro ID của bạn bè
- **Given** người dùng mở bottom sheet "Thêm Bạn"
- **When** người dùng nhập mã Astro ID hợp lệ (VD: `#ASTRO-3321`) và bấm "Kết bạn"
- **Then** ứng dụng gọi Callable Function `social_addFriend` với payload `{ "targetAstroId": "ASTRO-3321" }`
- **And** hộp thoại đóng lại, hiển thị SnackBar xanh: *"🎉 Đã kết bạn thành công với Phi hành gia #ASTRO-3321!"*
- **And** danh sách bảng xếp hạng tự động xuất hiện người bạn mới.

### Kịch bản 2.2: Nhập mã chính mình
- **Given** người dùng mở bottom sheet "Thêm Bạn"
- **When** người dùng nhập chính mã Astro ID của mình
- **Then** hiển thị SnackBar cảnh báo cam: *"Bạn không thể tự kết bạn với chính mình."*
- **And** không có lời gọi API thừa nào được gửi lên server.

### Kịch bản 2.3: Mã không tồn tại trên hệ thống
- **Given** người dùng nhập mã không có trong database (VD: `#INVALID-9999`)
- **When** người dùng bấm "Kết bạn"
- **Then** ứng dụng hiển thị thông báo lỗi: *"Không tìm thấy phi hành gia với mã Astro ID này."*

---

## 🎯 User Story 3: Cứu Streak Bạn Bè (Streak Nudge via Push Notification)

**Là một** người bạn chu đáo và kỷ luật,  
**Tôi muốn** bấm nút nhắc nhở khi thấy bạn tôi chưa ghi nhật ký hôm nay,  
**Để** cứu chuỗi Streak của bạn tôi trước khi ngày kết thúc.

### Kịch bản 3.1: Gửi nhắc nhở thành công
- **Given** người bạn "AlexD" có trạng thái hôm nay là *"Chưa đạt mục tiêu"*
- **When** tôi bấm vào nút icon "🔥 Nhắc nhở" cạnh tên AlexD
- **Then** hệ thống gọi Callable Function `social_nudgeFriend` với payload `{ "friendUid": "alex_uid" }`
- **And** thiết bị của AlexD nhận được Push Notification: *"🚨 Phi hành gia TrangNguyen vừa nhắc bạn: Đừng để đứt Cosmic Streak! Ghi nhật ký bữa tối ngay 🥑"*
- **And** trên màn hình của tôi, nút chuyển sang màu xám disabled với nhãn *"Đã nhắc nhở"*.

### Kịch bản 3.2: Thử gửi nhắc nhở lần thứ 2 trong ngày (Anti-spam)
- **Given** tôi đã gửi nhắc nhở cho AlexD trong ngày hôm nay
- **When** tôi tìm cách kích hoạt lại hành động nhắc nhở
- **Then** nút bị khóa không thể nhấn
- **And** backend từ chối với mã lỗi `ALREADY_NUDGED_TODAY` nếu có yêu cầu bất thường.

---

## 📡 Danh Sách Endpoints & Cloud Functions Đặc Tả

### 1. `leaderboard_stream` (Firestore Realtime Subscription)
- **Collection Path**: `users/{uid}/social/friends_summary`
- **Mode**: Riverpod `StreamProvider<List<FriendRankingEntity>>`
- **Data Shape**:
  ```json
  [
    {
      "uid": "usr_01",
      "astroId": "ASTRO-8821",
      "displayName": "AlexD",
      "streak": 45,
      "goalAchievedToday": false,
      "avatarUrl": "https://..."
    }
  ]
  ```

### 2. Callable Function: `social_addFriend`
- **Endpoint**: `httpsCallable('social_addFriend')`
- **Request**: `{ "targetAstroId": "string" }`
- **Response**: `{ "success": true, "friend": { "uid": "...", "displayName": "..." } }`

### 3. Callable Function: `social_nudgeFriend`
- **Endpoint**: `httpsCallable('social_nudgeFriend')`
- **Request**: `{ "friendUid": "string" }`
- **Response**: `{ "success": true, "message": "Nudge sent successfully" }`
