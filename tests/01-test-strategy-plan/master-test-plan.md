# Kế Hoạch Kiểm Thử Tổng Thể (Master Test Plan)

## 1. Mục Tiêu & Phạm Vi Kiểm Thử
- **Mục tiêu**: Đảm bảo ứng dụng AstroBite đạt độ tin cậy cao, không có lỗi nghiêm trọng (Blocker/Critical) trước khi đưa lên Google Play Store và Apple App Store; đảm bảo tốc độ phản hồi AI mượt mà và tính toán calo chuẩn xác 100%.
- **Phạm vi kiểm thử (In-Scope)**:
  - Kiểm thử chức năng toàn bộ 5 module (Auth, Scanner AI, Tracker, Analytics, Profile).
  - Kiểm thử luồng tích hợp Firebase (Auth, Firestore persistence, Storage upload, App Check).
  - Kiểm thử khả năng ngoại tuyến (Offline sync) và gián đoạn mạng.
  - Kiểm thử trải nghiệm giao diện người dùng Celestial Dark UI trên đa kích thước màn hình.
- **Ngoài phạm vi (Out-of-Scope)**:
  - Tải chịu lực đồng thời (Load test) trên 100,000 users ảo (do Firebase tự động scale).

---

## 2. Tiêu Chí Nghiệm Thu (Entry & Exit Criteria)
- **Tiêu chí bắt đầu test (Entry Criteria)**:
  - Code FE đã vượt qua toàn bộ unit test (`flutter test` đạt 100% pass).
  - Bản build APK/AAB và IPA test qua TestFlight/Firebase App Distribution thành công.
- **Tiêu chí kết thúc test & Release (Exit Criteria)**:
  - 100% Testcase P1 (Blocker/Critical) được thực thi và Pass.
  - Không còn lỗi mức Blocker hoặc Critical còn mở (Open).
  - Số lỗi Major còn tồn đọng <= 2 (phải có workaround và được PO chấp thuận bằng văn bản).
  - Biên bản nghiệm thu (Release Sign-off) được ký duyệt bởi QA Lead và PO.
