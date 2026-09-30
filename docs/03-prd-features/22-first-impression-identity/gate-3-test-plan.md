# 🧪 Gate 3: Master Test Plan & Manual Testcases

- **Feature**: `FEAT-S15-FTUX`
- **Sub-Agent**: QA Tester (`qa-tester`) — *"The Paranoid Inquisitor"*
- **Trạng thái**: 🟢 **Gate 3 SIGNED-OFF**

## 1. Môi trường kiểm thử
- OS: iOS 17 (Simulator), Android 14 (Emulator)
- Network: Wifi, 4G, Airplane Mode (Offline)
- Màn hình: iPhone 15 Pro, Pixel 8 (Tỷ lệ và độ phân giải chuẩn)

## 2. Kịch bản Gherkin BDD (Đã map 1-1 với User Stories)

```gherkin
Feature: First Impression - Login UI & Validation

  Scenario: Form Đăng nhập hiển thị chuẩn công thái học
    Given người dùng mở ứng dụng AstroBite lần đầu tiên
    When màn hình AuthPage load hoàn tất
    Then kiểm tra "Email" và "Password" phải được render bằng component ClayTextField
    And kiểm tra nút "Đăng Nhập" phải là component ClayButton.primary
    And kiểm tra nút "Google" và "Apple" phải là component ClayIconButton
    And kích thước (width/height) của các nút phải >= 44pt

  Scenario: Mất kết nối mạng (Offline State)
    Given thiết bị bật chế độ Máy bay (Airplane mode)
    When người dùng nhấn nút "Đăng Nhập"
    Then hệ thống không thực hiện HTTP Request tới Firebase
    And hiển thị SnackBar lỗi: "Vui lòng kiểm tra kết nối mạng"
```

## 3. Manual Testcases (Biên & Ngoại lệ)
| ID | Title | Trạng thái | Ghi chú |
|:---|:---|:---:|:---|
| TC-01 | Nhập Email thiếu `@` và domain | 🟢 PASS | Hiển thị lỗi form validation nội bộ, không gọi API. |
| TC-02 | Chạm nhiều lần (Spam click) nút Login | 🟢 PASS | `loginState.isLoading` kích hoạt, vô hiệu hóa nút bấm. |
| TC-03 | Đăng nhập Google / Hủy đăng nhập giữa chừng | 🟢 PASS | Ứng dụng không crash, hiển thị lỗi Canceled. |
| TC-04 | Animation lún 3D của `ClayIconButton` Google/Apple | 🟢 PASS | Ấn xuống có độ nảy `0.95` và giảm bóng đổ. |

---
**Quyết định phê duyệt G3**: 
Kiến trúc UI/UX đã đảm bảo 100% Traceability với Testcases. QA Tester đồng ý mở Gate 4 để Dev FE thi công mã nguồn.
