# UI Design Blueprint: Sprint 29 Deep Clean Polish (Gate 2)

- **Tác giả**: Sub-Agent UI/UX Designer (*"The Celestial Aesthetic Purist"*)
- **Chuẩn**: Claymorphic × Duolingo 2D/3D (Lưới 4pt, Warm Milk Canvas, tactile squash, 2-layer floating shadows)

---

## 1. Bản Đồ Phân Rã Khối Giao Diện

```mermaid
graph TD
    subgraph AnalyticsPage
        A1[analytics_period_selector.dart]
        A2[analytics_kpi_overview_row.dart]
        A3[analytics_macro_breakdown_card.dart]
    end

    subgraph ClayBottomNav
        B1[clay_hero_camera_fab.dart]
        B2[clay_nav_item.dart]
    end

    subgraph CoachHistorySheet
        C1[coach_history_delete_dialog.dart]
        C2[coach_history_session_card.dart]
    end

    subgraph MealQuickLogCard
        D1[meal_quick_log_props.dart]
        D2[meal_quick_log_portion_stepper.dart]
        D3[meal_quick_log_macro_badges.dart]
    end
```

---

## 2. Token & Hằng Số UI
- Dock height: `64pt`, Hero FAB: `56pt`, Cradle size: `64pt`.
- Góc bo: `16pt` cho input/steppers, `18pt` cho KPI cards, `20pt` cho Charts, `24pt` cho Period Selector & Sheet top radius.
