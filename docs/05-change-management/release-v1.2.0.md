# Release Notes — AstroBite v1.2.0

> **Phiên bản**: `v1.2.0`  
> **Tên mã**: AI Coach & Health Ecosystem Integration  
> **Sprint**: Sprint 03 (2026-10-18 đến 2026-11-01)  
> **Ngày phát hành**: 19/09/2026  
> **Sub-Agent phê duyệt phát hành**: Product Owner (PO) & Project Manager (PM)  
> **Trạng thái**: 🟢 **RELEASED**

---

## 🌟 Tóm Tắt Phát Hành (Release Summary)

AstroBite v1.2.0 mang đến **2 tính năng trụ cột** thuộc Chân trời 2 (Horizon 2 - Next) đưa ứng dụng từ công cụ ghi nhật ký trở thành người đồng hành sức khỏe thông minh toàn diện:

| # | Tính Năng | Mô Tả Giá Trị |
| :---: | :--- | :--- |
| 🤖 | **AI Nutrition Coach** | Trợ lý tư vấn dinh dưỡng đa lượt qua Google Gemini AI, am hiểu ngữ cảnh bữa ăn trong ngày, gợi ý thực đơn lành mạnh và tuân thủ giới hạn an toàn |
| 🏃 | **Health Platform Integration** | Tích hợp sâu Apple Health (iOS) & Health Connect (Android), tính toán Cân bằng năng lượng (Energy Balance: In vs Out), tự động đồng bộ bước chân và calo tập luyện |

---

## ✨ Chi Tiết Tính Năng (Feature Details)

### 🤖 FEAT-09: AI Nutrition Coach
- **Gemini Multi-turn Chat**: Đàm thoại tự nhiên với AI chuyên gia dinh dưỡng tiếng Việt, duy trì cửa sổ ngữ cảnh trượt 10 tin nhắn gần nhất.
- **Meal Context Injection**: Tự động tổng hợp dữ liệu các bữa ăn trong ngày của người dùng để AI đưa ra lời khuyên cá nhân hóa chính xác.
- **Quick Action Chips**: Gợi ý sẵn các câu hỏi phổ biến ("Bữa tối nên ăn gì?", "Phân tích hôm nay", "Cần thêm bao nhiêu Protein?", "Gợi ý bữa phụ").
- **Safety & Quota Guard**: Disclaimer bắt buộc không chẩn đoán y khoa, giới hạn nghiêm ngặt 50 tin nhắn/ngày để tối ưu chi phí Token.
- **Celestial Dark UI**: Giao diện chat trực quan với bong bóng xanh `AppColors.primary` cho người dùng và container nổi cho AI, typing indicator hiệu ứng thiên hà.
- **PRD**: [`docs/03-prd-features/09-ai-coach/`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/09-ai-coach/)

### 🏃 FEAT-10: Health Platform Integration & Energy Balance
- **Cross-Platform Health Sync**: Đọc dữ liệu bước chân, năng lượng hoạt động và danh sách bài tập từ Apple HealthKit / Android Health Connect.
- **Energy Balance Dashboard**: Hiển thị cán cân Calo Nạp vào (`#1A73E8`) vs Calo Tiêu hao (`#FF69B4`), tính toán Net Calories và ngân sách calo còn lại theo thời gian thực.
- **Two-way Write-back Ready**: Chuẩn bị luồng ghi ngược Calo và Macro nạp vào ứng dụng Health của hệ điều hành.
- **Privacy First**: Hộp thoại xin quyền minh bạch, hỗ trợ ngắt kết nối an toàn bất kỳ lúc nào từ màn hình Hồ sơ.
- **PRD**: [`docs/03-prd-features/10-health-integration/`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/10-health-integration/)

---

## 📊 Thống Kê Kỹ Thuật (Technical Stats)

| Chỉ Số | Giá Trị |
| :--- | :---: |
| **New Features Shipped** | 2 (`FEAT-09`, `FEAT-10`) |
| **New Domain Entities** | 4 (`ChatMessage`, `HealthActivity`, `WorkoutEntry`, `EnergyBalance`) |
| **New Presentation Screens** | 2 (`CoachPage`, `HealthConnectionPage`) |
| **New Shared/Feature Widgets** | 3 (`EnergyBalanceCard`, `StepsActivityCard`, quick chips) |
| **Total Automated Tests** | **118 / 118 ✅ (100% Pass Rate)** |
| **Static Analysis Issues (`flutter analyze`)** | **0 errors, 0 warnings** |
| **New External Packages Bloat** | **0 (Strict Ponytail discipline)** |
| **Critical Defects (S1/S2)** | **0** |

---

## 🚦 Kiểm Soát Chất Lượng 7 Cổng (7-Gate Verification Audit)

- ✅ **Gate 1 (BA)**: PRD, BDD User Stories và Data Dictionary hoàn tất & PO ký duyệt (`docs/03-prd-features/gate-1-signoff-dossier-sprint-03.md`).
- ✅ **Gate 2 (UI/UX)**: Layout Spec 4pt, 5 trạng thái giao diện & bảng ánh xạ Celestial Dark UI tokens hoàn tất (`ui-ux-design-spec.md`).
- ✅ **Gate 3 (QA Test Design)**: Bộ Manual Testcases (EP/BVA) và Gherkin Scenarios bao phủ 100% (`ai_coach.feature`, `health_integration.feature`).
- ✅ **Gate 4 (Dev FE)**: Clean Architecture theo kỷ luật Ponytail, 0 lỗi `flutter analyze`.
- ✅ **Gate 5 (Reviewer)**: Rà soát Ponytail Code Review đạt phán quyết *"Lean already. Ship."* (`gate-5-ponytail-review-sprint-03.md`).
- ✅ **Gate 6 (QA Verification)**: Toàn bộ 118 automated tests pass 100%, thỏa mãn toàn diện các SLA hiệu năng (`signoff-sprint-03.md`).
- ✅ **Gate 7 (Release Gate)**: PO & PM nghiệm thu toàn diện và phát hành phiên bản `v1.2.0`.
