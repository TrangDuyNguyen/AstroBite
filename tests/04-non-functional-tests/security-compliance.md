# Kiểm Thử Bảo Mật & Xác Thực (Security Compliance Testing)

## 1. Kiểm Thử Firebase App Check
- **Mục tiêu**: Đảm bảo tất cả các request tới Cloud Firestore và Gemini Cloud Function chỉ được chấp thuận từ bản build ứng dụng chính thức đã được ký chữ ký số hợp lệ.
- **Kịch bản kiểm tra**:
  - Gửi request giả lập qua Postman hoặc Curl mà không có App Check Token hợp lệ -> Firebase bắt buộc phải trả về mã lỗi `403 Permission Denied`.
  - Trên thiết bị Android đã root hoặc iOS đã jailbreak -> App Check kích hoạt cảnh báo rủi ro tính toàn vẹn (Integrity risk).

---

## 2. Kiểm Thử Phân Quyền Firestore (Security Rules)
- **Kiểm tra truy cập chéo (Cross-user Access)**:
  - Tài khoản A đăng nhập, cố gắng đọc hoặc chỉnh sửa dữ liệu của tài khoản B: `users/{uid_B}/meal_logs/...`
  - Kết quả mong đợi: Firestore ném ngoại lệ `FirebaseException(permission-denied)`.
