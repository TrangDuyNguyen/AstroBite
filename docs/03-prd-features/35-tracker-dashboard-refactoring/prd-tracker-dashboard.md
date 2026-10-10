# PRD: Daily Tracker & Dashboard Modular Clean Architecture (Sprint 28)

- **Mã PRD**: `PRD-S28-TRACKER-DASHBOARD`
- **Phiên bản**: `1.0.0`
- **Tác giả**: Sub-Agent Business Analyst (*"The Pedantic Logician"*)
- **Phê duyệt**: Sub-Agent PO & Sub-Agent Tech Lead
- **Trạng thái**: ✅ **APPROVED**

---

## 1. Mục Tiêu Nghiệp Vụ & Giới Hạn Phạm Vi

### 1.1. Mục tiêu
Tối ưu hóa phân hệ cốt lõi Tracker để đạt sự tách bạch tuyệt đối giữa cấu trúc bố cục màn hình và các khối giao diện nghiệp vụ chi tiết, bảo đảm hiệu năng 60 FPS mượt mà cho trải nghiệm ghi chép bữa ăn hàng ngày.

### 1.2. Phạm vi can thiệp
1. `custom_food_sheet.dart`: Giữ nguyên toàn bộ logic validation và truyền tải `FoodLogDto`, tái cấu trúc thành 3 khối giao diện con.
2. `home_page.dart`: Giữ nguyên tính năng reactive sync sang native widget và luồng điều hướng AutoRoute, tách rời Quick actions, Coach recommendation card và Log header.
3. `celestial_cockpit_card.dart`: Giữ nguyên cơ chế đóng mở micronutrient drawer, tính toán tiến trình natri/xơ/đường, bóc tách dòng vi chất thành widget tái sử dụng.
4. `meal_detail_page.dart`: Giữ nguyên quy trình xóa món ăn, tính toán tổng macro bữa ăn, tách overview card, food item card và empty state.
