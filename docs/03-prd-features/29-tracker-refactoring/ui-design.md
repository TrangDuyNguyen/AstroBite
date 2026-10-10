# UI/UX Design Specification: Core Tracker Decomposition

- **Mã Epic / Feature**: `EPIC-REF-01` / `FEAT-S22-TRACKER`
- **Sub-Agent phụ trách**: `ui-ux-designer`
- **Design Tokens**: Celestial Light/Claymorphic Duolingo 2D/3D (Lưới 4pt, góc bo 20pt/24pt)
- **Ký duyệt Gate 2**: Sub-Agent BA, PO & Tech Lead — 🟢 **Approved**

---

## 🎨 1. Sơ Đồ Kiến Trúc Cây Widget Sau Phân Rã (Widget Hierarchy)

```
[MealSection (Orchestrator < 160 dòng)]
 ├── ClayCard (bo góc 22pt, elevation 3)
 │    ├── MealCardHeader (Icon, Tiêu đề, Badge Calo, Nút Quick Add)
 │    ├── MealMacroProgressBar (Thanh tiến độ 3 màu Carbs / Protein / Fat)
 │    └── ListView.separated (Danh sách món ăn)
 │         └── MealFoodItemTile (Item món, gram, calo, Swipe-to-Dismiss)
 └── QuickAddFoodSheet (Modal Bottom Sheet nạp nhanh)

[ManualEntryPage (Orchestrator < 180 dòng)]
 ├── Scaffold & ClayAppBar
 └── Form & ListView
      ├── ManualMealSelector (4 Chips Bữa ăn dùng MealType.values)
      ├── ManualNutritionForm (Tên món, Calo, Carbs, Protein, Fat)
      ├── ManualPortionStepper (Thanh trượt gram & steppers nhanh)
      └── ClayButton (Nút Lưu thay đổi)
```

---

## 📏 2. Design Tokens & Bảng Ánh Xạ Bữa Ăn (4pt Grid System)

- **Góc bo (Border Radius)**:
  - Khối Card lớn: `22pt` (`AppValues.cardRadiusClay + 2`).
  - Chips & Pills: `24pt`.
  - Icon Containers: `12pt` - `14pt`.
- **Khoảng cách (Spacing)**:
  - Header padding: `16pt` (`AppValues.spacing16`).
  - Item spacing: `8pt` (`AppValues.spacing8`).
  - Form spacing: `16pt` - `20pt`.

---

## 🌓 3. Quy Chuẩn 5 Trạng Thái (5 UI States)

1. **Default State**: Hiển thị đầy đủ danh sách món kèm tổng calo và macro.
2. **Empty State**: Khi bữa ăn chưa có món nào, hiển thị text gợi ý mờ nhẹ: *"Chưa có món ăn nào • Nhấn '+' để thêm"*.
3. **Loading / Shimmer**: Khi đồng bộ Firestore, hiển thị `ClaySkeletonLoader`.
4. **Error State**: Banner báo lỗi mềm màu cam pastel.
5. **Offline State**: Đọc dữ liệu local cache không làm gián đoạn UI.
