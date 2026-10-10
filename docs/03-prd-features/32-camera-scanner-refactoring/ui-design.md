# UI/UX Design Blueprint: Sprint 25 — Camera Scanner Pipeline Components

> **Tác giả**: Sub-Agent UI/UX Designer (*The Celestial Aesthetic Purist*)  
> **Người duyệt**: Sub-Agent BA & PO  
> **Trạng thái**: 🟢 **APPROVED (Gate 2 Sign-Off)**

---

## 1. Hệ Thống Thành Phần Giao Diện (Design System Tokens)

- **Lưới căn chỉnh**: Tuân thủ nghiêm ngặt 4pt spacing grid (`AppValues.spacing8`, `AppValues.spacing12`, `AppValues.spacing16`, `AppValues.spacing24`).
- **Nút Chụp 3D Tactile Shutter**:
  - Kích thước: Đường kính `78pt`, viền trắng 3pt, đổ bóng kép (Bevel depth `4.5pt` xanh dương `#0284C7` + Ambient glow blur `16`).
  - Hiệu ứng cơ học khi bấm: Thu nhỏ tỉ lệ `scale(0.92)`, trượt xuống `translate(0, 3.0)` với haptic medium impact.
- **Nút Điều Khiển Đáy Ceramic Clay**:
  - Kích thước: `54pt`, viền gốm `#E2DDD5`, bóng tactile bevel depth `3.5pt`.
  - Icon Gallery: `Icons.photo_library_rounded` (Màu primary).
  - Icon Nhập Tay: `Icons.edit_note_rounded` (Màu tertiary).
- **Viewfinder AR HUD Hologram**:
  - 4 Góc viền bo tròn: Stroke 3.5, Duolingo Sky Blue `#1CB0F6`.
  - Reticle trung tâm: Quay 360 độ trong 16 giây.
  - Tia Laser Scanner: Quét dọc 2.2 giây có viền phát sáng gradient.
