# Đặc Tả Giao Diện (UI/UX Screen Specs): Food Scanner AI

## 1. Danh Sách Màn Hình & Thành Phần
- `SCR-06`: CameraScannerScreen (`/scanner`)
- `COMP-01`: ScanningViewfinder (Khung ngắm camera 4 góc phát sáng Celestial Blue `#1A73E8`)
- `COMP-02`: LaserScannerLine (Thanh laser quét lướt lên xuống tạo chuyển động)
- `SCR-07`: ScanResultBottomSheet (Modal trượt lên hiển thị kết quả phân tích AI)
- `COMP-03`: PortionAdjustmentSlider (Thanh trượt gram tương tác xúc giác haptic feedback)

---

## 2. Quy Chuẩn Đồ Họa & Trạng Thái
- **Quy chuẩn màu dinh dưỡng (Bất biến)**:
  - Carbs: `#1A73E8`
  - Fat: `#FF69B4`
  - Protein: `#FFD700`
- **Skeleton Shimmer**: Hiệu ứng chuyển động màu nền vũ trụ từ `#112240` sang `#1E3A8A` khi đang chờ Gemini API xử lý.
- **Nút Chụp**: Nút tròn đường kính 72pt, viền đôi phát sáng màu xanh Primary, có phản hồi rung (Haptic feedback) khi bấm.
