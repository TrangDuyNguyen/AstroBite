# Release Notes — AstroBite v1.9.0 (Custom Recipes & Meal Planning Architecture)

- **Release Version**: `v1.9.0`
- **Release Date**: 2026-09-25
- **Sprint**: Sprint 10 (Custom Recipes & Meal Planning Architecture)
- **Quality Gates**: All 8 Gates Cleared (Gate 0 -> Gate 7)
- **Sign-off By**: Sub-Agent Product Owner (PO) & Sub-Agent Project Manager (PM)

---

## 🌟 What's New in v1.9.0

### 1. Interactive Recipe Builder (`US-01`)
- Cho phép người dùng kết hợp linh hoạt nhiều nguyên liệu thành một công thức món ăn hoàn chỉnh.
- **Tự động tổng hợp dinh dưỡng tức thì (O(N) in-memory calculation)**:
  - Tự động cộng gộp Calo và bộ 3 chất đa lượng chính xác đến từng 0.1g.
  - Ánh xạ đúng 100% token màu dinh dưỡng Celestial bất biến:
    - 🔵 **Carbs**: Electric Blue `#1A73E8`
    - 🟡 **Protein**: Gold `#FFD700`
    - 🩷 **Fat**: Hot Pink `#FF69B4`
- Bổ sung thanh tóm tắt vĩ mô cố định (Sticky Macro Summary Bar) với độ trễ phản hồi `< 1ms`.
- Hỗ trợ thêm nhanh nguyên liệu từ cơ sở dữ liệu mẫu hoặc nhập tùy chỉnh số gram.

### 2. Dynamic Portion Scaler (`US-02`)
- Cơ chế co giãn khẩu phần động trực quan với các mức chọn tiện lợi: `0.5x`, `1x`, `2x`, `4x`.
- Tự động nhân/chia trọng lượng nguyên liệu và cập nhật ngay lập tức các chỉ số Calo, Carbs, Protein, Fat tương ứng mà vẫn bảo toàn tỷ lệ macro gốc.

### 3. Weekly Meal Planner Calendar (`US-03`)
- Bảng lịch kế hoạch dinh dưỡng 7 ngày trực quan (Weekly Day Strip) dễ dàng chuyển đổi ngày.
- Phân chia rõ ràng 4 khung giờ bữa ăn: **Sáng (Breakfast)**, **Trưa (Lunch)**, **Tối (Dinner)**, **Phụ (Snack)**.
- Gắn công thức cá nhân đã lưu hoặc món ăn bất kỳ vào từng bữa với thẻ hiển thị đẹp mắt mang phong cách Celestial Dark UI.

### 4. 1-Tap Log to Diary (`US-04`)
- Tính năng 1 chạm nạp ngay bữa ăn đã lên kế hoạch vào nhật ký chính thức (`FoodLog`).
- Chuyển đổi trạng thái tức thì sang `✓ Đã ăn` (isLogged = true) chống thao tác bấm lặp.
- Tự động đồng bộ hóa với hệ thống cache ngoại tuyến và Firestore Cloud.

---

## 🧪 Test Suite & Code Quality Metrics

- **Total Test Cases**: **183 / 183 PASSED (100% Pass Rate)**, 0 skipped, 0 fake test.
  - Feature-specific tests: **18 / 18 PASSED** (Domain serialization + Controller state + Portion Scaler).
- **Static Analysis**: `flutter analyze` **0 issues, 0 warnings**.
- **Performance & Latency**: Macro aggregation `< 1ms`, 60 FPS scrolling mượt mà.
- **Dependencies**: 0 external packages added (Tuân thủ triệt để kỷ luật Ponytail).
