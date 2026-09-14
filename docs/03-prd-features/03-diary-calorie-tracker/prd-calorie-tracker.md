# PRD: Nhật Ký Dinh Dưỡng & Theo Dõi Calo (Diary & Calorie Tracker)

- **Mã tính năng**: `FEAT-03`
- **Bộ phận phụ trách**: BA Team
- **Trạng thái**: Approved
- **Đối chiếu QA**: `tests/02-manual-testcases/03-diary-calorie-tracker/` & `tests/03-bdd-gherkin-scenarios/calorie_diary.feature`
- **Đối chiếu FE**: `frontend/lib/features/tracker/`

---

## 1. Mục Tiêu Nghiệp Vụ
Là màn hình Dashboard chính (Home) của ứng dụng, giúp người dùng nắm bắt trong tích tắc:
- Tổng calo mục tiêu trong ngày, số calo đã nạp vào và số calo còn lại (Remaining Budget).
- Tỷ lệ thực tế nạp vào của 3 chỉ số đa lượng Carbs, Fat, Protein so với mục tiêu đặt ra.
- Chi tiết các món ăn đã ghi nhận trong 4 bữa: Bữa Sáng (Breakfast), Bữa Trưa (Lunch), Bữa Tối (Dinner), Bữa Phụ (Snacks).

---

## 2. Quy Tắc Hiển Thị Calo
- `Calo còn lại = Mục tiêu calo hàng ngày - Tổng calo các bữa ăn đã ghi nhận`.
- Khi calo nạp vào vượt mức mục tiêu: Vòng cung tiến trình CalorieProgressArc đổi sang màu Tertiary (`#FFD700`) để cảnh báo vượt hạn mức (Over budget).
- Người dùng có thể chỉnh sửa số lượng hoặc xóa bất kỳ món ăn nào trong danh sách bữa ăn; Dashboard tự động cập nhật lại tổng calo tức thì.
