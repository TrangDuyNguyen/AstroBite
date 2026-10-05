# Gate 3: Master Test Plan — Sprint 18 Live Social & Streak Nudge

- **Người thực hiện**: Sub-Agent QA Tester (*The Paranoid Inquisitor*)
- **Chuẩn kiểm thử**: EP (Equivalence Partitioning) & BVA (Boundary Value Analysis) + BDD Gherkin
- **Trạng thái**: 🟢 Gate 3 Design Approved

---

## 1. Ma Trận Kịch Bản Kiểm Thử Chức Năng (Functional Test Cases)

| TC ID | Kịch Bản Kiểm Thử | Phân Vùng Tương Đương / Biên | Kết Quả Kỳ Vọng | Trọng Yếu |
| :--- | :--- | :--- | :--- | :---: |
| `TC-S18-01` | Mở màn hình Leaderboard khi có kết nối mạng tốt | Phân vùng hợp lệ (Normal online) | Hiển thị danh sách xếp hạng theo thứ tự Streak giảm dần trong < 500ms | P0 |
| `TC-S18-02` | Mở màn hình Leaderboard khi mất mạng (Offline) | Ngoại lệ kết nối (Network offline) | Hiển thị cache offline gần nhất, không bị màn hình trắng/crash | P0 |
| `TC-S18-03` | Kết bạn với mã Astro ID chuẩn 6 ký tự | Input hợp lệ (Valid ID) | Gọi Callable thành công, thêm bạn bè vào danh sách tức thì | P0 |
| `TC-S18-04` | Kết bạn bằng chính mã Astro ID của tài khoản đang đăng nhập | Biên tự thân (Self-referential ID) | Hiển thị lỗi *"Không thể tự kết bạn với chính mình"*, 0 API call thừa | P1 |
| `TC-S18-05` | Kết bạn với mã không tồn tại / gõ bừa 50 ký tự | Ngoại lệ dữ liệu (Malformed / Non-existent) | Server trả mã `NOT_FOUND`, UI hiển thị SnackBar cảnh báo | P1 |
| `TC-S18-06` | Bấm nút "🔥 Nhắc nhở" bạn bè chưa đạt chuẩn | Hành động hợp lệ lần 1 trong ngày | Gửi FCM push thành công, nút chuyển xám *"Đã nhắc nhở"* | P0 |
| `TC-S18-07` | Spam click liên tục vào nút "Nhắc nhở" (5 lần/giây) | Kiểm thử phá hoại (Rapid tap / Race condition) | Nút bị debounce/disabled ngay lần nhấn đầu tiên, chỉ gửi đúng 1 request | P0 |
| `TC-S18-08` | Cố tình gọi API `social_nudgeFriend` lần thứ 2 trong cùng 1 ngày | Biên thời gian (Daily cooldown violation) | Backend chặn với lỗi `ALREADY_NUDGED_TODAY`, không bắn FCM trùng | P0 |

---

## 2. Tiêu Chí Phi Chức Năng (Non-Functional SLAs)

- **AI & API Latency**: Thời gian xử lý của Cloud Function Callable `social_addFriend` và `social_nudgeFriend` <= 1.0 giây trên mạng 4G.
- **Tốc độ khung hình (FPS)**: Cuộn danh sách Leaderboard đạt >= 55 FPS ổn định, không giật lag.
- **Rò rỉ bộ nhớ (Memory Leak)**: Đóng mở màn hình Leaderboard 15 lần liên tục, bộ nhớ RAM ổn định, không giữ lại listener rác của StreamProvider.
- **Zero-Tolerance**: Tuyệt đối không chấp nhận test giả xanh (`expect(true, isTrue)`). Mọi logic đều phải có assert dữ liệu thật.

---

> 🟢 **Gate 3 Sign-Off**: Kịch bản kiểm thử chi tiết đã hoàn tất, độ phủ 100% User Stories. Sẵn sàng bàn giao cho Gate 4 (Dev) thực thi.
