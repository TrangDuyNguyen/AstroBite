# Kiểm Thử Khả Năng Ngoại Tuyến & Mạng Chập Chờn (Offline & Network Testing)

## 1. Kiểm Thử Ngoại Tuyến (Offline Persistence)
- **Kịch bản**:
  1. Người dùng đang ở Dashboard, bật chế độ máy bay (Airplane Mode).
  2. Người dùng mở xem lịch sử các bữa ăn của 3 ngày trước.
  3. Người dùng nhập tay một món ăn mới (Manual Entry) vào Bữa Tối.
  4. Tắt chế độ máy bay, kết nối lại Internet.
- **Kết quả mong đợi**:
  - Lịch sử vẫn đọc được hoàn toàn từ Firestore local cache.
  - Món ăn nhập tay được ghi nhận cục bộ ngay lập tức và tự động đồng bộ (sync) lên Firestore cloud ngay khi có mạng mà không làm mất dữ liệu.

---

## 2. Kiểm Thử Mạng Yếu (Throttled Network 3G)
- **Kịch bản**: Chụp ảnh quét món ăn khi mạng bị bóp băng thông (Latency 500ms, tốc độ 128 kbps).
- **Kết quả mong đợi**:
  - Sau 15 giây chờ, nếu chưa có phản hồi từ Gemini API, ứng dụng không bị treo màn hình mà hiển thị dialog: *"Kết nối mạng không ổn định. Bạn có muốn thử lại hay lưu ảnh để quét sau?"*.
