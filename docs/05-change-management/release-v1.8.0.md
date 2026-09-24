# Release Notes — AstroBite v1.8.0 (AstroCoach AI Intelligence v2 Cockpit)

- **Release Version**: `v1.8.0`
- **Release Date**: 2026-09-24
- **Sprint**: Sprint 09 (AstroCoach AI Intelligence v2 & Conversational Nutritionist)
- **Quality Gates**: All 8 Gates Cleared (Gate 0 -> Gate 7)
- **Sign-off By**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)

---

## 🌟 What's New in v1.8.0

### 1. Context Header Strip (`US-01`)
- Bảng điều khiển dinh dưỡng thời gian thực ghim đầu trang trò chuyện:
  - Hiển thị ngân sách calo còn lại hôm nay (`Còn lại: X kcal`).
  - 3 thanh tiến trình chất đa lượng chuẩn xác theo token màu bất biến:
    - 🔵 **Carbs**: Electric Blue `#1A73E8`
    - 🟡 **Protein**: Gold `#FFD700`
    - 🩷 **Fat**: Hot Pink `#FF69B4`
  - Huy hiệu cảnh báo thông minh: Tự động cảnh báo khi lượng Natri nạp vượt ngưỡng an toàn (>= 1,500mg/2,000mg) hoặc gợi ý bù đạm khi thiếu hụt protein.

### 2. Holographic Bento Meal Card & 1-Tap Log (`US-02`, `US-03`, `US-04`)
- Khả năng bóc tách khối dữ liệu có cấu trúc ` ```astrobite-meal ` song song với fallback thẻ ẩn.
- Hiển thị trực quan thẻ Bento Holographic viền phát sáng Cyan/Blue huyền ảo:
  - Tên món ăn, huy hiệu calo vàng Gold.
  - Phân bổ 4 chất đa/vi lượng: Đạm, Đường bột, Chất béo, Natri.
  - Chi tiết thành phần nguyên liệu định lượng.
  - **Nút 1-Tap Log (1-Chạm Ghi Nhật Ký)**: Nạp món ăn trực tiếp vào nhật ký trong một chạm, tự động cập nhật Context Header Strip và chuyển trạng thái sang `✓ Đã ghi vào nhật ký` ngăn bấm trùng lặp.

### 3. Dynamic Time-of-Day Quick Action Chips (`US-05`)
- Dải chip gợi ý thông minh tự động thay đổi theo 4 khung giờ thực tế:
  - **Sáng (5-11h)**: Bữa sáng giàu năng lượng, Cà phê & Calo, Bữa sáng giàu đạm.
  - **Trưa (11-14h)**: Gợi ý bữa trưa cân bằng, Bữa trưa giàu đạm, Món ít dầu mỡ.
  - **Chiều (14-17h)**: Ăn xế dưới 150 kcal, Nhắc nhở uống nước, Năng lượng trước tập.
  - **Tối (17-24h)**: Gợi ý bữa tối giàu protein, Phân tích natri hôm nay, Phục hồi cơ sau tập.

### 4. Celestial Dark UI Cockpit Polish
- Đồng bộ chuẩn xác 100% từ thiết kế Google Stitch MCP (`projects/4740603587325816667`, Screen `3328fde738f24013a34124bfdecd7484`).
- AppBar với Avatar phát sáng Aura và đèn tín hiệu `Online • Real-time Nutritionist`.
- Trạng thái suy nghĩ Cosmic Pulse nhẹ nhàng, thư thái.

---

## 🧪 Test Suite & Code Quality Metrics

- **Total Test Cases**: 163/163 PASSED (100% Pass Rate, 0 skipped, 0 fake test).
- **Static Analysis**: `flutter analyze` 0 issues, 0 warnings.
- **AI Latency SLA**: <= 2.5s (Tiếp cận Approach C Regex Block Extraction không phát sinh round-trip kép).
- **Dependencies**: 0 external packages added (Tuân thủ triệt để kỷ luật Ponytail).
