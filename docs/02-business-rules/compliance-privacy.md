# Chính Sách Bảo Mật & Tuân Thủ Dữ Liệu Sức Khỏe (Compliance & Privacy)

## 1. Nguyên Tắc Thu Thập Dữ Liệu
AstroBite chỉ thu thập các chỉ số thể chất tối thiểu cần thiết để tính toán BMR/TDEE:
- Chiều cao, cân nặng hiện tại, cân nặng mục tiêu, tuổi, giới tính sinh học, mức độ vận động.
- Không thu thập lịch sử bệnh án nhạy cảm (HIV, tâm thần, v.v.).

---

## 2. Lưu Trữ & Mã Hóa Dữ Liệu
- **Dữ liệu người dùng**: Lưu trữ trên Cloud Firestore với Security Rules nghiêm ngặt: Mỗi người dùng chỉ có quyền đọc/ghi dữ liệu của chính tài khoản của mình (`request.auth.uid == resource.data.userId`).
- **Hình ảnh quét**: Ảnh chụp món ăn được upload lên Firebase Storage dưới đường dẫn an toàn `users/{uid}/scans/{scanId}.jpg` và có thể tùy chọn xóa tự động sau 30 ngày để tiết kiệm dung lượng.
- **Bảo mật kênh truyền**: 100% dữ liệu truyền qua giao thức HTTPS / TLS 1.3 và được bảo vệ bởi Firebase App Check để chống giả mạo thiết bị (DeviceCheck trên iOS, Play Integrity trên Android).

---

## 3. Quyền Của Người Dùng (User Rights)
- **Quyền xuất dữ liệu**: Người dùng có thể yêu cầu xuất toàn bộ lịch sử ăn uống dạng JSON/CSV.
- **Quyền lãng quên (Right to be Forgotten)**: Cung cấp tính năng "Xóa tài khoản và dữ liệu" trong màn hình Profile. Khi kích hoạt, toàn bộ dữ liệu trên Firestore, Storage và Authentication sẽ bị xóa vĩnh viễn trong vòng 24 giờ.
