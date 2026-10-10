# PRD: Sprint 24 — Recipes Feature Clean Architecture & God Files Elimination

> **Tác giả**: Sub-Agent Business Analyst (*The Pedantic Logician*)  
> **Người duyệt**: Sub-Agent Product Owner (*The Strategic Tyrant*)  
> **Trạng thái**: 🟢 **APPROVED (Gate 1 Sign-Off)**

---

## 1. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (Success Metrics)

- **Mục tiêu**: Tối ưu hóa cấu trúc mã nguồn màn hình Danh sách công thức (`RecipesPage`) và Tạo công thức (`RecipeBuilderPage`), xóa bỏ hoàn toàn hiện tượng God File gây khó bảo trì.
- **Metrics đo lường**:
  - Tỷ lệ giảm dòng code của `recipe_builder_page.dart`: $\ge 70\%$ (984 dòng ➔ $< 200$ dòng).
  - Tỷ lệ giảm dòng code của `recipes_page.dart`: $\ge 60\%$ (646 dòng ➔ $< 200$ dòng).
  - Regression Rate: 0% lỗi phát sinh trong luồng lưu công thức và tìm kiếm.

---

## 2. Đặc Tả Chức Năng & BDD Scenarios

### US-01: Tạo & Lưu Công Thức Tùy Chỉnh
- **Given**: Người dùng nhập tên món ăn hợp lệ và thêm ít nhất 1 nguyên liệu có định lượng.
- **When**: Nhấn nút "Lưu" (Save).
- **Then**: Bộ đếm dinh dưỡng tổng hợp đầy đủ Calories, Carbs, Protein, Fat, lưu trữ vào Firestore và pop về danh sách.

### US-02: Bóc Tách Sheet Thêm Nguyên Liệu
- **Given**: Người dùng mở modal `RecipeAddIngredientSheet`.
- **When**: Nhập tên nguyên liệu và các chỉ số dinh dưỡng (grams, kcal, C, P, F $\ge 0$).
- **Then**: Đóng sheet an toàn và cập nhật tức thì vào danh sách nguyên liệu của RecipeBuilder.

### US-03: Tìm Kiếm & Lọc Danh Sách Công Thức
- **Given**: Người dùng có danh sách công thức cá nhân đã lưu.
- **When**: Gõ từ khóa tìm kiếm vào `ClaySearchBar`.
- **Then**: Danh sách lọc tức thời theo tên món hoặc mô tả cách chế biến.
