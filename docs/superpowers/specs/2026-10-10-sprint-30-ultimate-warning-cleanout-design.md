# Architecture Decision Record (ADR-036): Sprint 30 — Ultimate Warning Cleanout (v3.10.0)

> **Trạng thái**: 🟢 **ACCEPTED**  
> **Người chủ trì**: Sub-Agent Tech Lead (*The Pragmatic System Architect*)  
> **Ngày phê duyệt**: 2026-10-10  
> **Phạm vi áp dụng**: 4 file cuối cùng trong dải cảnh báo (> 350 dòng) trên toàn AstroBite  

---

## 1. Bối Cảnh (Context)
AstroBite đã hoàn tất việc loại bỏ 100% các file vi phạm Hard Cap (> 500 dòng). Tuy nhiên, trên toàn bộ 300 files mã nguồn Dart, hiện vẫn còn **4 file duy nhất** rơi vào dải cảnh báo Warning (> 350 dòng):
1. `mock_guild_repository.dart` (448 dòng)
2. `zero_gravity_food_background.dart` (415 dòng)
3. `health_cards.dart` (354 dòng)
4. `member_action_sheet.dart` (354 dòng)

Mục tiêu của Sprint 30 là đưa **100% (300/300) file của AstroBite** vào vùng an toàn tuyệt đối ($< 350$ dòng, target $< 200$ dòng cho mọi file), đồng thời giữ nguyên 100% test pass (322/322), 0 linter issue và 0 breaking changes.

---

## 2. Quyết Định Kỹ Thuật (Decisions)

### D1: Phân Rã `mock_guild_repository.dart` (448L ➔ < 250L)
- Tách toàn bộ hạt giống dữ liệu ban đầu (`_seedDefaultGuild()`) và danh sách thành viên/thử thách mặc định sang `features/guilds/data/repositories/guild_mock_seeds.dart`.
- `MockGuildRepository` chỉ giữ lại logic bộ nhớ (Memory State Management, Streams, CRUD simulation).

### D2: Phân Rã `zero_gravity_food_background.dart` (415L ➔ < 170L)
- Tách `ClayFoodItemSpec` và danh sách hằng số 10 items tọa độ vũ trụ sang `features/auth/presentation/widgets/zero_gravity_food_specs.dart`.
- Tách `CosmicStardustPainter` sang `features/auth/presentation/widgets/cosmic_stardust_painter.dart`.
- `zero_gravity_food_background.dart` chỉ tập trung vào `StatefulWidget`, `AnimationController`, `LayoutBuilder` và `AnimatedBuilder`.

### D3: Phân Rã `health_cards.dart` (354L ➔ < 20L Barrel)
- Tách `EnergyBalanceCard` sang `features/health/presentation/widgets/energy_balance_card.dart` (~230L).
- Tách `StepsActivityCard` sang `features/health/presentation/widgets/steps_activity_card.dart` (~100L).
- `health_cards.dart` chuyển thành barrel file re-export cả hai component để bảo toàn 100% khả năng tương thích ngược.

### D4: Phân Rã `member_action_sheet.dart` (354L ➔ < 180L)
- Tách Header thông tin thành viên (Avatar, Role Badge, Streak, XP) sang `features/guilds/presentation/widgets/member_action_header_card.dart`.
- Tách 2 hộp thoại xác nhận (`_confirmTransfer` và `_confirmKick`) sang `features/guilds/presentation/widgets/member_action_dialogs.dart`.
- `MemberActionSheet` giữ vai trò làm modal scaffold và danh sách action buttons chính.

---

## 3. Hệ Quả & Chỉ Số Đo Lường (Consequences & SLAs)
- **Zero Warnings**: Toàn bộ 300 files Dart của AstroBite sẽ đạt **0 file > 350 dòng** và **0 file > 500 dòng**.
- **Test Integrity**: Duy trì 322/322 tests pass thực chất.
- **Linter Cleanliness**: `flutter analyze` 0 issues.
