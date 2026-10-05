# 🚀 Release Notes: AstroBite v3.0.0 (Hands-Free Voice Logging with AstroVoice AI)

**Ngày phát hành**: 2026-10-05  
**Sprint**: Sprint 20  
**Version**: `v3.0.0` (Major Milestone)  
**Chịu trách nhiệm**: Hội Đồng Phát Hành Tối Cao (PO, PM, Tech Lead, QA Lead & Security Auditor)  
**Trạng thái**: 🟢 **Gate 7 Released (Production-Ready)**

---

## 🌟 Có Gì Mới Trong Phiên Bản v3.0.0?

Phiên bản **v3.0.0** là bước nhảy vọt quan trọng (Major Milestone) đánh dấu sự ra mắt của **`EPIC-VOICE: Hands-Free Voice Logging (AstroVoice AI & Gemini NLU Engine)`**. Người dùng giờ đây có thể ghi lại toàn bộ bữa ăn chỉ bằng một câu nói tiếng Việt tự nhiên mà không cần gõ phím hay chạm màn hình phức tạp.

### 1. Engine Nhận Diện Giọng Nói Tự Nhiên On-Device (AstroVoice Speech-to-Text)
- **Tối ưu tiếng Việt (`vi-VN`)**: Nhận diện khẩu âm và từ vựng ẩm thực Việt Nam chuẩn xác (Phở bò tái nạm, bún chả, cơm tấm sườn bì chả, trà đào cam sả...).
- **Streaming chữ theo thời gian thực (Live Transcript Feedback)**: Văn bản hiển thị tức thì theo từng từ phát âm trong bong bóng `LiveTranscriptBubble`.
- **Sóng âm động 7 thanh (Waveform Visualizer)**: Hiệu ứng trực quan phản hồi sống động theo decibel giọng nói với chuẩn mượt mà 60 FPS.

### 2. Mô Hình Hiểu Ngôn Ngữ Tự Nhiên (Gemini 2.0 Flash NLU Engine)
- **Hiểu sâu sắc đơn vị dân dã**: Bóc tách tự động các đơn vị ước lượng quen thuộc của người Việt (tô, bát, quả, cái, cốc, ly, đĩa...).
- **Tự động suy luận bữa ăn (24-Hour Time-of-Day Fallback)**: Tự động phân loại vào bữa Sáng (05:00–10:59), bữa Trưa (11:00–13:59), bữa Xế (14:00–17:59), bữa Tối (18:00–21:59) hoặc Ăn đêm (22:00–04:59) khi người dùng không nói rõ thời điểm.
- **Tốc độ phản hồi cực nhanh**: Độ trễ AI chỉ $\sim 1.1s$ (vượt chuẩn SLA $\le 1.5s$).

### 3. Tương Tác GenUI 1-Tap Log trong $< 150ms$
- **Xác nhận tức thì**: Tự động sinh thẻ tương tác `MealQuickLogCard` hiển thị tổng calo, bộ 3 macros (Carbs `#1CB0F6`, Fat `#FF5C8D`, Protein `#FF9600`) và trọng lượng ước tính.
- **Ghi nhật ký 1 chạm**: Nút bấm 3D Duolingo xúc giác cho phép lưu trực tiếp vào `FoodLogRepository` chỉ mất $\sim 45ms$ (SLA $< 150ms$).
- **Điểm chạm công thái học (Ergonomics)**: Nút Mic nổi viền sóng âm đa tầng trên `HomePage` và nút Mic tích hợp ngay trong thanh tìm kiếm của `ManualEntryPage`.

---

## 🛡️ Chữ Ký Nghiệm Thu (Quality Gates Passed)

- **Gate 0 (Kiến Trúc & Spikes)**: Tech Lead & PO phê chuẩn ADR `ADR-S20-VOICE-LOGGING` và Superpowers Design Spec.
- **Gate 1 (PRD & BDD)**: Đạt 100% User Stories BDD Given-When-Then, Data Dictionary đồng bộ hóa.
- **Gate 2 (UI/UX Design)**: Giao diện 5 trạng thái (Listening, Parsing, Ready, Empty, Error) chuẩn phong cách Claymorphic Duolingo 2D/3D.
- **Gate 3 (Test Design)**: 10 kịch bản kiểm thử biên (BVA) và kiểm thử phá hoại hoàn chỉnh.
- **Gate 4 (Code Craftsman)**: Feature-First Clean Architecture, Riverpod 2.x StateNotifier, zero over-engineering.
- **Gate 5 (Code Review - Ponytail)**: Reviewer xác nhận đạt chuẩn `Lean already. Ship.`
- **Gate 6 (QA & Verification)**:
  - `flutter analyze`: **0 lỗi, 0 cảnh báo**.
  - `flutter test`: **277/277 bài test tự động vượt qua 100%**.
- **Gate 6.5 (Security Audit)**: Bảo mật âm thanh On-device (0 file raw audio lưu trữ), phòng chống triệt để Prompt Injection và Data Poisoning.
- **Gate 7 (Release Gate)**: Hội đồng tối cao (PO, PM, Tech Lead, QA Lead & Security Auditor) đồng thuận ban hành `v3.0.0`.
