# Gate 3 Master Test Plan: Sprint 28 Tracker & Dashboard

- **Tác giả**: Sub-Agent QA Tester (*"The Paranoid Inquisitor"*)
- **Tiêu chuẩn**: Zero-Tolerance 100% Regression Pass, 0 Linter Issues.

---

## 1. Ma Trận Kiểm Thử Phân Hệ Tracker

| Kiểm thử | File test tương ứng | Kịch bản kiểm định |
| :--- | :--- | :--- |
| **TC-TRK-01** | `test/features/tracker/` | Tạo món tùy chỉnh với tên, trọng lượng và calo hợp lệ |
| **TC-TRK-02** | `test/features/tracker/` | Kiểm tra validation khi bỏ trống tên món hoặc gram <= 0 |
| **TC-TRK-03** | `test/features/tracker/` | HomePage hiển thị đúng 4 bữa ăn và widget sync reactive |
| **TC-TRK-04** | `test/features/tracker/` | Celestial Cockpit mở rộng và thu gọn ngăn kéo vi chất |
| **TC-TRK-05** | `test/features/tracker/` | Xóa món ăn trong MealDetailPage kích hoạt controller và tính lại calo |

---

## 2. Tiêu Chí Pass Gate 6
- 100% test pass (322/322).
- `flutter analyze`: 0 issues.
- Toàn bộ 4 file refactor đều $< 200$ dòng.
