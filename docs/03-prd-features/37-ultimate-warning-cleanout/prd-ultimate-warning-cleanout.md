# PRD: Sprint 30 — Ultimate Warning Cleanout (v3.10.0)

> **Mã PRD**: `PRD-REF-09`  
> **Chủ trì**: Sub-Agent Business Analyst (*The Pedantic Logician*)  
> **Người duyệt**: Sub-Agent Product Owner (*The Strategic Tyrant*)  
> **Ngày phê duyệt**: 2026-10-10  
> **Trạng thái**: 🟢 **GATE 1 SIGNED-OFF**

---

## 1. Mục Tiêu & Vấn Đề Nghiệp Vụ
Codebase AstroBite cần được chuẩn hóa tối đa để đạt tiêu chuẩn enterprise-grade. Việc loại bỏ triệt để 4 file cảnh báo cuối cùng sẽ hoàn tất sứ mệnh clean architecture toàn diện.

### Phạm Vi Bóc Tách:
1. **`mock_guild_repository.dart`**: Tách dữ liệu mẫu (Seeds) ra khỏi logic repository.
2. **`zero_gravity_food_background.dart`**: Tách model tọa độ đồ ăn vũ trụ và painter bụi sao.
3. **`health_cards.dart`**: Tách thẻ cân bằng năng lượng và thẻ đếm bước chân.
4. **`member_action_sheet.dart`**: Tách thẻ thông tin thành viên và các hộp thoại xác nhận quyền lực.

---

## 2. Tiêu Chí Nghiệm Thu (Acceptance Criteria)
- **AC-01**: Cả 4 file mục tiêu đều giảm sâu về $< 250$ dòng (không còn file nào $> 350$ dòng trên toàn repo).
- **AC-02**: Mọi chức năng người dùng (Auth zero gravity animation, Guild management dialogs, Health energy balance metrics) giữ nguyên 100% hành vi.
- **AC-03**: 322/322 unit & widget tests pass 100%.
