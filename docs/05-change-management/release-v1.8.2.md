# Release Notes — AstroBite v1.8.2 (AstroBot Mascot Navigation & Celestial Dock Polish)

- **Release Version**: `v1.8.2`
- **Release Date**: 2026-09-24
- **Sprint**: Sprint 09 Refinement
- **Quality Gates**: All 8 Gates Cleared (Gate 0 -> Gate 7)
- **Sign-off By**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)

---

## 🌟 What's New in v1.8.2

### 1. AstroBot Mascot Navigation (`assets/images/astrobot_mascot.png`)
- Thay thế icon thông thường của tab AstroCoach trên thanh điều hướng dưới bằng hình ảnh Mascot chính thức AstroBot.
- Tích hợp hiệu ứng vầng hào quang phát sáng (Cosmic Halo & Cyan Dock Glow) khi tab AstroCoach đang hoạt động hoặc hover.

### 2. Celestial Dock Glassmorphism & Ergonomic Polish
- Nâng cấp `CelestialBottomNav` với thanh dock kính mờ `BackdropFilter` (sigma 20/20), viền phát sáng gradient `cyan/blue`.
- Nút bấm Camera AI Scanner trung tâm nổi bật với hiệu ứng bóng đổ vũ trụ đa lớp và xúc giác phản hồi.
- Đảm bảo chuẩn công thái học di động 44x44pt touch target cho tất cả 4 tabs và FAB trung tâm.

### 3. AstroCoach Local Resilience & Offline Fallback
- Cơ chế tự động sao lưu và khôi phục lịch sử chat cục bộ an toàn khi offline hoặc mạng gián đoạn.
- Đảm bảo độ trễ AI SLA <= 2.5s và khả năng chuyển đổi linh hoạt giữa các model Gemini Flash.

---

## 🧪 Test Suite & Code Quality Metrics

- **Total Test Cases**: 168/168 PASSED (100% Pass Rate, 0 failed, 0 skipped).
- **Static Analysis**: `flutter analyze` 0 issues, 0 warnings.
- **Dependencies**: 0 unneeded dependencies added (Tuân thủ triệt để Ponytail).
