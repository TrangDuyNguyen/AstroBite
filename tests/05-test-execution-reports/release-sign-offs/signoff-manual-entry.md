# Biên Bản Nghiệm Thu Kiểm Thử (QA Sign-Off Report)

- **Tính năng**: Nhập Món Ăn Thủ Công (Manual Food Entry)
- **Mã tính năng**: `FEAT-03-MANUAL`
- **Phiên bản**: `v1.4.0`
- **Thời gian thực hiện**: 2026-09-18
- **QA Lead**: AstroBite QA Team
- **Trạng thái**: **PASSED & APPROVED**

---

## 1. Phạm Vi Kiểm Thử (Testing Scope)

- **BA User Stories**:
  - `US-07`: Tra Cứu & Ghi Nhận Món Ăn Có Sẵn Trong Danh Bạ
    - Scenario 1: Tìm kiếm món ăn thành công qua từ khóa realtime.
    - Scenario 2: Lưu món ăn từ danh sách vào bữa ăn thành công với `source: "manual_entry"`.
  - `US-08`: Điều Chỉnh Khẩu Phần Gram Tự Động Tính Macro
    - Scenario 1: Tăng giảm số gram theo slider (50g – 1000g) tính lại tỷ lệ Calo, Protein, Carbs, Fat.
  - `US-09`: Thêm Món Ăn Mới Tùy Chỉnh (Custom Food)
    - Scenario 1: Nhập form món tùy chỉnh với dữ liệu hợp lệ và lưu thành công.
    - Scenario 2: Kiểm tra validation form (yêu cầu tên món, calo >= 0, gram > 0).

- **Manual Test Cases**:
  - `TC-MANUAL-01`: Tìm kiếm và lọc món ăn từ danh bạ có sẵn (**PASS**).
  - `TC-MANUAL-02`: Điều chỉnh khối lượng gram qua Slider và cập nhật calo động (**PASS**).
  - `TC-MANUAL-03`: Lưu món ăn có sẵn vào bữa ăn thành công (**PASS**).
  - `TC-MANUAL-04`: Thêm món ăn mới tùy chỉnh với dữ liệu hợp lệ (**PASS**).
  - `TC-MANUAL-05`: Xác thực lỗi khi thêm món tùy chỉnh (Tên trống hoặc Calo âm) (**PASS**).
  - `TC-MANUAL-06`: Tự động chọn đúng Bữa ăn khi điều hướng từ nút `+` trên Dashboard (**PASS**).
  - `TC-MANUAL-07`: Đồng bộ dữ liệu calo và dinh dưỡng về Dashboard ngay lập tức (**PASS**).

- **BDD Scenarios**:
  - `tests/03-bdd-gherkin-scenarios/manual_food_entry.feature` (100% User Story Traceability).

---

## 2. Kết Quả Kiểm Thử Tự Động (Automated Test Execution)

| Nhóm Kiểm Thử | File Test | Số lượng Test | Kết Quả |
|---|---|---|---|
| **Unit Test (CommonFoodsDataset)** | `test/features/tracker/data/datasources/common_foods_dataset_test.dart` | 3 tests | **PASS (100%)** |
| **Widget Test (ManualEntryPage)** | `test/features/tracker/presentation/pages/manual_entry_page_test.dart` | 5 tests | **PASS (100%)** |
| **Toàn bộ Tracker Suite** | `test/features/tracker/` | 20 tests | **PASS (100%)** |
| **Toàn bộ Test Suite Dự Án** | Toàn bộ dự án AstroBite | 86 tests | **PASS (100%)** |

### Kết Quả Static Analysis:
```bash
flutter analyze
# Output: Analyzing AstroBite...
# No issues found! (0 errors, 0 warnings)
```

---

## 3. Kiểm Thử Phi Chức Năng (Non-Functional Checks)

- **Celestial Dark UI Tokens**: 100% tuân thủ các hằng số màu trong `AppColors`:
  - Nền ứng dụng: `AppColors.surface` (`#0A192F`).
  - Container card: `AppColors.surfaceContainer` (`#112240`).
  - Bảng màu đa lượng bất biến: **Carbs `#1A73E8`**, **Fat `#FF69B4`**, **Protein `#FFD700`**.
- **Ergonomics & Touch Target**:
  - Toàn bộ các nút bấm (`FilledButton`, `IconButton`, `MealTypeChip`) đạt kích thước tối thiểu `44x44pt`.
  - Phản hồi xúc giác Haptic Feedback khi kéo slider và nhấn lưu món ăn.
- **Kỷ Luật Ponytail**:
  - Zero dependencies mới: Không cài thêm bất kỳ package bên ngoài nào.
  - Tái sử dụng tối đa widget nền tảng: `MealTypeChip`, `GlassCard`, `FoodSearchBar`.
  - Rà soát mã nguồn tinh gọn: `Lean already. Ship.`

---

## 4. Kết Luận & Phê Duyệt (Sign-off Decision)

- **Bug S1 (Blocker)**: 0
- **Bug S2 (Critical)**: 0
- **Bug S3 (Major)**: 0
- **Độ bao phủ kiểm thử**: 100% User Stories và Acceptance Criteria được bảo đảm bằng automated test suite.
- **Quyết định**: **APPROVED TO SHIP**. Sẵn sàng bàn giao cho Cổng 6 (Release Gate).
