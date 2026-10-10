# PRD: Nền Tảng Đa Ngôn Ngữ Song Ngữ (VI + EN) — AstroBite

- **Mã tính năng**: `FEAT-S31-I18N-FOUNDATION`
- **Mã Epic**: `EPIC-CORE-10`
- **Sprint**: Sprint 31 (Phiên bản `v3.11.0`)
- **Tác giả**: Sub-Agent BA (*The Pedantic Logician*)
- **Người thẩm định & ký duyệt**: Sub-Agent PO (*The Strategic Tyrant*) & Sub-Agent Tech Lead (*The Pragmatic System Architect*)
- **Trạng thái**: 🟢 **APPROVED**

---

## 1. Mục Tiêu Sản Phẩm & Chỉ Số Đo Lường (Metrics & SLAs)
1. **Đo lường & Chỉ tiêu định lượng**:
   - Tỷ lệ nội dung được bản địa hóa: **100%** static strings trong UI được externalize ra file ARB (0 string hard-code trong presentation layer).
   - Thời gian chuyển đổi ngôn ngữ: **< 100ms**, 0 khung hình rơi rụng (FPS >= 55).
   - Khả năng lưu trạng thái (Persistence): **100%** sau khi restart app vẫn giữ nguyên lựa chọn ngôn ngữ của người dùng.
2. **Đối tượng người dùng**:
   - Người dùng Việt Nam (`vi`): Giữ nguyên văn phong thân thiện, trực quan.
   - Người dùng Quốc tế (`en`): Tiếp cận bằng tiếng Anh chuẩn mực về thuật ngữ dinh dưỡng (Calories, Carbs, Protein, Fat, Macros, Streaks).

---

## 2. Phạm Vi Tính Năng (Scope & MoSCoW)
- **Must-have (M)**:
  - Bản dịch đầy đủ 2 ngôn ngữ: Tiếng Việt (`vi`) và Tiếng Anh (`en`) cho toàn bộ 66+ UI keys hiện tại.
  - Tự động nhận diện ngôn ngữ máy (OS Locale) làm cấu hình mặc định ban đầu.
  - Tùy chọn chuyển đổi thủ công trong Profile / Cài đặt: `Theo hệ thống`, `Tiếng Việt`, `English`.
  - Lưu trữ tùy chọn vào local cache (`SharedPreferences`).
  - Xóa sạch nợ kỹ thuật `AppStrings`.
- **Won't-have (Sprint 31)**:
  - Chưa hỗ trợ ngôn ngữ thứ 3 (Nhật, Hàn, Trung).
  - Chưa dịch nội dung động từ AI Gemini sinh ra (sẽ làm trong sprint sau cho AI prompt language parameter).

---

## 3. Quy Tắc Nghiệp Vụ (Business Rules)
1. **BR-I18N-01 (Ưu tiên ngôn ngữ)**:
   - Nếu `user_preferred_locale` trong SharedPreferences là `'system'` hoặc chưa được lưu -> sử dụng ngôn ngữ thiết bị. Nếu ngôn ngữ thiết bị không thuộc `['vi', 'en']`, fallback về `vi` (hoặc `en` tùy default thiết lập).
   - Nếu `user_preferred_locale` là `'vi'` -> bắt buộc hiển thị tiếng Việt.
   - Nếu `user_preferred_locale` là `'en'` -> bắt buộc hiển thị tiếng Anh.
2. **BR-I18N-02 (Tính tức thì)**:
   - Việc đổi ngôn ngữ trong cài đặt không yêu cầu người dùng phải khởi động lại ứng dụng.
