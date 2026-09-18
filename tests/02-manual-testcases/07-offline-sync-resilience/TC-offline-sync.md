# Bộ Testcase Kiểm Thử Thủ Công: Ngoại Tuyến & Tự Động Đồng Bộ (Offline-First Resilience)

- **Module**: `07-offline-sync-resilience` (`FEAT-07` / `EPIC-09`)
- **Tài liệu tham chiếu BA**: `docs/03-prd-features/07-offline-sync-resilience/prd-offline-sync.md` & `user-stories.md`
- **Tài liệu tham chiếu UI/UX**: `docs/03-prd-features/07-offline-sync-resilience/ui-ux-design-spec.md`
- **Tác giả**: Sub-Agent QA Tester (`qa-tester`)
- **Kỹ thuật áp dụng**: Phân vùng tương đương (EP), State Transition, Network Simulation, Idempotency Verification

---

## 1. Ma Trận Truy Vết Kiểm Thử (Traceability Matrix)

| Mã Testcase | Mã User Story | Kỹ Thuật ISTQB | Mục Tiêu Kiểm Thử | Mức Độ Nghiêm Trọng |
| :--- | :--- | :---: | :--- | :---: |
| **`TC-OFF-001`** | `US-OFF-01` | Happy Path / Offline | Khởi chạy ứng dụng khi bật chế độ Máy bay (Airplane Mode) < 150ms | **S1 (Blocker)** |
| **`TC-OFF-002`** | `US-OFF-01` | State Transition | Chuyển ngày trên lịch để xem lịch sử nhật ký cũ lúc offline | **S2 (Critical)** |
| **`TC-OFF-003`** | `US-OFF-02` | Happy Path / CRUD | Nhập món ăn thủ công khi offline, lưu Local Cache < 50ms | **S1 (Blocker)** |
| **`TC-OFF-004`** | `US-OFF-03` | Network State | Tự động đồng bộ ngầm khi kết nối Internet phục hồi (Auto-Sync) | **S1 (Blocker)** |
| **`TC-OFF-005`** | `US-OFF-03` | Error Guessing | Mạng chập chờn rớt kết nối giữa chừng (Network Flakiness & Backoff) | **S2 (Critical)** |
| **`TC-OFF-006`** | `US-OFF-04` | State Fallback | Bấm Camera Scanner AI lúc ngoại tuyến, điều hướng sang nhập tay | **S2 (Critical)** |
| **`TC-OFF-007`** | `US-OFF-05` | Idempotency | Đồng bộ lặp lại nhiều lần không sinh duplicate bản ghi trên Firestore | **S1 (Blocker)** |

---

## 2. Chi Tiết Các Kịch Bản Kiểm Thử (Test Details)

### TC-OFF-001: Khởi động app ở chế độ Máy bay và hiển thị dữ liệu Local Cache
- **Tiền điều kiện**: Thiết bị đã từng đăng nhập và có dữ liệu của 3 ngày gần nhất. Bật chế độ Máy bay (Airplane Mode ON).
- **Các bước thực hiện**:
  1. Mở ứng dụng AstroBite từ màn hình chính điện thoại.
  2. Đo thời gian hiển thị Dashboard.
- **Kết quả mong đợi**:
  - Thời gian khởi động và render dữ liệu < 150ms.
  - Vòng cung CalorieProgressArc và danh sách các bữa ăn hiển thị đầy đủ.
  - Thanh `CelestialOfflineBanner` trượt xuống nhẹ nhàng ở đỉnh: *"Chế độ ngoại tuyến — Dữ liệu đang được lưu an toàn trên máy"*.
  - Không có popup báo lỗi mạng hay vòng quay vô tận.

---

### TC-OFF-002: Thêm món ăn thủ công khi ngoại tuyến (Offline Manual Entry)
- **Tiền điều kiện**: Thiết bị đang ngắt kết nối mạng hoàn toàn.
- **Các bước thực hiện**:
  1. Mở màn hình Thêm món thủ công (Manual Entry).
  2. Nhập: "Bún chả", 250g, 550 kcal, Carbs 65g, Protein 25g, Fat 20g.
  3. Bấm nút "Lưu Bữa Ăn".
- **Kết quả mong đợi**:
  - Bản ghi được lưu vào Local Hive Box trong thời gian < 50ms.
  - Dashboard cập nhật thêm 550 kcal vào tổng calo ngày ngay tức khắc.
  - Trên thẻ "Bún chả" xuất hiện huy hiệu đám mây cam `pending_sync`.

---

### TC-OFF-003: Phục hồi kết nối mạng và tự động đồng bộ ngầm (Auto-Sync)
- **Tiền điều kiện**: Có 2 bản ghi đang mang huy hiệu `pending_sync` trên Dashboard.
- **Các bước thực hiện**:
  1. Tắt chế độ Máy bay, kết nối lại Wifi hoặc 4G.
  2. Quan sát màn hình Dashboard trong 5 giây mà không chạm vào màn hình.
- **Kết quả mong đợi**:
  - Sau khoảng 2 giây, ứng dụng phát hiện mạng phục hồi và kích hoạt SyncEngine ngầm.
  - 2 bản ghi được đẩy lên Firestore thành công.
  - Huy hiệu đám mây trên thẻ chuyển sang màu xanh `synced` trong 2 giây rồi tự động biến mất.
  - Thanh cảnh báo ngoại tuyến ở đỉnh trượt lên ẩn đi.
  - SnackBar xuất hiện: *"Đã đồng bộ thành công 2 bữa ăn lên đám mây."*

---

### TC-OFF-004: Chống trùng lặp dữ liệu khi Retry đồng bộ (Idempotency Test)
- **Tiền điều kiện**: Bản ghi món ăn đã được lưu vào Firestore nhưng client cố tình trigger lại lệnh đồng bộ cho cùng mã `id` (UUID).
- **Các bước thực hiện**:
  1. Kiểm tra số lượng tài liệu trên Firestore subcollection `meal_logs`.
  2. Kích hoạt retry đồng bộ lại bản ghi đó.
- **Kết quả mong đợi**:
  - Firestore thực hiện lệnh `set(..., merge: true)` trên Document ID cũ.
  - Số lượng bản ghi trên Firestore không thay đổi (không sinh ra bản ghi thứ 2).
  - Tổng calo hàng ngày không bị cộng dồn gấp đôi.

---

### TC-OFF-005: Xử lý khi bấm Camera Scanner AI lúc ngoại tuyến
- **Tiền điều kiện**: Thiết bị đang ngoại tuyến.
- **Các bước thực hiện**:
  1. Bấm vào nút Camera Scanner tròn ở giữa thanh Bottom Navigation.
- **Kết quả mong đợi**:
  - Hộp thoại `OfflineAIScannerAlert` xuất hiện: *"Tính năng Quét AI Cần Kết Nối Mạng"*.
  - Có nút [Nhập Thủ Công Ngay] và [Để Sau].
  - Bấm [Nhập Thủ Công Ngay] chuyển hướng ngay sang màn hình Manual Entry. Không làm treo app.
