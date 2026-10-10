# Thông Cáo Phát Hành Phiên Bản (Release Notes) — v3.5.0
## Sprint 25: Camera Scanner Pipeline Modular Clean Architecture

- **Mã phát hành**: `RELEASE-v3.5.0`
- **Ngày phát hành**: 2026-10-10
- **Hội đồng phê chuẩn Gate 7**:
  - Sub-Agent Product Owner (`product-owner` — *The Strategic Tyrant*): Phê duyệt phát hành thương mại ✅
  - Sub-Agent Tech Lead (`tech-lead` — *The Pragmatic System Architect*): Phê duyệt chất lượng kỹ thuật & CI/CD ✅
  - Sub-Agent Project Manager (`project-manager` — *The Clockwork Disciplinarian*): Xác nhận đóng Sprint 25 (13/13 SP) ✅
  - Sub-Agent Security Auditor (`security-auditor` — *The Zero-Trust Sentinel*): Phê chuẩn an ninh MASVS v2.0 ✅

---

### 1. Tóm Tắt Giá Trị Phát Hành (Executive Summary)

Phiên bản `v3.5.0` chính thức hoàn tất cuộc đại phẫu thuật mô-đun hóa cho phân hệ cốt lõi **Camera & Gemini Vision AI Scanner**, giải quyết dứt điểm 2 "God Files" cuối cùng của tính năng quét món ăn:
1. `camera_page.dart` (965 dòng ➔ **266 dòng**, giảm **72.4%**).
2. `scanning_viewfinder.dart` (616 dòng ➔ **256 dòng**, giảm **58.4%**).
3. **Toàn bộ phân hệ Scanner sạch 100%**, không còn bất kỳ file nào vi phạm cảnh báo (>350 dòng) hay chặn cứng (>500 dòng).

---

### 2. Các Thành Phần Trích Xuất & Tái Cấu Trúc

| Component mới | Số dòng | Trách nhiệm kiến trúc |
| :--- | :---: | :--- |
| `camera_page.dart` | 266 | Màn hình chính điều phối vòng đời camera, cảm ứng xúc giác và trạng thái quét. |
| `scanning_viewfinder.dart` | 256 | Khung ngắm máy ảnh 60 FPS tích hợp dynamic laser scanning và AI HUD feedback. |
| `camera_dock_controls.dart` | 305 | Bảng điều khiển cảm ứng đáy máy ảnh với nút chụp 3D 78pt và nút thư viện / nhập tay. |
| `camera_error_dialog_handler.dart` | 161 | Xử lý tập trung các cảnh báo API key, giới hạn quota, lỗi kết nối và phân luồng retry. |
| `camera_scanning_tips_sheet.dart` | 167 | Bottom sheet hướng dẫn người dùng góc chụp và ánh sáng tối ưu cho Gemini AI. |
| `camera_app_bar.dart` | 109 | Thanh tiêu đề Celestial AppBar điều khiển flash và hiển thị trạng thái Gemini Vision. |
| `camera_quota_badge.dart` | 66 | Huy hiệu hiển thị hạn mức quét trong ngày (10 lượt miễn phí) với dynamic styling. |
| `viewfinder_hud_painters.dart` | 172 | CustomPainter vẽ khung ngắm góc nhọn, reticle, crosshair và lưới bố cục. |
| `viewfinder_laser_scanner.dart` | 48 | Hiệu ứng tia quét laser di chuyển mượt mà 60 FPS. |
| `viewfinder_detected_tag.dart` | 145 | Tag hiển thị tên món và độ chính xác nổi 3D khi AI phát hiện món ăn. |

---

### 3. Chất Lượng Phần Mềm & Độ Ổn Định

- **Unit & Widget Tests**: **322/322 tests PASS (100%)**
- **Scanner Subsystem Tests**: **34/34 tests PASS (100%)**
- **Phân tích tĩnh**: `flutter analyze` **0 issues**
- **Hiệu năng & Tài nguyên**: 60 FPS render, 0 rò rỉ RAM (0 memory leak).
