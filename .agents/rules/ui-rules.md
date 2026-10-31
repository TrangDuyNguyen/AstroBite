# UI & Design System Rules — AstroBite

## 🚫 NGHIÊM CẤM DÙNG EMOJI THAY THẾ ICON (NO EMOJIS AS ICONS)

1. **Quy định tuyệt đối**:
   - **KHÔNG ĐƯỢC PHÉP** sử dụng emoji Unicode ký tự (ví dụ: 🍎, 🥗, ☕, 🥑, ☀️, ☁️, 🍳, 🥩, 🥪, 🥣, 📊, ⚙️, ✕, ✓ trong chuỗi text) để làm biểu tượng, icon, nút bấm, chip bữa ăn hay trạng thái UI.
   - Mọi icon hiển thị trên giao diện **BẮT BUỘC** phải là:
     - `Icon(Icons.<name_rounded>, ...)` từ Material Icons chuẩn của Flutter.
     - Hoặc Vector SVG chuẩn.
     - Hoặc các 3D Clay Components từ `lib/shared/ui_kit/` (`Clay3DIcon`, `Clay3DCookbook`, `ClayMorphIcon`, `ClayMealChip`, `ClayIconButton`...).

2. **Lý do kỹ thuật & thiết kế**:
   - Emoji Unicode render khác nhau hoàn toàn giữa các thiết bị (iOS vs Android vs Web), màu sắc không đồng bộ với bảng màu Claymorphic (`AppColors`).
   - Gây lỗi lệch baseline, vỡ padding hoặc tràn viền (overflow) khi người dùng đổi cài đặt text scaling (1.5x, 2.0x).
   - Vi phạm chuẩn Accessibility (screen reader đọc thô tên ký tự emoji thay vì semantics).

