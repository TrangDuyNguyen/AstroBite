# User Stories & Acceptance Criteria: Offline-First Local Cache & Sync

- **Mã tính năng**: `FEAT-07`
- **Mã Epic liên kết**: `EPIC-09`
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Chuẩn kiểm thử**: Gherkin BDD (`Given - When - Then`)
- **Trạng thái**: 🟡 In Review (Gate 1)

---

## US-OFF-01: Xem Nhật Ký & Biểu Đồ Calo Khi Hoàn Toàn Ngoại Tuyến
- **As a**: Người dùng AstroBite đang ngồi trên máy bay hoặc tàu điện ngầm
- **I want to**: Mở ứng dụng AstroBite để xem nhật ký các bữa ăn hôm nay và tuần này
- **So that**: Tôi có thể theo dõi lượng calo đã nạp mà không bị màn hình trắng hay thông báo lỗi mạng chặn lại.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Mở ứng dụng khi thiết bị ở chế độ Máy bay (Airplane Mode)
- **Given**: Thiết bị của tôi đang ngắt kết nối Wifi và Dữ liệu di động (Airplane mode ON)
- **When**: Tôi khởi chạy ứng dụng AstroBite
- **Then**: Màn hình chính Dashboard hiển thị trong thời gian dưới 150ms từ Local Cache
- **And**: Vòng cung calo (CalorieProgressArc) hiển thị đầy đủ tổng calo đã nạp trong ngày
- **And**: Danh sách các bữa ăn (Sáng, Trưa, Tối) hiển thị bình thường với đầy đủ món ăn và chỉ số Macro
- **And**: Một thanh thông báo màu hổ phách dịu (Celestial Amber Banner) xuất hiện ở đỉnh: *"Chế độ Ngoại tuyến — Dữ liệu đã lưu trên thiết bị"*.

#### Scenario 2: Chuyển ngày trên lịch để xem nhật ký các ngày trước
- **Given**: Ứng dụng đang hoạt động ở chế độ ngoại tuyến
- **When**: Tôi bấm chọn ngày hôm qua hoặc 3 ngày trước trên thanh chọn ngày (Date Strip)
- **Then**: Nhật ký ăn uống của ngày đó lập tức xuất hiện mượt mà từ bộ nhớ đệm
- **And**: Không có vòng quay loading vô tận hay popup lỗi mạng.

---

## US-OFF-02: Ghi Bữa Ăn Thủ Công Khi Ngoại Tuyến (Offline Manual Entry)
- **As a**: Người dùng đang ăn trưa tại tầng hầm trung tâm thương mại không có sóng
- **I want to**: Ghi nhanh món "Bún chả" với định lượng 250g vào bữa trưa
- **So that**: Tôi ghi nhớ bữa ăn ngay lập tức mà không sợ quên khi lên mặt đất.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Thêm món ăn thủ công thành công khi không có mạng
- **Given**: Điện thoại của tôi đang mất sóng mạng hoàn toàn
- **When**: Tôi vào màn hình Thêm Bữa Ăn (Manual Entry)
- **And**: Nhập tên "Bún chả", trọng lượng 250g, Calo: 550 kcal, Carbs: 65g, Protein: 25g, Fat: 20g
- **And**: Bấm nút "Lưu Bữa Ăn"
- **Then**: Hệ thống tạo bản ghi mới với UUID duy nhất và trạng thái `sync_status = "pending_sync"`
- **And**: Bản ghi được lưu ngay vào Local Cache trong vòng < 50ms
- **And**: Màn hình đóng lại, Dashboard lập tức cộng thêm 550 kcal vào tổng calo trong ngày
- **And**: Trên thẻ "Bún chả" hiển thị một huy hiệu nhỏ đám mây chấm cam biểu thị đang chờ đồng bộ.

#### Scenario 2: Chỉnh sửa khẩu phần món ăn khi ngoại tuyến
- **Given**: Món "Bún chả" đã lưu ngoại tuyến
- **When**: Tôi bấm chỉnh sửa khẩu phần lên 300g (Calo tăng lên 660 kcal) và bấm Lưu
- **Then**: Dữ liệu trong Local Cache được cập nhật, `last_modified_at` được gán thời gian mới nhất
- **And**: Thẻ món ăn và tổng calo trên Dashboard cập nhật 660 kcal ngay tức khắc.

---

## US-OFF-03: Tự Động Đồng Bộ Dữ Liệu Khi Mạng Phục Hồi (Auto Background Sync)
- **As a**: Người dùng AstroBite
- **I want to**: Dữ liệu tôi ghi chép lúc offline tự động đẩy lên Cloud Firestore ngay khi điện thoại bắt được sóng 4G/Wifi
- **So that**: Tôi không cần bấm nút đồng bộ thủ công và dữ liệu được an toàn trên đám mây.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Phục hồi kết nối mạng và đồng bộ tự động thành công (Happy Path)
- **Given**: Tôi có 2 bản ghi bữa ăn với trạng thái `pending_sync` trong Local Cache
- **When**: Điện thoại bắt được sóng Wifi hoặc bật lại 4G
- **Then**: Ứng dụng phát hiện trạng thái kết nối mạng phục hồi
- **And**: Sau 2 giây, tiến trình SyncEngine ngầm tự động gửi 2 bản ghi lên Firestore
- **And**: Khi Firestore phản hồi thành công, trạng thái trong cache chuyển thành `sync_status = "synced"`
- **And**: Huy hiệu đám mây chấm cam trên 2 thẻ bữa ăn biến mất
- **And**: Một thông báo SnackBar màu xanh Celestial xuất hiện ngắn gọn: *"Đã đồng bộ thành công 2 bữa ăn lên đám mây."*
- **And**: Thanh cảnh báo ngoại tuyến tự động biến mất.

#### Scenario 2: Mạng chập chờn hoặc rớt kết nối giữa chừng (Network Flakiness)
- **Given**: Có 5 bản ghi đang chờ đồng bộ
- **When**: Mạng kết nối lại nhưng bị rớt gói tin sau khi mới gửi thành công 2 bản ghi
- **Then**: 2 bản ghi đầu được đánh dấu `synced`
- **And**: 3 bản ghi còn lại giữ nguyên trạng thái `pending_sync` trong hàng đợi
- **And**: Hệ thống áp dụng cơ chế Exponential Backoff chờ 5 giây rồi mới thử lại khi mạng ổn định
- **And**: Tuyệt đối không gây treo ứng dụng hay mất dữ liệu của 3 bản ghi còn lại.

---

## US-OFF-04: Xử Lý Tính Năng Quét AI Khi Ngoại Tuyến (AI Vision Offline Handling)
- **As a**: Người dùng cố gắng quét ảnh món ăn khi đang không có mạng
- **I want to**: Nhận được thông báo hướng dẫn rõ ràng thay vì ứng dụng bị xoay vô tận
- **So that**: Tôi biết rằng tính năng AI cần mạng và chọn cách ghi chép thay thế.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Người dùng bấm nút Quét AI khi đang ngoại tuyến
- **Given**: Điện thoại đang ở chế độ ngoại tuyến
- **When**: Tôi bấm vào nút Quét nổi bật (FAB Camera)
- **Then**: Ứng dụng hiển thị thông báo Celestial Alert:
  - Tiêu đề: *"Tính Năng Quét AI Cần Internet"*
  - Nội dung: *"Mô hình Gemini AI cần kết nối mạng để phân tích dinh dưỡng từ ảnh. Bạn có muốn nhập món thủ công ngay bây giờ không?"*
  - Nút chính: `"Nhập Thủ Công Ngay"`
  - Nút phụ: `"Để Sau"`
- **When**: Tôi chọn `"Nhập Thủ Công Ngay"`
- **Then**: Hệ thống điều hướng ngay tới màn hình Manual Entry để tôi ghi nhận bữa ăn.

---

## US-OFF-05: Chống Trùng Lặp & Bảo Vệ Toàn Vẹn Dữ Liệu (Idempotency & Conflict)
- **As a**: Hệ thống AstroBite
- **I want to**: Bảo đảm mỗi bữa ăn chỉ có đúng một bản ghi duy nhất trên Firestore dù có thử đồng bộ lại nhiều lần
- **So that**: Số calo hàng ngày của người dùng không bị tính thừa hoặc sai lệch.

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Retry đồng bộ không sinh ra bản ghi nhân bản (Idempotent Sync)
- **Given**: Bản ghi món ăn đã được gửi tới Firestore thành công nhưng phản hồi ACK bị mất do rớt mạng đúng giây cuối
- **When**: Khi có mạng lại, SyncEngine gửi lại bản ghi đó lên Firestore với cùng mã `id` (UUID)
- **Then**: Firestore thực hiện lệnh ghi đè (upsert) trên chính Document ID đó thay vì tạo tài liệu mới
- **And**: Số lượng bản ghi trên Firestore và tổng calo trong ngày của người dùng không bị nhân đôi.
