# PRD: Cơ Chế Ngoại Tuyến & Tự Động Đồng Bộ (Offline-First Local Cache & Sync)

- **Mã tính năng**: `FEAT-07`
- **Mã Epic liên kết**: `EPIC-09` (Offline-First Resilience)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Trạng thái**: 🟢 **Approved (Gate 1 Sign-off Đã Phê Duyệt)**
- **Mục tiêu phiên bản**: `v1.1.0` (Sprint 02)
- **Đối chiếu UI/UX**: `docs/03-prd-features/07-offline-sync-resilience/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `tests/02-manual-testcases/07-offline-sync-resilience/` & `tests/03-bdd-gherkin-scenarios/offline_sync_resilience.feature` (Gate 3)
- **Đối chiếu FE**: `lib/features/tracker/` & `lib/core/` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- Người dùng thường xuyên ăn uống tại các địa điểm có sóng di động yếu hoặc hoàn toàn không có internet:
  - Tầng hầm các trung tâm thương mại, nhà hàng dưới lòng đất.
  - Trên máy bay, tàu xe vùng sâu vùng xa, đi du lịch nước ngoài chưa kịp mua SIM/eSIM.
  - Khu vực mạng wifi chập chờn, rớt gói tin liên tục.
- Ở phiên bản `v1.0.0`, ứng dụng phụ thuộc chặt chẽ vào kết nối trực tiếp với Cloud Firestore. Khi không có mạng:
  1. Người dùng không thể mở nhật ký các ngày trước để đối chiếu.
  2. Không thể thêm món ăn thủ công (Manual Entry) hoặc lưu công thức cá nhân.
  3. Màn hình báo lỗi mất mạng đỏ rực gây ức chế, làm gián đoạn chuỗi ghi chép calo liên tục (hỏng thói quen sử dụng).

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Khả dụng ngoại tuyến 100% (Offline Availability)**: Cho phép xem lịch sử 30 ngày gần nhất, tra cứu danh bạ thực phẩm đã lưu, và ghi nhật ký ăn uống thủ công hoàn toàn offline.
- **Tốc độ tải từ Local Cache**: Mở màn hình Dashboard/Diary và render dữ liệu dưới 150ms.
- **Tỷ lệ đồng bộ thành công (Sync Reliability)**: Đạt >= 99.5% các bản ghi chờ (pending sync) được đẩy lên Cloud Firestore an toàn ngay khi phục hồi kết nối, không duplicate, không mất dữ liệu.
- **Tính trơn tru (Zero App Blocking)**: Giao diện không bao giờ bị đơ (freeze/jank), tiến trình đồng bộ diễn ra ngầm (Background Sync Notifier).

---

## 2. Đối Tượng Người Dùng (Target Personas)
1. **Người Thường Xuyên Di Chuyển (Frequent Travelers & Commuters)**: Thường xuyên di chuyển trên máy bay, tàu điện ngầm, hoặc đến các vùng ngoại ô sóng 4G chập chờn.
2. **Dân Văn Phòng Ăn Tại Tầng Hầm (Food Court Diners)**: Thói quen ăn trưa tại các Food Court dưới tầng hầm TTTM nơi sóng điện thoại yếu.
3. **Người Dùng Kỷ Luật Cao (Strict Calorie Trackers)**: Không muốn bỏ lỡ bất kỳ bữa ăn nào; muốn ghi ngay lập tức sau khi ăn xong mà không cần bận tâm mạng có ổn định hay không.

---

## 3. Luồng Nghiệp Vụ & Cơ Chế Đồng Bộ (Sync Flow & Architecture)

```
                       [Người dùng thao tác: Ghi món ăn thủ công]
                                          │
                                          ▼
                      ┌────────────────────────────────────────┐
                      │ Tạo UUID định danh (Client-Generated)   │
                      │ Gán sync_status = "pending_sync"       │
                      │ Gán last_modified_at = DateTime.now()  │
                      └───────────────────┬────────────────────┘
                                          │
                                          ▼
             [Ghi tức thời vào Local Storage (Hive Box) < 50ms]
                                          │
                                          ├────────────────────────┐
                                          ▼                        ▼
                               [Cập nhật UI Reactive]    [Kiểm tra Connectivity]
                               (Dashboard cập nhật ngay)           │
                                                                   ▼
                                                       ┌───────────────────────┐
                                                       │ Có Internet kết nối?  │
                                                       └───────────┬───────────┘
                                                  Có               │             Không
                                            ┌──────────────────────┴────────────────┐
                                            ▼                                       ▼
                             [Đẩy Firestore ngay lập tức]             [Đưa vào Hàng Đợi (Queue)]
                                            │                                       │
                                            ▼                                       ▼
                             [Gán sync_status = "synced"]             [Hiển thị Offline Badge]
                                                                                    │
                                                                                    ▼
                                                                     [Lắng nghe khi mạng phục hồi]
                                                                                    │
                                                                                    ▼
                                                                     [Kích hoạt Background Sync]
                                                                                    │
                                                                                    ▼
                                                                     [Đẩy hàng đợi theo thứ tự FIFO]
                                                                                    │
                                                                                    ▼
                                                                     [Gán "synced" & Ẩn Offline Badge]
```

---

## 4. Yêu Cầu Chức Năng Chi Tiết (Functional Requirements)

### `FR-OFF-01`: Lưu Trữ Bộ Nhớ Đệm Cục Bộ (Local Caching Engine)
- Sử dụng cơ chế lưu trữ cục bộ hiệu năng cao (Hive Box hoặc Key-Value Store):
  - `offline_meal_logs`: Lưu trữ toàn bộ các bữa ăn trong vòng 30 ngày gần nhất của người dùng.
  - `offline_user_profile`: Lưu trữ thông tin mục tiêu calo, BMR, TDEE và cấu hình cá nhân.
  - `sync_queue`: Danh sách các ID bản ghi đang ở trạng thái `pending_sync`.
- Khi người dùng đăng nhập lần đầu hoặc khi online, hệ thống tự động đồng bộ một bản sao lưu xuống Local Cache.

### `FR-OFF-02`: Thao Tác CRUD Bữa Ăn Ngoại Tuyến (Offline CRUD Operations)
- Cho phép người dùng:
  - Thêm mới bữa ăn (Manual Entry, Quick Add Calorie).
  - Chỉnh sửa gram, tên món, loại bữa ăn của bản ghi đã có.
  - Xóa bản ghi bữa ăn.
- Mọi thay đổi đều được ghi ngay lập tức vào Local Cache với trạng thái:
  - Thêm mới: `sync_status = "pending_sync"`.
  - Cập nhật: Cập nhật dữ liệu cache + đánh dấu `sync_status = "pending_sync"` + cập nhật `last_modified_at`.
  - Xóa: Đánh dấu cờ `is_deleted = true` trong cache + thêm vào hàng đợi xóa Firestore.

### `FR-OFF-03`: Định Danh Bất Biến Phía Client (Client-Side UUID Idempotency)
- Mọi bản ghi bữa ăn mới đều được gán một mã định danh UUID v4 (`id`) ngay tại thời điểm tạo trên thiết bị.
- Khi đẩy lên Cloud Firestore, sử dụng phương thức `set(..., SetOptions(merge: true))` với chính Document ID này.
- **Mục đích**: Bảo đảm tính bất biến (Idempotent) — dù tiến trình retry có đẩy lại bản ghi nhiều lần do mạng chập chờn, Firestore cũng không bao giờ sinh ra 2 bản ghi trùng lặp.

### `FR-OFF-04`: Lắng Nghe Kết Nối & Tự Động Đồng Bộ (Connectivity Listener & Auto-Sync)
- Tích hợp dịch vụ lắng nghe trạng thái mạng (Connectivity Stream: Wifi, Cellular, None):
  - Khi phát hiện chuyển từ `None` sang `Wifi/Cellular`: Kích hoạt `SyncEngine` sau 2 giây (để mạng ổn định).
  - Quét hàng đợi `sync_queue` và gửi các bản ghi `pending_sync` lên Firestore theo từng batch tối đa 20 bản ghi.
  - Khi Firestore xác nhận lưu thành công: Đổi cờ trong cache sang `sync_status = "synced"`, xóa khỏi hàng đợi.
  - Nếu gặp lỗi mạng giữa chừng: Áp dụng cơ chế Exponential Backoff (thử lại sau 5s, 15s, 60s), không gọi dồn dập gây hao pin.

### `FR-OFF-05`: Giải Quyết Xung Đột Dữ Liệu (Conflict Resolution)
- Áp dụng nguyên tắc chuẩn **Last-Write-Wins (LWW)** dựa trên trường `last_modified_at`.
- Nếu bản ghi trên thiết bị có `last_modified_at` mới hơn bản ghi hiện có trên Firestore, bản ghi client sẽ ghi đè. Ngược lại, bản ghi từ server sẽ cập nhật xuống cache.

### `FR-OFF-06`: Chỉ Báo Ngoại Tuyến & Trạng Thái Đồng Bộ (Offline Status UI Indicators)
- Khi thiết bị ngoại tuyến:
  - Hiển thị thanh trạng thái tinh tế (Celestial Offline Banner) ở đỉnh màn hình: *"Đang ngoại tuyến. Bữa ăn sẽ tự động đồng bộ khi có kết nối."*
  - Trên các thẻ bữa ăn chưa đồng bộ: Hiển thị một icon đám mây nhỏ kèm chấm cam (Cloud Pending Icon).
- Khi đồng bộ thành công:
  - Icon chuyển sang đám mây tích xanh (Cloud Synced Icon) trong 2 giây rồi ẩn đi.
  - Tự động ẩn Offline Banner.

### `FR-OFF-07`: Xử Lý Riêng Biệt Cho Tính Năng AI Vision Khi Ngoại Tuyến
- Vì Gemini 2.0 Flash Vision là mô hình đám mây bắt buộc có mạng:
  - Khi người dùng nhấn nút Quét AI lúc đang offline:
  - Hiển thị thông báo giải thích rõ ràng: *"Tính năng Quét AI cần Internet để phân tích hình ảnh. Bạn có thể chụp ảnh và lưu vào máy, hoặc nhập món thủ công ngay bây giờ."*
  - Cung cấp nút chuyển nhanh sang màn hình Nhập thủ công (Manual Entry).

---

## 5. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

- **Hiệu năng & Thời gian đáp ứng (Performance)**:
  - Thời gian ghi vào Local Cache: <= 50ms.
  - Khởi động app và hiển thị dữ liệu lịch sử khi offline: <= 150ms.
- **Giới hạn dung lượng bộ nhớ (Storage Budget)**:
  - Tổng dung lượng Local Cache cho 30 ngày nhật ký văn bản không vượt quá 10MB.
- **Tiêu thụ pin (Battery Efficiency)**:
  - Không chạy tiến trình polling liên tục; chỉ kích hoạt khi có sự kiện thay đổi kết nối mạng từ hệ điều hành.
- **Bảo mật dữ liệu cục bộ (Data Security)**:
  - Toàn bộ dữ liệu trong Local Cache được phân tách nghiêm ngặt theo `user_id`.
  - Khi người dùng đăng xuất (Logout), hệ thống xóa toàn bộ dữ liệu nhạy cảm trong Local Cache để bảo vệ quyền riêng tư.

---

## 6. Phê Duyệt Của Product Owner (Gate 1 Sign-Off)
- **PO**: AstroBite Strategic Product Owner Sub-Agent
- **Trạng thái**: 🟢 **APPROVED (ĐÃ PHÊ DUYỆT CHÍNH THỨC)**
- **Ngày phê duyệt**: 2026-09-18
- **Ý kiến chỉ đạo**: 
  - Đánh giá nghiệp vụ: Kiến trúc Offline-First với UUID Idempotency và Last-Write-Wins rất chặt chẽ, giải quyết triệt để vấn đề mất sóng trong thang máy/tầng hầm.
  - Phù hợp hoàn hảo với triết lý Ponytail: Tận dụng Key-Value Box nhẹ nhàng, không lạm dụng background daemon phức tạp.
  - Chuyển giao ngay cho Sub-Agent `ui-ux-designer` để triển khai Gate 2 (`TSK-OFF-02`: Banner ngoại tuyến & Huy hiệu sync).

