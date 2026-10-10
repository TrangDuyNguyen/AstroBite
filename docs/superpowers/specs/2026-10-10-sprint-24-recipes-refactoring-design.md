# Sprint 24 Architectural Spec & ADR-030: Recipes Feature God Files Elimination

> **Tác giả**: Sub-Agent Tech Lead (*The Pragmatic System Architect*)  
> **Dự án**: AstroBite Mobile App  
> **Epic**: `EPIC-REF-03` / `FEAT-S24-RECIPES`  
> **Phiên bản mục tiêu**: `v3.4.0`  
> **Thời điểm**: 2026-10-10  
> **Trạng thái**: 🟢 **APPROVED (Gate 0 Feasibility Sign-off)**

---

## 1. Bối Cảnh & Vấn Đề (Context & Problem Statement)

Qua đợt rà soát tự động toàn bộ codebase, Phân hệ Recipes đang tồn tại 2 "God Files" vượt ngưỡng chặn cứng (Hard Cap 500 dòng) và là tệp lớn nhất dự án hiện tại:
1. `lib/features/recipes/presentation/pages/recipe_builder_page.dart` (**984 dòng** — File dài nhất AstroBite).
   - Ôm đồm: Form validation, `_SaveButton` 3D tactile, `_MacroSummaryCard`, `_MacroPill`, `_IngredientTile`, `_MiniDot`, `_EmptyIngredients`, `_ErrorBanner`, và modal bottom sheet `_AddIngredientSheet` (230 dòng) với các trường nhập liệu số riêng biệt.
2. `lib/features/recipes/presentation/pages/recipes_page.dart` (**646 dòng**).
   - Ôm đồm: Floating Action Button 3D `_ChunkyRecipeFab`, danh sách thẻ `_RecipeCard` với bảng màu pastel badge, meta tags, mini macro gems, loading skeleton và empty state.

Mục tiêu Sprint 24: Giải phẫu dứt điểm 2 tệp trên, đưa cả 2 về sâu dưới Warning Threshold **< 350 dòng** (kỳ vọng `< 200 dòng`), bảo toàn 100% logic và kiểm thử tự động.

---

## 2. Quyết Định Kiến Trúc (Architecture Decision Record - ADR-030)

### Cấu Trúc Thư Mục Mới:
Thiết lập thư mục `lib/features/recipes/presentation/widgets/` chứa các thành phần bóc tách:
```
lib/features/recipes/presentation/
├── controllers/
│   ├── meal_plan_controller.dart
│   └── recipe_builder_controller.dart
├── pages/
│   ├── meal_planner_page.dart
│   ├── recipe_builder_page.dart      # < 150 dòng (Đạt chuẩn Ponytail)
│   └── recipes_page.dart             # < 150 dòng (Đạt chuẩn Ponytail)
└── widgets/
    ├── recipe_add_ingredient_sheet.dart  # Modal sheet thêm nguyên liệu (< 180 dòng)
    ├── recipe_builder_empty_state.dart   # Empty state & Error banner (< 70 dòng)
    ├── recipe_card_tile.dart             # Thẻ hiển thị công thức món (< 190 dòng)
    ├── recipe_chunky_fab.dart            # FAB 3D tạo công thức (< 90 dòng)
    ├── recipe_ingredient_tile.dart       # Thẻ nguyên liệu vuốt xóa (< 110 dòng)
    ├── recipe_macro_summary_card.dart    # Thẻ tổng quan calo/macro (< 110 dòng)
    ├── recipe_save_button.dart           # Nút Lưu 3D Duolingo (< 90 dòng)
    └── recipes_empty_state.dart          # Empty, Error, Loading skeleton (< 80 dòng)
```

---

## 3. SLA & Tiêu Chuẩn Nghiệm Thu

- Không phát sinh dependency mới (Tuân thủ triệt để Ponytail).
- Tốc độ render 60 FPS, 0 jank, 0 unbounded width/height layout bugs.
- `flutter analyze`: 0 issues found.
- 100% test suite passed (toàn bộ 320 tests hiện tại tiếp tục xanh).
