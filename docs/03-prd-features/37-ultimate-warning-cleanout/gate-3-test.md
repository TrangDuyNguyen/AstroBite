# Gate 3 QA Master Test Plan: Sprint 30 — Ultimate Warning Cleanout

> **Chủ trì**: Sub-Agent QA Tester (*The Paranoid Inquisitor*)  
> **Ngày lập kế hoạch**: 2026-10-10  
> **Trạng thái**: 🟢 **GATE 3 SIGNED-OFF**

---

## 1. Ma Trận Kiểm Thử Hồi Quy (Regression Test Matrix)

| Test Suite / Component | Đối tượng kiểm tra | Tiêu chuẩn pass |
| :--- | :--- | :--- |
| **`test/features/guilds/`** | `MockGuildRepository` sau khi tách Seeds | Khởi tạo với default data thành công, CRUD members/guilds hoạt động 100% |
| **`test/features/guilds/presentation/`** | `MemberActionSheet` sau khi tách header & dialogs | Mở sheet, bấm nút điều hướng thăng chức, hiển thị dialog xác nhận |
| **`test/features/auth/`** | `ZeroGravityFoodBackground` sau khi tách specs & painter | Render 10 món đồ ăn, animation repeat 18s không tràn RAM |
| **`test/features/analytics/`** | `AnalyticsPage` tích hợp `health_cards.dart` | Render `EnergyBalanceCard` không vỡ giao diện, 0 overflow |
| **Whole Test Suite** | 322 Unit & Widget Tests | 322/322 tests passed (100%) |
| **Static Analysis** | `flutter analyze` | 0 issues found |
| **Line Count Verification** | `./scripts/check_file_length.sh` | **0 file > 350 dòng** trên toàn bộ 300 file |
