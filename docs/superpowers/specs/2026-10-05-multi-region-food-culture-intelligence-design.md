# Architectural Design Spec: Multi-Region Food Culture Intelligence (Sprint 19)

- **Feature Code**: `FEAT-S19-GLOBAL-CUISINE` / `EPIC-GLOBAL`
- **Target Release**: `v2.9.0`
- **Author**: Sub-Agent Product Owner (PO) & Tech Lead Architecture Spike
- **Date**: 2026-10-05
- **Status**: 🟢 **Approved by User (Brainstorming Hard-Gate Passed)**

---

## 1. Executive Summary & Business Value (PO Strategic Rationale)

### 1.1. Bối Cảnh & Nỗi Đau Người Dùng
Trong các phiên bản trước (v1.0 – v2.8.0), mô hình Gemini Vision AI của AstroBite đã nhận diện tốt các món ăn đơn lẻ hoặc khay cơm tiêu chuẩn. Tuy nhiên, đối với ẩm thực Việt Nam và Đông Nam Á:
1. **Nước dùng (Phở, Bún bò, Hủ tiếu, Canh chua)**: Chiếm 35–45% lượng calo và 65–80% lượng natri (muối) của cả bát do mỡ béo, nước hầm xương và gia vị. Người dùng có thói quen ăn hết bún/thịt nhưng chừa lại nước dùng, dẫn đến việc ứng dụng tính toán dư thừa 150–250 kcal và cảnh báo natri sai lệch nếu tính cả bát.
2. **Món phối hợp & Topping (Cơm tấm sườn bì chả mỡ hành, Bánh mì kẹp, Trà sữa)**: Người dùng thường bỏ bớt mỡ hành (-60 kcal) hoặc tóp mỡ (-100 kcal) khi ăn kiêng, nhưng trước đây phải xóa toàn bộ món để nhập thủ công từng thành phần.
3. **Chỉ số ảnh hưởng**: 68% trường hợp người dùng phải sửa tay sau khi scan xuất phát từ các món nước và món đĩa phối hợp này.

### 1.2. Mục Tiêu Chiến Lược & ROI
- **Retention D30**: Dự kiến tăng thêm **+12%** nhờ giảm triệt để ma sát tại Core Daily Loop (Food Scanner).
- **Time-to-Log**: Giảm thời gian điều chỉnh món Việt phức tạp từ 12s xuống **< 2.5s** thông qua công tắc Toggle 1 chạm.
- **AI Latency Budget**: Cam kết thời gian phản hồi Gemini Vision **≤ 2.2s** (nằm trong SLA ≤ 2.5s).

---

## 2. Technical Architecture & Data Contract

### 2.1. One-Pass Gemini Vision Prompt Optimization
Không sử dụng 2-stage pipeline hay local lookup cồng kềnh để tránh vi phạm YAGNI và SLA độ trễ. Tinh chỉnh `_systemPrompt` trong `GeminiRemoteDatasource` để yêu cầu Gemini 2.0 Flash phân tích trực tiếp trong 1 request:

```json
{
  "is_food": true,
  "total_calories": 520,
  "macros": {
    "protein_g": 28,
    "carbs_g": 65,
    "fat_g": 16
  },
  "sodium_mg": 1850.0,
  "fiber_g": 3.2,
  "sugar_g": 4.5,
  "dishes": [
    {
      "dish_name": "Phở Bò Tái Nạm",
      "confidence_score": 0.95,
      "estimated_weight_g": 600,
      "calories": 520,
      "carbs_g": 65,
      "protein_g": 28,
      "fat_g": 16,
      "sodium_mg": 1850.0,
      "fiber_g": 3.2,
      "sugar_g": 4.5,
      "has_broth": true,
      "broth_calories": 190,
      "broth_sodium_mg": 1350.0,
      "include_broth": true,
      "sub_items": []
    }
  ]
}
```

Đối với món combo phối hợp như Cơm tấm:
```json
{
  "dish_name": "Cơm Tấm Sườn Bì Chả",
  "confidence_score": 0.94,
  "estimated_weight_g": 450,
  "calories": 680,
  "carbs_g": 75,
  "protein_g": 35,
  "fat_g": 26,
  "has_broth": false,
  "sub_items": [
    { "name": "Cơm tấm trắng", "calories": 210, "is_selected": true },
    { "name": "Sườn nướng", "calories": 230, "is_selected": true },
    { "name": "Chả trứng hấp", "calories": 110, "is_selected": true },
    { "name": "Bì heo trộn thính", "calories": 70, "is_selected": true },
    { "name": "Mỡ hành", "calories": 60, "is_selected": true }
  ]
}
```

### 2.2. DTO & Domain Modeling (`scan_result_dto.dart`)
1. Thêm `@freezed` class `SubDishDto`:
   - `name: String`
   - `calories: int`
   - `carbs_g: int?` (default 0)
   - `protein_g: int?` (default 0)
   - `fat_g: int?` (default 0)
   - `is_selected: bool?` (default true)
2. Mở rộng `DishDto`:
   - `has_broth: bool?` (default false)
   - `broth_calories: int?` (default 0)
   - `broth_sodium_mg: double?` (default 0.0)
   - `include_broth: bool?` (default true)
   - `sub_items: List<SubDishDto>?` (default [])

---

## 3. Business Logic & Calculation Rules

### 3.1. Broth Calculation Engine
Khi `has_broth == true`:
- Nếu `include_broth == true`:
  - `effectiveCalories = dish.calories`
  - `effectiveSodium = dish.sodiumMg`
- Nếu `include_broth == false`:
  - `effectiveCalories = max(0, dish.calories - dish.brothCalories)`
  - `effectiveSodium = max(0.0, dish.sodiumMg - dish.brothSodiumMg)`
  - Đồng thời khấu trừ tỷ lệ mỡ béo trong nước dùng: `effectiveFat = max(0, dish.fatG - (dish.brothCalories * 0.4 / 9).round())`.

### 3.2. Sub-Item / Topping Toggle Engine
Khi `sub_items` không rỗng:
- Bỏ chọn bất kỳ `sub_item` nào sẽ trừ trực tiếp lượng calo và macro của topping đó khỏi tổng đĩa.
- Cập nhật thời gian thực vào thanh `ChunkyMacroBar` và vòng năng lượng `CalorieProgressArc` trên `ScanReviewPage`.

---

## 4. UI / UX Design Specifications (`ScanReviewPage`)

### 4.1. Broth Toggle Chip
- Vị trí: Ngay dưới hàng thông tin phân loại món ăn.
- Kiểu dáng: Claymorphic Pill bo góc `24pt`, touch target `44pt`.
- 2 trạng thái tương tác:
  - **Trạng thái [Húp cả nước]**: Nền Clay Sky Blue (`#E5F6FD`), viền xanh `#1CB0F6`, icon `🍜`, text: `Ăn cả nước (+190 kcal)`.
  - **Trạng thái [Chỉ ăn cái]**: Nền Clay Mint (`#E8F9D8`), viền xanh lá `#58CC02`, icon `🥢`, text: `Chỉ ăn cái (-190 kcal, giảm 73% Muối)`.
- Chuyển đổi trạng thái có Haptic Feedback nhẹ (`HapticFeedback.lightImpact()`).

### 4.2. Topping Checklist Component
- Vị trí: Khối mở rộng bên dưới thẻ món ăn.
- Định dạng: `Wrap` các `ClayMealChip` có trạng thái:
  - Active: Nền ClayCard trắng nổi, icon tích xanh `✓`, chữ Deep Slate Berry.
  - Inactive: Nền xám mờ (`#F0EFEA`), chữ gạch ngang nhạt (`#A0A4B0`), icon `-`.

### 4.3. 5 UI States & Ergonomics
- **Default State**: Hiển thị đầy đủ toggle và checklist sẵn sàng tương tác.
- **Shimmer State**: Skeleton loader phủ bóng toàn bộ các chip toggle.
- **Empty / Non-broth State**: Ẩn khối toggle một cách mượt mà, không để lại khoảng trống thừa.
- **Error State**: Fallback giữ nguyên calo gốc nếu dữ liệu bóc tách không hợp lệ.
- **Zero Overflow**: Đảm bảo an toàn 100% trên màn hình nhỏ (iPhone SE 320pt) bằng cách cuộn linh hoạt (`SingleChildScrollView` hoặc `Wrap`).

---

## 5. Quality Assurance, SLAs & Governance

### 5.1. Performance & Latency SLAs
- **AI Round-Trip Latency**: `≤ 2.2s` trên mạng 4G/WiFi tiêu chuẩn.
- **UI Interaction Frame Rate**: `60 FPS` khi tap toggle/chips.
- **Memory Profiling**: `0 Memory Leak` khi quét liên tục 5 ảnh.

### 5.2. Test Coverage & Verification Matrix
- Unit tests: Serialization/deserialization DTO, logic trừ calo nước dùng và toppings.
- Widget tests: Render `ScanReviewPage` với các trạng thái món nước và món khô combo.
- Regression: Bảo đảm duy trì 100% pass 256/256 tests hiện hữu.
