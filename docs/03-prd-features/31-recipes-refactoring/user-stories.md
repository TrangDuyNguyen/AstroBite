# User Stories (BDD Gherkin) — Sprint 24: Recipes Refactoring

### Feature: Quản lý Công Thức Món Ăn (Modular Architecture)

#### Scenario: Người dùng thêm nguyên liệu mới vào công thức
  Given Người dùng đang ở màn hình RecipeBuilderPage
  And nhấn nút "+ Thêm" nguyên liệu
  When modal bottom sheet RecipeAddIngredientSheet hiển thị
  And người dùng nhập tên "Ức gà phi lê", 150g, 240 kcal, 0g Carbs, 46g Protein, 5g Fat
  And nhấn nút "Thêm Nguyên Liệu"
  Then Thẻ nguyên liệu hiển thị chính xác trong danh sách
  And Thẻ RecipeMacroSummaryCard tự động cộng dồn dinh dưỡng tương ứng

#### Scenario: Người dùng vuốt để xóa một nguyên liệu
  Given Danh sách công thức đang có 2 nguyên liệu
  When Người dùng vuốt thẻ nguyên liệu từ phải sang trái (endToStart)
  Then Thẻ nguyên liệu bị xóa khỏi danh sách
  And Tổng Calories và Macros trên Thẻ tổng quan lập tức giảm trừ đúng lượng vừa xóa

#### Scenario: Người dùng lọc tìm kiếm công thức món
  Given Người dùng ở màn hình RecipesPage với 5 món ăn đã tạo
  When Nhập từ khóa "Salad" vào ô tìm kiếm
  Then Chỉ các thẻ RecipeCardTile có tên hoặc mô tả chứa "Salad" mới được hiển thị
