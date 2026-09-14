# Kiểm Thử Tính Nhất Quán Giao Diện (UI/UX Celestial Consistency Testing)

Tài liệu này dùng để QA đối soát giao diện thực tế của ứng dụng với Design System được quy định trong `DESIGN.md` và `lib/core/theme/app_colors.dart`.

## 1. Bảng Kiểm Tra Màu Sắc Dinh Dưỡng Bất Biến

| Thành phần kiểm tra | Màu sắc bắt buộc | Mã Hex | Kết quả đối soát (Pass/Fail) |
| :--- | :--- | :--- | :---: |
| **Chỉ số Carbohydrates** | Primary Blue | `#1A73E8` | [ ] Pass |
| **Chỉ số Fat (Chất béo)** | Secondary Pink | `#FF69B4` | [ ] Pass |
| **Chỉ số Protein (Đạm)** | Tertiary Gold | `#FFD700` | [ ] Pass |
| **Màu nền ứng dụng (Background)** | Midnight Surface | `#0A192F` | [ ] Pass |
| **Màu thẻ (Card Container)** | Surface Container | `#112240` | [ ] Pass |

---

## 2. Tiêu Chuẩn Công Thái Học & Tương Tác
- **Touch Targets**: 100% các nút bấm, icon bấm, chip chọn phải có kích thước vùng chạm tối thiểu **44x44pt**.
- **Hiệu ứng Kính Mờ (GlassCard)**: Đảm bảo có `BackdropFilter` làm mờ 20px, viền sáng nhẹ, không bị răng cưa trên các máy Android tầm thấp.
- **Material 3 Tinting**: Kiểm tra AppBar và Card tuyệt đối không bị ám tím mặc định của M3 (`surfaceTintColor: Colors.transparent`).
