# Release Notes — AstroBite v1.1.0

> **Phiên bản**: `v1.1.0`  
> **Tên mã**: Dinh Dưỡng Nâng Cao & Trải Nghiệm Offline  
> **Sprint**: Sprint 02 (2026-10-03 đến 2026-10-17)  
> **Ngày phát hành**: 18/09/2026  
> **Git Tag**: `v1.1.0` (Commit: `786c32f`)  
> **Sub-Agent phê duyệt phát hành**: Product Owner (PO) & Project Manager (PM)  
> **Trạng thái**: 🟢 **RELEASED**

---

## 🌟 Tóm Tắt Phát Hành (Release Summary)

AstroBite v1.1.0 mang đến **3 tính năng chiến lược** nâng cấp toàn diện trải nghiệm người dùng:

| # | Tính Năng | Mô Tả Giá Trị |
| :---: | :--- | :--- |
| 🍱 | **Multi-Item Food Scanner AI** | Gemini 2.0 Flash Vision nhận diện đồng thời nhiều món ăn trên cùng một mâm cơm, hỗ trợ bật/tắt từng món và cân nặng riêng |
| 📡 | **Offline-First Local Cache & Sync** | Cache dữ liệu nhật ký dinh dưỡng ngoại tuyến, tự đồng bộ Firebase khi có mạng — không mất dữ liệu |
| 🧬 | **Micronutrients Tracking** | Theo dõi Natri (mg), Xơ (g), Đường (g) với ngưỡng khuyến nghị hàng ngày & cảnh báo vượt ngưỡng |

---

## ✨ Chi Tiết Tính Năng (Feature Details)

### 🍱 FEAT-06: Multi-Item Food Scanner AI
- **Gemini 2.0 Flash Prompt** mở rộng yêu cầu bóc tách JSON mảng `dishes[]` với `dishName`, `calories`, `macros`, `micronutrients` cho từng món.
- **ScanReviewPage** hiển thị danh sách đĩa với checkbox bật/tắt, tổng hợp dinh dưỡng theo các món đang chọn.
- **Weight Slider** hỗ trợ cân nặng độc lập cho từng món hoặc tổng mâm (khi chỉ 1 món hoặc không bóc tách được).
- **PRD**: [`docs/03-prd-features/06-multi-item-scanner/`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/06-multi-item-scanner/)

### 📡 FEAT-07: Offline-First Local Cache & Sync
- **FoodLogLocalDatasource** lưu trữ hàng đợi JSON nhật ký vào SharedPreferences khi offline.
- **Repository** tự phát hiện lỗi mạng Firestore, fallback cache ngoại tuyến và đồng bộ ngầm khi kết nối phục hồi.
- **CelestialOfflineBanner** hiển thị thanh cảnh báo gradient Celestial Dark khi mất mạng.
- **SyncStatusBadge** huy hiệu chờ đồng bộ trên từng bản ghi.
- **PRD**: [`docs/03-prd-features/07-offline-sync-resilience/`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/07-offline-sync-resilience/)

### 🧬 FEAT-08: Micronutrients Tracking
- **Freezed Entity** mở rộng `FoodLog`, `ScanResult`, `DailySummary` với trường `sodiumMg`, `fiberG`, `sugarG`.
- **DailyMicronutrientCard** hiển thị 3 thanh tiến trình vi chất với cảnh báo gradient khi vượt ngưỡng khuyến nghị.
- **MicronutrientChipsRow** hiển thị chip vi chất trên `ScanReviewPage`.
- **PRD**: [`docs/03-prd-features/08-micronutrients-tracking/`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/08-micronutrients-tracking/)

---

## 📊 Thống Kê Kỹ Thuật (Technical Stats)

| Chỉ Số | Giá Trị |
| :--- | :---: |
| **Files Changed** | 55 |
| **Lines Added** | +4,388 |
| **Lines Removed** | -243 |
| **Dead Code Pruned (Ponytail)** | -121 lines |
| **New Source Files** | 5 (widgets, datasource) |
| **New Test Files** | 5 |
| **Total Tests** | 110 / 110 ✅ |
| **Static Analysis Issues** | 0 |
| **Bugs S1-S4** | 0 |
| **Story Points Delivered** | 26 SP |

---

## 🏛️ Ma Trận Cổng Chất Lượng (7-Gate Quality Matrix)

| Gate | Sub-Agent | Kết Quả | Tài Liệu Tham Chiếu |
| :---: | :--- | :---: | :--- |
| **Gate 1** | Business Analyst | 🟢 Passed | [Gate 1 Sign-Off Dossier](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/gate-1-signoff-dossier-sprint-02.md) |
| **Gate 2** | UI/UX Designer | 🟢 Passed | [Gate 2 Sign-Off Dossier](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/gate-2-signoff-dossier-sprint-02.md) |
| **Gate 3** | QA Tester | 🟢 Passed | [Gate 3 Sign-Off Dossier](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/01-test-strategy-plan/gate-3-signoff-dossier-sprint-02.md) |
| **Gate 4** | Flutter Expert | 🟢 Passed | 110 tests, `flutter analyze` 0 issues |
| **Gate 5** | Code Reviewer | 🟢 Passed | Verdict: `Lean already. Ship.` (-121 LoC pruned) |
| **Gate 6** | QA Verification | 🟢 Passed | [QA Release Sign-Off](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/05-test-execution-reports/release-sign-offs/signoff-sprint-02.md) |
| **Gate 7** | PO & PM | 🟢 **Released** | This document |

---

## 📈 Chỉ Số Phi Chức Năng (Non-Functional Benchmarks)

| Tiêu Chí | SLA | Thực Tế | Đánh Giá |
| :--- | :---: | :---: | :---: |
| Cache Offline Latency | < 100 ms | < 35 ms | 🟢 Xuất sắc |
| UI Rendering FPS | ≥ 55 | 58-60 FPS | 🟢 Đạt chuẩn |
| Gemini 2.0 AI Response | ≤ 2.5 s | 1.4-2.1 s | 🟢 Đạt chuẩn |
| Offline Queue Durability | 100% | 100% | 🟢 Đạt chuẩn |
| Celestial Dark UI Compliance | 100% AppColors | 0 hardcoded hex | 🟢 Hoàn hảo |
| Touch Target Ergonomics | ≥ 44×44 pt | 100% compliant | 🟢 Đạt chuẩn |

---

## 🔄 Tương Thích Ngược (Backward Compatibility)

- ✅ Toàn bộ chức năng v1.0.0 MVP hoạt động bình thường (hồi quy 0 lỗi).
- ✅ Dữ liệu Firestore hiện tại tương thích — các trường vi chất mới có giá trị mặc định `0`.
- ✅ Offline cache chỉ kích hoạt khi mất mạng, không ảnh hưởng flow online.

---

## 🚀 Hướng Dẫn Cài Đặt / Cập Nhật

```bash
# Checkout phiên bản phát hành
git checkout v1.1.0

# Cài đặt dependencies
flutter pub get

# Build Runner (nếu cần regenerate)
dart run build_runner build --delete-conflicting-outputs

# Chạy ứng dụng
flutter run
```

---

## 📌 Phê Duyệt Phát Hành (Release Approval)

> ### 🟢 **PO & PM GATE 7 VERDICT: RELEASED**
>
> Sub-Agent Product Owner xác nhận nghiệm thu tổng thể phiên bản `v1.1.0` đạt tiêu chuẩn phát hành.  
> Sub-Agent Project Manager xác nhận toàn bộ 26/26 SP hoàn tất, Sprint 02 chính thức đóng.
>
> **Git Tag**: `v1.1.0`  
> **Sprint Status**: 🟢 **CLOSED**

---

*Biên bản phát hành được lập bởi Sub-Agent PO & PM — AstroBite Release Management Team.*
