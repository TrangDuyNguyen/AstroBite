# Regression Test Plan: Sprint 24 — Recipes Feature Refactoring

> **Tác giả**: Sub-Agent QA/QC Lead (*The Paranoid Inquisitor*)  
> **Trạng thái**: 🟢 **READY FOR IMPLEMENTATION (Gate 3 Test Plan)**

---

## 1. Phạm Vi Kiểm Thử (Test Scope)

1. **Unit & Controller Tests**:
   - `test/features/recipes/recipe_builder_controller_test.dart` (12 test cases): Bảo toàn 100% logic tính tổng calo, protein, carbs, fat, validate trạng thái form rỗng/đủ điều kiện.
2. **Widget & Screen Tests**:
   - `test/features/recipes/recipes_page_test.dart`: Đảm bảo `RecipesPage` render đúng empty state, load danh sách và không gặp lỗi layout khi user null.
   - Thêm widget test cho `RecipeBuilderPage` với sub-widgets bóc tách.
3. **Non-functional Checks**:
   - `scripts/check_file_length.sh`: Xác nhận cả 2 tệp `recipe_builder_page.dart` và `recipes_page.dart` đều dưới 350 dòng.
   - `flutter analyze`: 0 issues found.
