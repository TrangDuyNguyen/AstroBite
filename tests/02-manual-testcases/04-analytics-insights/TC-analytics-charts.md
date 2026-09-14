# Testcases Biểu Đồ Thống Kê (Analytics Charts Testcases)

- **Module**: `04-analytics-insights`
- **Tham chiếu BA**: `docs/03-prd-features/04-analytics-insights/user-stories.md` (US-06, US-07)

---

### TC-ANA-001: Kiểm tra vẽ biểu đồ xu hướng calo 7 ngày
- **Test Steps**:
  1. Điều hướng đến tab "Báo cáo" (Analytics).
  2. Chọn bộ lọc "7 ngày gần nhất".
  3. Kiểm tra hiển thị của biểu đồ đường FlChart.
- **Expected Result**:
  - Biểu đồ hiển thị đủ 7 cột ngày tương ứng.
  - Đường baseline mục tiêu (nét đứt) hiển thị rõ ràng.
  - Chạm vào từng điểm mốc (datapoint) hiển thị popup tooltip chi tiết số calo của ngày đó.
  - Biểu đồ cuộn và co giãn mượt mà, không giật lag (đạt >= 55 FPS).
- **Severity**: S2 (Critical)
