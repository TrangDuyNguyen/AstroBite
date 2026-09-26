# Gate 3: Master Test Plan & Adversarial Test Design — Generative UI Chat Cockpit

- **Feature**: `FEAT-18` / `EPIC-17` (Generative UI Chat Experience)
- **Sub-Agent**: QA/QC Tester (`qa-tester`) — *"The Paranoid Inquisitor"*
- **Target Coverage**: 100% Traceability với PRD (`US-01` đến `US-04`) & UI/UX Spec (5 UI States)
- **Chính sách**: **CẤM DU DI TUYỆT ĐỐI (Zero-Tolerance Policy)**
- **Ngày lập**: 26/09/2026
- **Trạng thái**: 🟢 **Gate 3 Test Design Approved & Signed Off**

---

## 🔍 1. Ma Trận Truy Vết Kiểm Thử (Traceability Matrix: EP & BVA)

| Mã US | Hạng Mục Kiểm Thử | Kỹ Thuật ISTQB | Điều Kiện Đầu Vào / Ca Biên Ác Ý | Kết Quả Mong Đợi (Strict Assertion) |
| :--- | :--- | :---: | :--- | :--- |
| **US-01** | Render `MealQuickLogCard` hợp lệ | EP (Happy Path) | Payload A2UI hợp lệ: "Ức gà áp chảo", 248 kcal, 46.5g Pro, 0g Carb, 5.4g Fat, 150g, mealType: 'lunch'. | Dựng thẻ GlassCard đầy đủ tên món, số calo; 3 thanh Macro hiển thị chuẩn màu: Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`. |
| **US-01** | Stepper co giãn khối lượng (BVA) | BVA | Nhấn nút stepper `+50g` hoặc `-50g`. Trọng lượng ban đầu 150g. | Khối lượng tăng lên 200g hoặc giảm xuống 100g; Calo và 3 Macro co giãn chính xác theo tỷ lệ float 1 chữ số thập phân; chặn không cho giảm xuống `<= 0g`. |
| **US-01** | 1-Tap Log to Diary | State Transition | Nhấn nút "Ghi Vào Nhật Ký" trên thẻ. | Gọi `TrackerRepository.saveMealLog()` lưu vào Firestore/Cache; nút đổi thành "✓ Đã ghi nhận" (disabled) trong `< 100ms`; không ghi trùng lặp (Idempotent). |
| **US-01** | 1-Tap Log khi Mất Mạng | Offline | Bật Airplane Mode, nhấn "Ghi Vào Nhật Ký". | Ghi ngay vào Local Cache và xếp vào Pending Sync Queue; hiển thị badge "Chờ đồng bộ ☁️"; không ném lỗi unhandled exception. |
| **US-02** | `MacroBudgetGauge` an toàn | EP (Budget Safe) | Dự kiến nạp: 350 kcal, Ngân sách còn lại: 800 kcal, Target: 2000 kcal. | Dải tiến độ màu Primary Blue (`#1A73E8`) & Cyan (`#00E5FF`); nhãn thể hiện còn lại 450 kcal; không có cảnh báo vi phạm. |
| **US-02** | `MacroBudgetGauge` vượt hạn mức | BVA (Deficit Overflow) | Dự kiến nạp: 600 kcal, Ngân sách còn lại: 250 kcal (Vượt 350 kcal). | Dải tiến độ chuyển màu cảnh báo Tertiary Amber (`#FFD700`); hiển thị icon `warning`; nhãn thông báo "Vượt 350 calo so với mục tiêu ngày". |
| **US-03** | A2UI Stream JSON Parsing | EP (Streaming) | Nhận SSE stream token chứa cấu trúc A2UI JSON từ Gemini 3.8 Flash. | Bóc tách chính xác type & props; render component tương ứng trong `< 1.2s`; không gián đoạn danh sách chat. |
| **US-03** | Malformed JSON / Unknown Type | Negative / Fallback | AI stream bị đứt gãy, JSON thiếu ngoặc nhọn hoặc `type = "UnknownNonExistentWidget"`. | Hệ thống bắt lỗi nhẹ nhàng (Graceful degradation), fallback sang hiển thị text Markdown thông thường; **0 crash runtime**. |
| **US-04** | `QuickChoiceChips` Tương Tác | Concurrency | Bấm vào chip gợi ý (VD: "Bữa trưa"). | Kích hoạt Haptic feedback; gửi text "Bữa trưa" vào chat; vô hiệu hóa dải chip cũ để tránh spam click. |

---

## ⚡ 2. Kịch Bản Kiểm Thử Phi Chức Năng (Non-Functional Benchmarks)

1. **Ngân sách độ trễ (SLA & Latency Budget)**:
   - Thời gian hiển thị Skeleton Shimmer: `<= 300ms` sau khi user gửi tin nhắn.
   - Thời gian First Component (TTFT) từ Gemini 3.8 Flash: `<= 1.2s`.
   - Phản hồi Optimistic Update của 1-Tap Log: `<= 100ms`.
   - Tốc độ khung hình (Frame Rate): Duy trì ổn định `>= 55 FPS` (lý tưởng 60 FPS) khi cuộn danh sách chat chứa nhiều thẻ động.
2. **Quản lý bộ nhớ (Memory Leak Check)**:
   - Rò rỉ RAM: Bằng **0** sau 30 lượt gửi tin nhắn và sinh dynamic widgets liên tục.
3. **Công thái học di động**:
   - Touch target tối thiểu **48x48pt** trên toàn bộ các nút tăng giảm gram, nút CTA [Ghi vào nhật ký] và Choice Chips.

---

## 🛑 3. Tiêu Chí Nghiệm Thu Gate 6 (Acceptance & Exit Criteria)

QC sẽ **BÁC BỎ THẲNG THỪNG VÀ CẤM RELEASE** nếu xảy ra bất kỳ lỗi nào sau đây:
- Bất kỳ test case nào fail hoặc bị `skip` trong `flutter test`.
- Phát hiện bất kỳ **Fake Green Test** nào (ví dụ: `expect(true, isTrue)`).
- Màu sắc 3 chất đa lượng Carbs / Protein / Fat bị sai lệch mã hex.
- Ứng dụng bị giật hình khi cuộn (< 55 FPS) hoặc bị crash khi gặp JSON lỗi từ AI.
