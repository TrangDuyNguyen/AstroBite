# PRD: Sprint 25 — Camera Scanner Pipeline Modular Clean Architecture

> **Tác giả**: Sub-Agent Business Analyst (*The Pedantic Logician*)  
> **Người duyệt**: Sub-Agent Product Owner (*The Strategic Tyrant*)  
> **Trạng thái**: 🟢 **APPROVED (Gate 1 Sign-Off)**

---

## 1. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (Success Metrics)

- **Mục tiêu**: Giải phẫu 2 "God Files" cuối cùng của phân hệ Scanner (`CameraPage` và `ScanningViewfinder`), đưa toàn bộ phân hệ Scanner đạt 100% chuẩn Ponytail Clean Code.
- **Metrics đo lường**:
  - `camera_page.dart`: Giảm từ 964 dòng xuống $< 280$ dòng (giảm $\ge 70\%$).
  - `scanning_viewfinder.dart`: Giảm từ 616 dòng xuống $< 200$ dòng (giảm $\ge 65\%$).
  - Tỷ lệ lỗi gãy chức năng (Regression Rate): 0%.
  - Quản lý bộ nhớ camera: 0 rò rỉ RAM (0 memory leak).

---

## 2. Đặc Tả Chức Năng BDD Scenarios

### US-01: Chụp Ảnh Quét Món Ăn Bằng Nút Shutter 3D Tactile
- **Given**: Người dùng đang ở màn hình CameraPage với camera đang hoạt động.
- **When**: Nhấn nút Shutter 3D lớn ở dock điều khiển đáy.
- **Then**: Kích hoạt rung xúc giác `HapticFeedback.heavyImpact()`, chụp ảnh, hiển thị màn quét và chuyển đến ScanReviewPage khi AI phân tích thành công.

### US-02: Bật/Tắt Đèn Flash & Xem Mẹo Quét
- **Given**: Người dùng chụp trong môi trường thiếu sáng.
- **When**: Nhấn nút Flash trên AppBar.
- **Then**: Đèn pin thiết bị bật/tắt tức thời, icon đổi màu cam hổ phách.
- **When**: Nhấn nút Help trên AppBar.
- **Then**: Modal bottom sheet `CameraScanningTipsSheet` hiển thị 3 mẹo vàng chuẩn AI.

### US-03: Viewfinder AR Holographic & Laser Scan
- **Given**: Người dùng đang quét thức ăn (`isScanning = true`).
- **When**: Viewfinder hiển thị.
- **Then**: Vòng tròn Holographic Reticle xoay tròn 16s, tia laser di chuyển quét dọc màn hình 2.2s và badge "ĐANG ĐỊNH VỊ MÓN ĂN" chớp sáng nhịp nhàng.
