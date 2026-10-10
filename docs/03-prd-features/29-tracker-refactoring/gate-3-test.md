# Gate 3: Master Test Plan & BDD Gherkin Specification

- **Mã Epic**: `EPIC-REF-01` / `FEAT-S22-TRACKER`
- **Sub-Agent phụ trách**: `qa-tester` — *"The Paranoid Inquisitor"*
- **Tiêu chuẩn nghiệm thu**: 100% Pass thực chất, 0 lỗi analyze, 60 FPS, 0 memory leak.

---

## 🧪 1. Ma Trận Kịch Bản Kiểm Thử (Test Traceability Matrix)

| ID Test Case | Hạng Mục Kiểm Thử | Kỹ Thuật Test | Kết Quả Mong Đợi | Trạng Thái |
| :--- | :--- | :---: | :--- | :---: |
| `TC-S22-01` | Enhanced Enum `MealType` $O(1)$ properties | Unit Test | Truy xuất đúng `label`, `icon`, `color`, `calorieRatio` | ⏳ Ready |
| `TC-S22-02` | `MealType.fromValue(String?)` safe deserialization | Unit Test (BVA) | Chuỗi rỗng/null/sai chính tả fallback về `MealType.breakfast` | ⏳ Ready |
| `TC-S22-03` | `MealSection` render đầy đủ 4 bữa ăn | Widget Test | Hiển thị đúng card header, macro progress bar, food items | ⏳ Ready |
| `TC-S22-04` | Swipe-to-dismiss xóa món ăn | Widget Test | Vuốt xóa món cập nhật callback và giao diện không crash | ⏳ Ready |
| `TC-S22-05` | `ManualEntryPage` chuyển đổi chip bữa ăn | Widget Test | Chọn chip đổi active state và lưu đúng giá trị | ⏳ Ready |
| `TC-S22-06` | Toàn bộ các file mới `< 200 dòng` | Static AST Check | `make check-files` không báo lỗi vi phạm | ⏳ Ready |

---

## 🥒 2. Kịch Bản BDD Gherkin (`.feature`)

```gherkin
Feature: Core Tracker Refactoring & MealType Validation

  Scenario: Truy xuất thuộc tính bữa ăn qua Enum O(1)
    Given hệ thống khởi tạo MealType.breakfast
    Then nhãn hiển thị phải là "Bữa sáng"
    And icon phải là Icons.wb_twilight_rounded
    And tỷ lệ calo mặc định là 0.25

  Scenario: Parse an toàn từ chuỗi dữ liệu cũ của Firestore
    Given chuỗi lưu trữ từ Firestore là "unknown_meal"
    When gọi phương thức MealType.fromValue("unknown_meal")
    Then kết quả trả về an toàn là MealType.breakfast không ném ngoại lệ

  Scenario: Render MealSection với các sub-widgets độc lập
    Given người dùng mở trang Tracker HomePage
    When danh sách 4 bữa ăn được tải
    Then widget MealCardHeader và MealMacroProgressBar phải tồn tại trên Widget Tree
    And không phát sinh hiện tượng RenderFlex overflow
```
