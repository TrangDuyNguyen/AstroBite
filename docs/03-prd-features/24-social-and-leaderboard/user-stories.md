# User Stories BDD: Sprint 17 Social & Leaderboard

- **Người soạn thảo**: Sub-Agent BA
- **Chuẩn**: BDD (Behavior-Driven Development)
- **Trạng thái triển khai thực tế**:
  - User Story 1 (Social Share): 🟢 `[Full-Stack Native Ready — v2.7.0]`
  - User Story 2 (Leaderboard & Add Friend): 🟡 `[Phase 1: In-Memory Client State — v2.7.0]` (Giai đoạn 1 phục vụ kiểm thử UX; Phase 2 kết nối Cloud Functions & Firestore Stream dời sang v2.8.0).

---

## Epic: Social Accountability

### User Story 1: Chia Sẻ Thành Tích Bữa Ăn / Ngày
> **Trạng thái**: 🟢 `[Full-Stack Native Ready — v2.7.0]`

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

### User Story 2: Xem Bảng Xếp Hạng Bạn Bè (Leaderboard) & Thêm Bạn
> **Trạng thái**: 🟡 `[Phase 1: In-Memory Client State — v2.7.0]`  
> *(Lưu ý kỹ thuật: Ở phiên bản v2.7.0, Leaderboard vận hành qua Local State tại `LeaderboardPage` để validate UX và tương tác kết bạn nhanh. Việc đồng bộ đa thiết bị qua Firestore Stream và Cloud Functions sẽ được kích hoạt tại Phase 2 - v2.8.0).*

**Là một** người dùng có tính cạnh tranh,
**Tôi muốn** xem vị trí của mình so với bạn bè,
**Để** có thêm động lực duy trì kỷ luật ăn uống.

**Kịch bản 1: Tải Bảng Xếp Hạng (Phase 1: Mock State)**
- **Given** người dùng mở màn hình Bảng Xếp Hạng
- **When** màn hình tải xong
- **Then** hiển thị danh sách xếp hạng theo thứ tự `Cosmic Streak` giảm dần
- **And** TOP 3 phải được làm nổi bật với các icon Huy Chương (👑, 🥈, 🥉) và thẻ của chính người dùng được highlight viền xanh `(Bạn)`.

**Kịch bản 2: Thêm Bạn Bè bằng Astro ID (Phase 1: Local In-Memory)**
- **Given** người dùng ở màn hình Leaderboard và bấm "Thêm Bạn"
- **When** người dùng nhập mã Astro ID (VD: `#ASTRO-9999`) vào `ClaySheet` và bấm Xác Nhận
- **Then** danh sách bạn bè được bổ sung ngay lập tức và sắp xếp lại thứ hạng theo Streak
- **And** hiển thị SnackBar chúc mừng đã kết bạn thành công.

---

## 📡 Danh sách Endpoints & Lộ Trình Kỹ Thuật (Data Sources Phasing)

### Phase 1: v2.7.0 (Hiện tại — Đã hoàn thành)
1. **Local Share Service**: Dùng `RepaintBoundary` và `share_plus` xuất ảnh tạm thời ra `path_provider`, không qua mạng.
2. **Local Leaderboard State**: Dùng In-memory state trên `LeaderboardPage` để duyệt trải nghiệm UI/UX và tương tác tức thì.

### Phase 2: v2.8.0 (Kế hoạch Sprint tiếp theo)
1. **Leaderboard Data (Realtime Stream)**:
   - **Type**: Firestore Document Read (Stream)
   - **Path**: `leaderboard/weekly_top_100`
   - **Cơ chế**: Cloud Functions tính toán ngầm mỗi 1 giờ, app chỉ đọc 1 document qua Riverpod StreamProvider.
2. **Gửi Lời Mời Kết Bạn (Add Friend)**:
   - **Type**: Firebase Cloud Functions (Callable)
   - **Endpoint**: `social_addFriend`
   - **Payload**: `{ "targetAstroId": "A1B2C3" }`
