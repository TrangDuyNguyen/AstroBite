# Manual Testcases — Smart Realtime AI Coach (FEAT-09 / EPIC-07)

- **Tính năng**: Smart Realtime AI Coach
- **Phiên bản**: v1.2.0 (Sprint 03)
- **Phương pháp**: Equivalence Partitioning (EP) & Boundary Value Analysis (BVA)
- **Tham chiếu**: [`prd-ai-coach.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/09-ai-coach/prd-ai-coach.md), [`user-stories.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/09-ai-coach/user-stories.md)

---

## TC-CHAT-001: Gửi tin nhắn thành công và nhận phản hồi AI
- **Tiêu chí**: FR-01, FR-04, US-01
- **Precondition**: Đã đăng nhập, có mạng
- **Steps**:
  1. Bấm tab "Coach" trên Bottom Navigation
  2. Gõ "Bữa tối nên ăn gì?" vào thanh nhập liệu
  3. Bấm nút Send
- **Expected**:
  - Tin nhắn user hiển thị bên phải (bubble primary 15%)
  - Typing indicator shimmer xuất hiện bên trái
  - AI phản hồi trong <= 3 giây
  - Chat cuộn tự động xuống tin nhắn mới
- **Priority**: High

## TC-CHAT-002: Quick Actions — Bấm chip gợi ý
- **Tiêu chí**: FR-02, US-03
- **Precondition**: ChatScreen đang mở, có Quick Actions bar
- **Steps**:
  1. Bấm chip "Phân tích hôm nay"
- **Expected**:
  - Nội dung chip tự động gửi đi
  - Quick Actions ẩn trong lúc AI xử lý
  - Sau AI trả lời, Quick Actions bar xuất hiện lại
- **Priority**: High

## TC-CHAT-003: Ngữ cảnh bữa ăn tự động đính kèm
- **Tiêu chí**: FR-03, US-02
- **Precondition**: Đã log bữa sáng 450 kcal + bữa trưa 650 kcal, mục tiêu 2000 kcal
- **Steps**:
  1. Mở Coach tab, hỏi "Bữa tối nên ăn gì?"
- **Expected**:
  - AI phản hồi đề cập đến "còn 900 kcal"
  - Gợi ý món phù hợp ngân sách calo còn lại
- **Priority**: High

## TC-CHAT-004: Xử lý mất mạng
- **Tiêu chí**: US-01 Scenario 2
- **Precondition**: Bật Airplane Mode
- **Steps**:
  1. Mở Coach tab
  2. Gõ tin nhắn và bấm Send
- **Expected**:
  - Banner offline hiển thị ở đầu màn hình
  - Tin nhắn không được gửi
  - Thanh nhập liệu disabled
  - Lịch sử chat cũ vẫn hiển thị
- **Priority**: High

## TC-CHAT-005: Timeout AI response (15 giây)
- **Tiêu chí**: US-01 Scenario 3
- **Precondition**: Kết nối mạng yếu / simulate slow response
- **Steps**:
  1. Gửi tin nhắn
  2. Đợi 15 giây
- **Expected**:
  - Typing indicator biến mất
  - Error bubble hiển thị "AI đang bận, vui lòng thử lại"
  - Nút "Thử lại" hiển thị, bấm gửi lại tin nhắn gốc
- **Priority**: Medium

## TC-CHAT-006: Lịch sử chat trong ngày
- **Tiêu chí**: FR-05, US-04 Scenario 1
- **Steps**:
  1. Chat 5 tin nhắn buổi sáng
  2. Đóng app, mở lại buổi chiều
  3. Bấm tab Coach
- **Expected**:
  - 5 tin nhắn buổi sáng hiển thị đầy đủ
  - Có thể tiếp tục hội thoại
- **Priority**: Medium

## TC-CHAT-007: Session reset ngày mới
- **Tiêu chí**: US-04 Scenario 2
- **Steps**:
  1. Chat hôm nay
  2. Mở app ngày hôm sau
- **Expected**:
  - Chat screen trống
  - Empty State: "Chào buổi sáng!" + Quick Actions
- **Priority**: Medium

## TC-CHAT-008: Giới hạn 50 tin nhắn/ngày (BVA)
- **Tiêu chí**: BR-02, US-05 Scenario 1
- **Steps**:
  1. Gửi 50 tin nhắn
  2. Gửi tin nhắn thứ 51
- **Expected**:
  - Tin nhắn 1-50: gửi bình thường
  - Tin nhắn 51: thanh nhập liệu disabled
  - Dialog: "Đã đạt giới hạn 50 tin nhắn hôm nay"
- **Priority**: Medium

## TC-CHAT-009: AI từ chối nội dung y khoa
- **Tiêu chí**: BR-01, US-05 Scenario 2
- **Steps**:
  1. Hỏi "Tôi bị tiểu đường, nên uống thuốc gì?"
- **Expected**:
  - AI từ chối chẩn đoán: "Vui lòng tham khảo ý kiến bác sĩ"
  - Disclaimer hiển thị rõ
- **Priority**: Medium

## TC-CHAT-010: Empty state lần đầu
- **Tiêu chí**: UI Empty State
- **Precondition**: Người dùng mới, chưa bao giờ chat
- **Expected**:
  - Icon Robot 🤖, message chào mừng
  - Quick Actions bar hiển thị
- **Priority**: Low
