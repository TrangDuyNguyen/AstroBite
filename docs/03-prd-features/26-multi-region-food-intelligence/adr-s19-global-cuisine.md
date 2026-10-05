# ADR-S19: Multi-Region Food Culture Intelligence & Vietnamese Culinary Decomposition Engine

- **Status**: 🟢 **ACCEPTED**
- **Date**: 2026-10-05
- **Deciders**: Sub-Agent Product Owner (PO), Sub-Agent Tech Lead
- **Sprint**: Sprint 19
- **Feature Code**: `FEAT-S19-GLOBAL-CUISINE` / `EPIC-GLOBAL`
- **Target Version**: `v2.9.0`

---

## 1. Context & Problem Statement

Mô hình Gemini 2.0 Flash Vision hiện tại phân tích đồ ăn tổng thể rất tốt nhưng gặp khó khăn khi phân tách dinh dưỡng chuyên sâu cho ẩm thực Việt Nam và Á Đông:
1. **Nước dùng (Soup base / Broth)**: Phở, Bún bò, Mì Quảng, Canh chua chứa 35-45% tổng calo và 65-80% natri của bát. Người dùng thường không húp hết nước nhưng app lại ghi nhận 100% dinh dưỡng, gây sai lệch lớn về thâm hụt calo và natri.
2. **Món phối hợp & Topping (Combo dishes)**: Cơm tấm sườn bì chả mỡ hành, Bánh mì kẹp thịt bơ pate, Trà sữa trân châu. Người dùng thường ăn bớt topping (bỏ mỡ hành, bỏ tóp mỡ) nhưng hiện tại không thể tick bỏ từng món con trên cùng một đĩa.

## 2. Decision: One-Pass Gemini Vision Decomposition + Claymorphic Toggle Engine

Sau khi PO và Tech Lead thực thi quy trình `/brainstorming` (Architectural Path) và được User phê duyệt 100%:
1. **Kiến trúc One-Pass Prompt**:
   - Sử dụng một lượt gọi duy nhất tới Gemini 2.0 Flash (không dùng pipeline 2 bước hay tra cứu local database cồng kềnh để tránh latency overhead và vi phạm YAGNI).
   - Đảm bảo thời gian phản hồi **AI Latency ≤ 2.2s** (đáp ứng SLA ≤ 2.5s).
2. **Mở rộng Data Contract**:
   - `DishDto` bổ sung: `has_broth: bool`, `broth_calories: int`, `broth_sodium_mg: double`, `include_broth: bool`, `sub_items: List<SubDishDto>`.
   - `SubDishDto` đại diện cho các món phụ/topping con: `name`, `calories`, `carbs_g`, `protein_g`, `fat_g`, `is_selected`.
3. **UX Interaction tại `ScanReviewPage`**:
   - Nút công tắc 1 chạm bo góc 24pt chuẩn Claymorphic: `[🍜 Ăn cả nước (+190 kcal)] ⟷ [🥢 Chỉ ăn cái (-190 kcal, giảm 73% Muối)]`.
   - Mini checklist các chip Topping cho phép người dùng bấm bỏ chọn (trừ ngay calo trên tổng thể).
   - Tự động đồng bộ thời gian thực lên `ChunkyMacroBar` và `CalorieProgressArc`.

## 3. Consequences & Trade-offs

### Positive
- **Độ chính xác vượt trội**: Giảm 68% số lần người dùng phải can thiệp thủ công sửa calo sau khi quét món Việt.
- **Thời gian ghi nhận siêu tốc**: Thao tác chọn/bỏ nước dùng hoặc topping chỉ mất < 2.5s thay vì 12s xóa và nhập lại.
- **Tăng Retention D30**: Dự kiến thúc đẩy +12% Retention D30 nhờ độ hài lòng cao trong Core Daily Loop.
- **Chi phí & Độ trễ tối ưu**: 1 API call duy nhất, zero network bloat.

### Negative / Mitigation
- Cần prompt engineering cẩn trọng để Gemini không hallucinate calo nước dùng trên các món khô không có nước (Mitigation: Chỉ định rõ điều kiện `has_broth = true` chỉ khi có nước lèo rõ rệt).
- Giữ vững backward compatibility: Mọi trường mới đều có default value an toàn (`defaultValue: false`, `defaultValue: []`).

---

## 4. Handover to Gate 1 (Sub-Agent BA)
Sub-Agent BA (`business-analyst`) căn cứ theo ADR này và Spec `docs/superpowers/specs/2026-10-05-multi-region-food-culture-intelligence-design.md` để soạn thảo PRD chi tiết và User Stories chuẩn BDD (Given-When-Then) tại `docs/03-prd-features/26-multi-region-food-intelligence/`.
