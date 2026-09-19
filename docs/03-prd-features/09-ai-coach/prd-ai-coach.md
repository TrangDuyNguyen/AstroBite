# PRD: Trợ Lý AI Dinh Dưỡng Hội Thoại Thời Gian Thực (Smart Realtime AI Coach)

- **Mã tính năng**: `FEAT-09`
- **Mã Epic liên kết**: `EPIC-07` (Smart Realtime AI Coach)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA)
- **Trạng thái**: 🟡 **In Review (Chờ PO Phê Duyệt Gate 1)**
- **Mục tiêu phiên bản**: `v1.2.0` (Sprint 03)
- **Đối chiếu UI/UX**: `docs/03-prd-features/09-ai-coach/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `tests/02-manual-testcases/09-ai-coach/` & `tests/03-bdd-gherkin-scenarios/ai_coach.feature` (Gate 3)
- **Đối chiếu FE**: `lib/features/coach/` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- Ở phiên bản v1.0.0 và v1.1.0, AstroBite hoạt động như một **ứng dụng ghi chép thụ động**: người dùng quét ảnh hoặc nhập thủ công, xem thống kê, nhưng không nhận được **phản hồi chủ động** từ hệ thống.
- Nhiều người dùng (đặc biệt người mới bắt đầu ăn kiêng) không biết:
  1. Bữa tối nên ăn gì để cân bằng macro sau khi bữa trưa quá nhiều carbs?
  2. Đã ăn 1800 kcal rồi, còn bao nhiêu "ngân sách calo" và nên ăn gì?
  3. Chế độ Eat Clean hay Keto phù hợp với thể trạng của mình không?
- **Nỗi đau (Pain Point)**: Thiếu tương tác thông minh dẫn đến người dùng mở app chỉ để ghi log rồi đóng, không tạo được thói quen gắn bó lâu dài → D30 Retention chưa đạt kỳ vọng.

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Tăng Daily Engaged Time 40%**: Người dùng dành thêm thời gian tương tác nhờ hội thoại AI.
- **Tăng D30 Retention 10%**: Từ 35% lên 45% nhờ trải nghiệm cố vấn cá nhân hóa.
- **Tỷ lệ sử dụng AI Coach**: >= 30% DAU mở Chat ít nhất 1 lần/ngày.
- **Thời gian phản hồi AI (Latency)**: <= 3 giây cho tin nhắn chat thông thường.
- **Độ chính xác gợi ý**: >= 80% người dùng đánh giá gợi ý thực đơn là hữu ích (khảo sát in-app).

---

## 2. Đối Tượng Người Dùng (Target Personas)

1. **Người Mới Bắt Đầu Ăn Kiêng (Diet Beginners)**: Chưa hiểu rõ về macro, cần AI hướng dẫn từng bước *"Bữa tối nên ăn gì khi đã ăn quá nhiều carbs bữa trưa?"*.
2. **Dân Văn Phòng Bận Rộn (Busy Professionals)**: Không có thời gian tìm hiểu chế độ ăn, muốn AI gợi ý nhanh *"Gợi ý món ăn dưới 500 kcal gần đây"*.
3. **Người Tập Gym / Eat Clean (Fitness Enthusiasts)**: Cần tư vấn chuyên sâu *"Tôi đang tập Keto, bữa chiều nên ăn gì để đạt đủ 40g protein?"*.

---

## 3. Luồng Trải Nghiệm Người Dùng (User Journey & Flow)

```
[Tab "Coach" / FAB Chat]
       │
       ▼
[ChatScreen — Màn Hình Hội Thoại AI]
       │
       ├──► [Quick Actions Bar — Gợi Ý Câu Hỏi Nhanh]
       │      • "Bữa tối nên ăn gì?"
       │      • "Phân tích bữa ăn hôm nay"
       │      • "Gợi ý món dưới 500 kcal"
       │
       ├──► [Người dùng gõ tin nhắn tự do]
       │
       ▼
[Gửi tin nhắn + Ngữ cảnh bữa ăn hôm nay]
       │
       ▼
[Gemini 2.0 Flash Multi-turn Chat] (Latency <= 3s)
       │
       ├──► [AI Response — Bubble Rich Text]
       │      • Gợi ý thực đơn chi tiết (tên món, calo, macro)
       │      • Phân tích cân bằng dinh dưỡng hôm nay
       │      • Lời khuyên cá nhân hóa theo mục tiêu
       │
       ├──► [Typing Indicator Shimmer — Trong lúc chờ AI]
       │
       └──► [Error State — Mất mạng / Timeout / Quota hết]
              • Banner "Không thể kết nối AI" + nút Thử lại
```

---

## 4. Danh Sách Yêu Cầu Chức Năng (Functional Requirements)

### FR-01: Giao diện Chat Screen
- Hiển thị giao diện chat bubble (tin nhắn người dùng bên phải, AI bên trái).
- Thanh nhập liệu text ở đáy màn hình với nút gửi.
- Cuộn tự động xuống tin nhắn mới nhất.

### FR-02: Quick Actions — Câu hỏi gợi ý nhanh
- Hiển thị dãy Chips gợi ý phía trên thanh nhập liệu khi chat trống hoặc sau mỗi phản hồi AI.
- Tối thiểu 3 gợi ý phù hợp ngữ cảnh:
  - "Bữa tối nên ăn gì?"
  - "Phân tích dinh dưỡng hôm nay"
  - "Gợi ý món dưới 500 kcal"

### FR-03: Ngữ cảnh bữa ăn tự động (Context Injection)
- Trước mỗi tin nhắn gửi AI, hệ thống tự động đính kèm:
  - Tổng calo/macro đã ăn hôm nay (từ tracker).
  - Mục tiêu calo/macro hàng ngày (từ profile).
  - Các bữa ăn đã log trong ngày.
- Dữ liệu ngữ cảnh được encode vào System Prompt, **không hiển thị** cho người dùng.

### FR-04: Gemini Multi-turn Chat
- Sử dụng `firebase_ai` package (đã có trong dự án) với Gemini 2.0 Flash.
- Multi-turn conversation: gửi sliding window 10 tin nhắn gần nhất.
- System Prompt bao gồm:
  - Vai trò: "Bạn là chuyên gia dinh dưỡng AstroBite..."
  - Ngữ cảnh bữa ăn hôm nay.
  - Quy tắc: Trả lời ngắn gọn, tiếng Việt, tập trung vào dinh dưỡng.

### FR-05: Lưu lịch sử Chat Session
- Mỗi ngày tạo 1 chat session mới (reset hàng ngày).
- Lưu lịch sử tin nhắn vào Firestore: `users/{uid}/chat_sessions/{date}`.
- Hiển thị lịch sử khi người dùng mở lại Chat trong ngày.

### FR-06: Typing Indicator
- Hiển thị shimmer animation khi đang chờ AI phản hồi.
- Ẩn khi nhận được response hoặc sau timeout 15 giây.

---

## 5. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

| Tiêu chí | Chỉ tiêu | Ghi chú |
|:---|:---|:---|
| **Thời gian phản hồi AI** | <= 3 giây | Gemini 2.0 Flash multi-turn |
| **Sliding window** | 10 tin nhắn | Giới hạn token, tiết kiệm chi phí |
| **Session reset** | Mỗi ngày | Tránh tích tụ context quá lớn |
| **Offline graceful** | Hiển thị lịch sử cũ + banner offline | Không gửi tin nhắn mới khi mất mạng |
| **Bảo mật** | Firebase App Check | Bảo vệ AI API calls |
| **Ngôn ngữ** | Tiếng Việt | System prompt + UI labels |

---

## 6. Quy Tắc Nghiệp Vụ (Business Rules)

| Mã | Quy Tắc | Chi Tiết |
|:---|:---|:---|
| **BR-01** | AI không chẩn đoán y khoa | System prompt cấm AI đưa ra chẩn đoán bệnh hoặc kê đơn thuốc |
| **BR-02** | Giới hạn 50 tin nhắn/ngày | Ngăn lạm dụng API quota miễn phí |
| **BR-03** | Chỉ tư vấn dựa trên dữ liệu AstroBite | AI không được tự bịa số liệu dinh dưỡng |
| **BR-04** | Disclaimer hiển thị | Dòng nhỏ "AI gợi ý tham khảo, không thay thế ý kiến chuyên gia" |

---

## Phê Duyệt Của Product Owner (Gate 1 Sign-Off)
- **PO**: AstroBite Strategic PO Sub-Agent
- **Trạng thái**: 🟡 PENDING REVIEW
- **Ngày phê duyệt**: *(Chờ PO ký)*
- **Ý kiến chỉ đạo**: *(Chờ PO ghi chú)*
