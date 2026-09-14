# Testcases Quét Ảnh Qua Camera & Thư Viện (Scanner Camera & Gallery)

- **Module**: `02-food-scanner-ai`
- **Tham chiếu BA**: `docs/03-prd-features/02-food-scanner-ai/prd-food-scanner.md`

---

### TC-SCAN-001: Cấp quyền Camera và chụp ảnh món ăn
- **Preconditions**: Ứng dụng mới cài đặt, chưa từng cấp quyền Camera.
- **Test Steps**:
  1. Nhấn vào biểu tượng quét Camera (Central FAB) trên thanh Bottom Navigation.
  2. Hệ điều hành hiển thị Popup xin quyền truy cập Camera.
  3. Chọn "Cho phép khi dùng ứng dụng" (Allow while using app).
  4. Hướng camera vào đĩa thức ăn và nhấn nút Chụp ảnh (Shutter button).
- **Expected Result**:
  - Camera preview mở mượt mà, khung ngắm phát sáng màu xanh Celestial `#1A73E8`.
  - Nhấn nút chụp: Có rung nhẹ (Haptic feedback), ảnh đóng băng và hiển thị hiệu ứng quét laser.
- **Severity**: S1 (Blocker)

---

### TC-SCAN-002: Người dùng từ chối cấp quyền Camera
- **Test Steps**:
  1. Nhấn nút quét Camera.
  2. Khi popup xin quyền hiển thị, chọn "Từ chối" (Don't allow).
- **Expected Result**:
  - Ứng dụng không bị crash.
  - Hiển thị màn hình hướng dẫn thân thiện: *"AstroBite cần quyền truy cập máy ảnh để quét món ăn. Bạn có thể cấp quyền trong Cài đặt hoặc chọn ảnh từ thư viện."* kèm nút mở Cài đặt hệ thống.
- **Severity**: S2 (Critical)
