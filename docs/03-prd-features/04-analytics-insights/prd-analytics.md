# PRD: Thống Kê & Phân Tích Xu Hướng (Analytics & Insights)

- **Mã tính năng**: `FEAT-04`
- **Bộ phận phụ trách**: BA Team
- **Trạng thái**: Approved
- **Đối chiếu QA**: `tests/02-manual-testcases/04-analytics-insights/`
- **Đối chiếu FE**: `frontend/lib/features/analytics/`

---

## 1. Mục Tiêu Nghiệp Vụ
Cung cấp bức tranh tổng thể về thói quen ăn uống và mức độ tuân thủ mục tiêu calo của người dùng theo thời gian (7 ngày gần nhất, 30 ngày, hoặc tùy chọn khoảng ngày), sử dụng thư viện biểu đồ hiệu năng cao `fl_chart`.

---

## 2. Các Chỉ Số Chính (Key Metrics)
- **Calorie Trend Line Chart**: Đường biểu diễn calo tiêu thụ từng ngày so với đường đứt nét biểu thị Calorie Target cố định.
- **Macronutrient Breakdown (Donut Chart)**: Tỷ lệ phần trăm thực tế nạp vào của Carbs, Fat, Protein trong toàn bộ chu kỳ.
- **Net Calorie Adherence**: Tỷ lệ ngày đạt mục tiêu (ví dụ: "Bạn đã ăn đúng hạn mức 5/7 ngày tuần này!").
