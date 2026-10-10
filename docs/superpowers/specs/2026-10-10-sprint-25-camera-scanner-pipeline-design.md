# Sprint 25 Architectural Spec & ADR-031: Camera Scanner Pipeline Refactoring

> **Tác giả**: Sub-Agent Tech Lead (*The Pragmatic System Architect*)  
> **Dự án**: AstroBite Mobile App  
> **Epic**: `EPIC-REF-04` / `FEAT-S25-CAMERA-SCANNER`  
> **Phiên bản mục tiêu**: `v3.5.0`  
> **Thời điểm**: 2026-10-10  
> **Trạng thái**: 🟢 **APPROVED (Gate 0 Feasibility Sign-off)**

---

## 1. Bối Cảnh & Vấn Đề (Context & Problem Statement)

Phân hệ Scanner hiện còn 2 tệp vi phạm chặn cứng Hard Cap 500 dòng theo quy chuẩn AGENTS.md:
1. `lib/features/scanner/presentation/pages/camera_page.dart` (**964 dòng** — File dài nhất AstroBite sau Sprint 24).
   - Ôm đồm: CameraController lifecycle, ImagePicker fallback, Torch flash toggle, Xử lý lỗi API/Quota/NotFood dialogs, Modal Sheet hướng dẫn chụp ảnh, Bottom dock bar với Shutter button 3D và các nút tactile gallery/nhập tay.
2. `lib/features/scanner/presentation/widgets/scanning_viewfinder.dart` (**616 dòng**).
   - Ôm đồm: 3 AnimationControllers song song, 5 CustomPainters HUD vi mô (corner brackets, reticle, crosshair, grid, laser line), và floating holographic dish tag.

Mục tiêu Sprint 25: Giải phẫu dứt điểm 2 tệp trên, đưa cả 2 về sâu dưới Warning Threshold **< 350 dòng** (kỳ vọng `< 250 dòng`), bảo toàn 100% logic chụp ảnh, animation mượt mà 60 FPS và toàn bộ 34 test cases hiện có của phân hệ Scanner.

---

## 2. Quyết Định Kiến Trúc (Architecture Decision Record - ADR-031)

### Cấu Trúc Bóc Tách:
```
lib/features/scanner/presentation/
├── pages/
│   ├── camera_page.dart                   # Rút gọn còn ~250 dòng (< 350 dòng)
│   └── scan_review_page.dart              # Đã tối ưu ở Sprint 23 (340 dòng)
└── widgets/
    ├── camera_dock_controls.dart          # Bottom dock & 3D Tactile Shutter (< 170 dòng)
    ├── camera_quota_badge.dart            # Quota cảnh báo lượt quét hôm nay (< 80 dòng)
    ├── camera_scanning_tips_sheet.dart    # Modal sheet mẹo chụp ảnh chuẩn AI (< 110 dòng)
    ├── camera_error_dialog_handler.dart   # Bộ xử lý dialog lỗi & API Key (< 130 dòng)
    ├── scanning_viewfinder.dart           # Rút gọn còn ~180 dòng (< 200 dòng)
    ├── viewfinder_hud_painters.dart       # 4 CustomPainters cho AR HUD (< 240 dòng)
    ├── viewfinder_laser_scanner.dart      # Tia laser scanner animated line (< 70 dòng)
    └── viewfinder_detected_tag.dart       # Holographic AI Verified Tag (< 100 dòng)
```

---

## 3. SLA & Tiêu Chuẩn Kỹ Thuật

- Zero new dependencies (Tuân thủ nghiêm ngặt triết lý Ponytail).
- Camera lifecycle an toàn: tự động dispose khi inactive/background, khởi tạo lại khi resume, 0 rò rỉ RAM (0 memory leak).
- `flutter analyze`: 0 issues found.
- 100% test suite pass (322 tests hiện có tiếp tục xanh).
