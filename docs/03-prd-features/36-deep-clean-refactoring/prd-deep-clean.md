# PRD: Deep Clean Polish & Warning Elimination (Sprint 29)

- **Mã PRD**: `PRD-S29-DEEP-CLEAN`
- **Phiên bản**: `1.0.0`
- **Tác giả**: Sub-Agent Business Analyst (*"The Pedantic Logician"*)
- **Phê duyệt**: Sub-Agent PO & Sub-Agent Tech Lead
- **Trạng thái**: ✅ **APPROVED**

---

## 1. Mục Tiêu & Phạm Vi

### 1.1. Mục tiêu
Giải quyết toàn diện 4 file có nguy cơ kỹ thuật cao nhất còn sót lại ở ngưỡng cảnh báo (> 400 dòng), hoàn thiện cấu trúc phân rã Clean Architecture cho Analytics, Navigation UI Kit, và Coach Assistant.

### 1.2. Phạm vi
1. `AnalyticsPage`: Giữ nguyên tính năng chuyển đổi 7/30 ngày, chụp ảnh chia sẻ màn hình qua `ShareImageService`, và hiển thị biểu đồ calo & cân nặng.
2. `ClayBottomNav`: Giữ nguyên toàn bộ hành vi tabs router, hiệu ứng squash nảy khi chạm FAB camera, và Semantics accessibility.
3. `CoachHistorySheet`: Giữ nguyên cơ chế chuyển phiên theo ngày, xóa lịch sử hội thoại qua Riverpod và Draggable sheet.
4. `MealQuickLogCard`: Giữ nguyên tính năng scale calo/macro theo trọng lượng stepper và 1-tap log meal.
