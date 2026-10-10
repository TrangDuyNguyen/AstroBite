# Release Notes: AstroBite v3.3.0

> **Phiên bản**: `v3.3.0`  
> **Tên phát hành**: AI Coach & Scanner God Files Elimination  
> **Mã Epic**: `EPIC-REF-02` / `FEAT-S23-COACH-SCANNER`  
> **Ngày phát hành**: 2026-10-10  
> **Trạng thái**: 🟢 **OFFICIAL RELEASED (Gate 7 Clearance)**

---

## 🌟 Tóm Tắt Bản Phát Hành (Highlights)

1. **Giải Phẫu Triệt Để 2 "God Files" Khổng Lồ Nhất Ứng Dụng**:
   - `coach_page.dart`: Rút gọn từ **2,153 dòng** xuống **344 dòng** (giảm 84.0%). Bóc tách sạch sẽ thành 10 sub-widgets chuyên trách (`coach_app_bar`, `coach_context_header`, `coach_message_list`, `coach_chat_bubble`, `coach_quick_actions`, `coach_typing_indicator`, `coach_input_bar`, `coach_empty_state`, `coach_session_banner`, `coach_history_sheet`).
   - `scan_review_page.dart`: Rút gọn từ **1,482 dòng** xuống **340 dòng** (giảm 77.1%). Bóc tách thành 9 sub-widgets chuyên trách (`scan_title_badge`, `scan_review_hero_card`, `scan_macro_gauge_section`, `scan_portion_card`, `scan_dish_item_card`, `scan_review_action_bar`, `scan_quick_add_sheet`, `scan_quick_weight_stepper`, `scan_tactile_action_button`).
   - 100% các component mới tuân thủ kỷ luật Ponytail (< 350 dòng).

2. **Bảo Toàn 100% Trải Nghiệm & Hành Vi Người Dùng (Zero Functional Regression)**:
   - Toàn bộ flow trò chuyện cùng AI Coach, đếm calo động, cảnh báo natri, xoay vòng gợi ý thông minh được bảo toàn chính xác.
   - Flow xem lại kết quả quét thức ăn, tinh chỉnh trọng lượng với Quick Steppers (+50g, -50g, 1 Bát, 1 Đĩa), phân tách nước dùng (Broth toggle), chọn topping và thêm món phụ thủ công chạy mượt mà 60 FPS.

3. **Chất Lượng Kỹ Thuật Đỉnh Cao (Gate 6 & Gate 6.5 Approved)**:
   - **320/320 automated tests passed (100% xanh)** trên toàn bộ test suite.
   - **`flutter analyze` 0 errors, 0 warnings, 0 issues**.
   - Zero security vulnerabilities (Security Audit Sign-off Passed).
