# User Stories BDD: Sprint 17 Social & Leaderboard

- **Người soạn thảo**: Sub-Agent BA
- **Chuẩn**: BDD (Behavior-Driven Development)

## Epic: Social Accountability

### User Story 1: Chia Sẻ Thành Tích Bữa Ăn / Ngày
**Là một** người dùng tự hào về chuỗi ăn kiêng của mình,
**Tôi muốn** bấm nút chia sẻ báo cáo năng lượng ra ảnh,
**Để** tôi có thể đăng lên Instagram/Facebook khoe với bạn bè.

**Kịch bản 1: Render ảnh và mở hộp thoại thành công**
- **Given** người dùng đang ở trang `AnalyticsPage` (hoặc `GoalSummaryPage`) và có kết nối mạng
- **When** người dùng bấm nút "Share Card"
- **Then** ứng dụng phải capture Widget thành file `.png` với chất lượng x3.0 trong dưới 300ms
- **And** Native Share Dialog của máy (Android/iOS) sẽ được kích hoạt với ảnh vừa tạo.

**Kịch bản 2: Xử lý lỗi Permission Storage (Chỉ trên Android cũ)**
- **Given** thiết bị Android 9 trở xuống chưa cấp quyền Storage
- **When** người dùng bấm nút "Share Card"
- **Then** ứng dụng hiện prompt xin quyền lưu trữ
- **And** nếu từ chối, hiển thị Snackbar lỗi nhẹ nhàng theo Claymorphic UI.

---

### User Story 2: Xem Bảng Xếp Hạng Bạn Bè (Leaderboard)
**Là một** người dùng có tính cạnh tranh,
**Tôi muốn** xem vị trí của mình so với bạn bè,
**Để** có thêm động lực duy trì kỷ luật ăn uống.

**Kịch bản 1: Tải Bảng Xếp Hạng**
- **Given** người dùng đã có 3 bạn bè trong danh sách
- **When** người dùng mở tab "Cộng Đồng"
- **Then** hiển thị danh sách xếp hạng theo thứ tự `Cosmic Streak` giảm dần
- **And** TOP 3 phải được làm nổi bật với các icon Huy Chương (Vàng/Bạc/Đồng).

**Kịch bản 2: Không có bạn bè**
- **Given** người dùng chưa có bạn bè nào
- **When** người dùng mở tab "Cộng Đồng"
- **Then** hiển thị giao diện Màn Hình Trống (Empty State) với một minh họa phi hành gia cô đơn
- **And** có nút CTA "Tìm Kiếm Bạn Bè Bằng Astro ID".

---

## 📡 Danh sách Endpoints & Nguồn Dữ Liệu (Data Sources)

Để Dev FE và Native ghép nối, dưới đây là đặc tả các Endpoints bắt buộc cho màn hình này:

### 1. Leaderboard Data (Realtime Stream)
- **Type**: Firestore Document Read (Stream)
- **Path**: `leaderboard/weekly_top_100` (hoặc `leaderboard/{user_id}` nếu filter riêng list bạn bè của user)
- **Mô tả**: Thiết bị chỉ việc lắng nghe (listen) document này. Khi Cloud Functions chạy ngầm và ghi đè dữ liệu mới, UI sẽ tự động update qua Riverpod StreamProvider. Không gọi query tốn kém.

### 2. Gửi Lời Mời Kết Bạn (Add Friend)
- **Type**: Firebase Cloud Functions (Callable)
- **Endpoint Name**: `social_addFriend`
- **Payload (Input)**: `{ "targetAstroId": "A1B2C3" }`
- **Response (Output)**: `{ "status": "success/error", "message": "..." }`
- **Mô tả**: Gọi function để kiểm tra Astro ID có tồn tại hay không và ghi vào collection `friends` trên backend, đảm bảo logic bảo mật.

### 3. Share Card (No Network Endpoint)
- **Type**: Local Native Action
- **Mô tả**: Không có API. App sử dụng `RepaintBoundary` ghi ảnh trực tiếp ra `path_provider` và gọi OS Native Share.
