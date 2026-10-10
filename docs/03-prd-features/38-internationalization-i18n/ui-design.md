# UI/UX Specification: Language Selection Experience — Sprint 31

- **Feature**: `FEAT-S31-I18N-FOUNDATION`
- **Tác giả**: Sub-Agent UI/UX Designer (*The Celestial Aesthetic Purist*)
- **Duyệt bởi**: Sub-Agent PO, BA & Tech Lead

---

## 1. Vị Trí Giao Diện & Điều Hướng
- **Vị trí tích hợp**: Màn hình Profile (`lib/features/profile/presentation/pages/profile_page.dart`) -> Nhóm cài đặt (Settings Tile).
- **Thành phần**: `ClayCard` hoặc `ListTile` thiết kế theo chuẩn Claymorphic:
  - Icon: `SolarIconsOutline.global` hoặc `SolarIconsOutline.translation`
  - Tiêu đề: `Ngôn ngữ` / `Language`
  - Phụ đề (Subtitle): Tùy chọn hiện tại (`Theo hệ thống` / `Tiếng Việt` / `English`)
  - Khi bấm: Mở `ClaySheet` / Dialog chọn 1 trong 3 tùy chọn với radio checkmark tactile squash.

---

## 2. 5 Trạng Thái UI Bắt Buộc
1. **Default State**: Hiển thị Tile cài đặt với nhãn ngôn ngữ đang kích hoạt.
2. **Sheet Open State**: Modal bottom sheet Claymorphic bo góc 24pt, hiển thị 3 lựa chọn kèm cờ / icon tương ứng.
3. **Selected State**: Item đang chọn có viền `AppColors.primary` (`#1CB0F6`) và biểu tượng tích xanh.
4. **Offline State**: Chuyển đổi ngôn ngữ hoạt động 100% offline, không cần internet.
5. **Transition State**: Thay đổi ngôn ngữ tức thì (< 100ms), không nhấp nháy màn hình.
