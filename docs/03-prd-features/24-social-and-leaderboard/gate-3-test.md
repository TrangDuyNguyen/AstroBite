# Master Test Plan: Gate 3 - Social & Leaderboard

- **Người thực hiện**: Sub-Agent QA Tester ("The Paranoid Inquisitor")
- **Tính năng**: Social Sharing & Astro Leaderboard
- **Trạng thái**: 🟢 Approved

## 1. Mục Tiêu Kiểm Thử (Test Scope)
Đảm bảo tính năng Render thẻ Widget thành ảnh hoạt động ổn định trên mọi độ phân giải màn hình mà không bị tràn RAM. Đảm bảo Bảng xếp hạng hiển thị đúng thứ hạng sau khi Cloud Functions chạy.

## 2. Các Kịch Bản Bắt Buộc (Manual & Automated Edge Cases)

### TCK-01: Render Share Card (Happy Path & Performance)
- **Hành động**: Nhấn nút "Share" trên màn hình `AnalyticsPage`.
- **Kỳ vọng**: 
  - Ảnh xuất ra phải đúng lưới 1080x1080 hoặc 1080x1920.
  - Vòng cung tiến độ (CalorieProgressArc) phải khớp số liệu thật.
  - Phải kích hoạt Native Share Sheet (iOS/Android).
  - Memory không tăng vọt quá 50MB trong quá trình thao tác `RepaintBoundary`.

### TCK-02: Quyền Lưu Trữ (Permission Denial)
- **Hành động**: Khi app xin quyền ghi file (Storage) vào `path_provider`, cố tình bấm "Từ chối" (Deny).
- **Kỳ vọng**:
  - App KHÔNG BỊ CRASH.
  - Phải hiện thông báo dạng Snackbar: "AstroBite cần quyền lưu trữ để tạo ảnh báo cáo của bạn."

### TCK-03: Astro Leaderboard Logic (Cloud Functions Sync)
- **Hành động**: Mở tab Cộng Đồng sau khi Cloud Functions vừa chạy ghi file `weekly_top_100`.
- **Kỳ vọng**:
  - Hiển thị TOP 3 với màu thẻ đúng quy chuẩn (Vàng/Bạc/Đồng).
  - Tốc độ tải (Load time) < 200ms do chỉ đọc 1 document.
  - Nếu user không nằm trong danh sách TOP, vẫn phải hiển thị thứ hạng riêng của user ở đáy màn hình dính (Sticky Bottom Bar).

### TCK-04: Thêm Bạn Sai Định Dạng (Boundary Value Analysis)
- **Hành động**: Nhập ID bạn bè là `A!@12` (có ký tự đặc biệt) hoặc `123` (ngắn hơn 6 ký tự).
- **Kỳ vọng**: 
  - Regex phải chặn ngay ở UI, báo lỗi "Astro ID chỉ bao gồm 6 chữ cái và số."

## 3. Khuyến nghị Kỹ thuật cho Dev (Gate 4)
- **Dev FE**: Chú ý việc cấp `GlobalKey` cho `RepaintBoundary` không được nằm sâu trong ListView bị recycle (nếu bị recycle, không thể `.currentContext` được).
- **Dev Native**: Quản lý tốt file ảnh xuất ra tại `getTemporaryDirectory()`. Sau khi share xong phải có logic xóa file rác để không làm phình dung lượng app.
