# UI Design Blueprint: Sprint 28 Tracker & Dashboard (Gate 2)

- **Tác giả**: Sub-Agent UI/UX Designer (*"The Celestial Aesthetic Purist"*)
- **Chuẩn thiết kế**: Claymorphic × Duolingo 2D/3D (Lưới 4pt, Warm Milk Canvas, 2-layer floating shadows)

---

## 1. Kiến Trúc Khối Giao Diện

```mermaid
graph TD
    subgraph CustomFoodSheet
        A1[custom_food_sheet_header.dart]
        A2[custom_food_basic_inputs.dart]
        A3[custom_food_macro_pedestals.dart]
    end

    subgraph HomePage
        B1[home_nutrition_log_header.dart]
        B2[home_quick_actions_bar.dart]
        B3[home_astro_coach_suggestion_card.dart]
    end

    subgraph CelestialCockpitCard
        C1[cockpit_micronutrient_row.dart]
        C2[cockpit_micronutrients_drawer.dart]
    end

    subgraph MealDetailPage
        D1[meal_detail_overview_card.dart]
        D2[meal_detail_food_card.dart]
        D3[meal_detail_empty_state.dart]
    end
```

---

## 2. Quy Cách Lưới & Tokens

- **Góc bo**: `16pt` cho các input cards con, `20pt` cho cards gợi ý, `24pt` cho Cockpit Card và Submit buttons.
- **Bảng màu Dinh dưỡng Bất biến**:
  - Carbs: Sky Blue `#1CB0F6` (Duolingo Sky)
  - Protein: Orange `#FF9600` (Honey Tangerine)
  - Fat: Pink `#FF5C8D` (Strawberry Cream)
  - Calories: Lime Green `#58CC02` / Sky Blue `#1CB0F6`
