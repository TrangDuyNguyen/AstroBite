# Gate 3 Master Test Plan: Sprint 29 Deep Clean Polish

- **Tác giả**: Sub-Agent QA Tester (*"The Paranoid Inquisitor"*)
- **Tiêu chuẩn**: Zero-Tolerance 100% Regression Pass, 0 Linter Issues.

---

## 1. Kịch Bản Hồi Quy Trọng Yếu

| Mã | Hạng mục kiểm thử | File test tương ứng |
| :--- | :--- | :--- |
| **TC-S29-01** | Analytics Page đổi chu kỳ 7/30 ngày và render charts | `test/features/analytics/presentation/pages/analytics_page_test.dart` |
| **TC-S29-02** | Weight Trend Chart render an toàn trong RepaintBoundary | `test/features/analytics/presentation/widgets/weight_trend_chart_test.dart` |
| **TC-S29-03** | ClayBottomNav hiển thị đủ 4 tabs & camera FAB | `test/shared/celestial_bottom_nav_test.dart` |
| **TC-S29-04** | Coach Controller & History Sheet chuyển phiên | `test/features/coach/` |
| **TC-S29-05** | Meal Quick Log Card stepper và log meal | `test/features/coach/` |

---

## 2. Tiêu Chí Pass Gate 6
- 100% test pass (322/322).
- `flutter analyze` 0 issues.
- Cả 4 file đều $< 180$ dòng.
