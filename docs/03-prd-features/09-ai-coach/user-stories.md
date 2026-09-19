# User Stories & BDD Acceptance Criteria — Smart Realtime AI Coach (FEAT-09 / EPIC-07)

- **Tính năng**: Smart Realtime AI Coach
- **Phiên bản**: v1.2.0 (Sprint 03)
- **Tham chiếu PRD**: [`prd-ai-coach.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/09-ai-coach/prd-ai-coach.md)

---

## US-01: Mở giao diện Chat và gửi câu hỏi cho AI
- **As a**: Người dùng đã đăng nhập
- **I want to**: Mở màn hình Chat và gõ câu hỏi về dinh dưỡng để nhận gợi ý từ AI
- **So that**: Tôi được tư vấn cá nhân hóa dựa trên dữ liệu bữa ăn thực tế của mình

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Gửi tin nhắn thành công (Happy Path)
- **Given**: Người dùng đang ở bất kỳ tab nào và có kết nối mạng
- **When**: Người dùng bấm vào tab "Coach" trên Bottom Navigation
- **Then**: Hệ thống hiển thị ChatScreen với lịch sử tin nhắn hôm nay (nếu có)
- **And**: Thanh nhập liệu text và nút gửi hiển thị ở đáy màn hình
- **When**: Người dùng gõ "Bữa tối nên ăn gì?" và bấm nút gửi
- **Then**: Tin nhắn người dùng hiển thị bên phải dạng bubble
- **And**: Typing indicator shimmer hiển thị bên trái
- **And**: Trong <= 3 giây, AI phản hồi với gợi ý thực đơn dạng rich text
- **And**: Chat tự động cuộn xuống tin nhắn mới nhất

#### Scenario 2: Gửi tin nhắn khi mất mạng (Offline)
- **Given**: Người dùng đang ở ChatScreen nhưng thiết bị mất kết nối mạng
- **When**: Người dùng gõ tin nhắn và bấm gửi
- **Then**: Hệ thống hiển thị banner "Đang ngoại tuyến — Không thể gửi tin nhắn" ở đầu màn hình
- **And**: Tin nhắn không được gửi đi, thanh nhập liệu vô hiệu hóa
- **And**: Lịch sử chat cũ trong ngày vẫn hiển thị đầy đủ

#### Scenario 3: AI phản hồi quá chậm (Timeout)
- **Given**: Người dùng đã gửi tin nhắn thành công
- **When**: Gemini AI không phản hồi trong 15 giây
- **Then**: Typing indicator biến mất
- **And**: Hiển thị bubble lỗi "AI đang bận, vui lòng thử lại" kèm nút "Thử lại"
- **When**: Người dùng bấm "Thử lại"
- **Then**: Tin nhắn gốc được gửi lại cho AI

---

## US-02: AI đọc ngữ cảnh bữa ăn hôm nay để gợi ý chính xác
- **As a**: Người dùng đã ghi nhật ký ăn trong ngày
- **I want to**: AI tự động biết tôi đã ăn gì hôm nay
- **So that**: Gợi ý của AI phù hợp với "ngân sách calo" còn lại và macro cần bổ sung

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Ngữ cảnh bữa ăn được đính kèm tự động
- **Given**: Người dùng đã log 2 bữa hôm nay (Sáng: phở bò 450 kcal, Trưa: cơm sườn 650 kcal)
- **And**: Mục tiêu calo hàng ngày là 2000 kcal (Carbs 45%, Protein 30%, Fat 25%)
- **When**: Người dùng hỏi "Bữa tối nên ăn gì?"
- **Then**: System Prompt gửi kèm AI chứa thông tin: "Đã ăn 1100/2000 kcal, còn 900 kcal, Protein thiếu 35g"
- **And**: AI phản hồi gợi ý phù hợp: món giàu protein, dưới 900 kcal

#### Scenario 2: Chưa có bữa ăn nào trong ngày
- **Given**: Người dùng chưa log bữa ăn nào hôm nay
- **When**: Người dùng hỏi "Hôm nay nên ăn gì?"
- **Then**: AI nhận biết ngân sách toàn bộ (2000 kcal) và gợi ý thực đơn cả ngày
- **And**: AI nhắc nhở "Bạn chưa ghi nhận bữa ăn nào hôm nay"

---

## US-03: Sử dụng Quick Actions để hỏi nhanh
- **As a**: Người dùng bận rộn
- **I want to**: Bấm một nút gợi ý nhanh thay vì phải gõ câu hỏi
- **So that**: Tôi tiết kiệm thời gian và nhận gợi ý tức thì

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Bấm Quick Action chip
- **Given**: Người dùng đang ở ChatScreen, chưa có tin nhắn nào hoặc sau khi AI trả lời
- **And**: Quick Actions bar hiển thị 3 chips: "Bữa tối nên ăn gì?", "Phân tích hôm nay", "Món dưới 500 kcal"
- **When**: Người dùng bấm chip "Phân tích hôm nay"
- **Then**: Nội dung chip tự động điền vào thanh nhập liệu và được gửi đi ngay
- **And**: Quick Actions bar ẩn đi trong lúc AI đang xử lý

#### Scenario 2: Quick Actions sau phản hồi AI
- **Given**: AI vừa trả lời xong
- **Then**: Quick Actions bar xuất hiện lại với 3 gợi ý mới phù hợp ngữ cảnh

---

## US-04: Xem lại lịch sử Chat trong ngày
- **As a**: Người dùng đã chat với AI buổi sáng
- **I want to**: Mở lại Chat buổi chiều và xem lại hội thoại trước đó
- **So that**: Tôi không cần hỏi lại cùng câu hỏi, AI nhớ ngữ cảnh trong ngày

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Mở lại Chat trong cùng ngày
- **Given**: Người dùng đã chat 5 tin nhắn buổi sáng
- **When**: Người dùng mở lại ChatScreen buổi chiều
- **Then**: Toàn bộ 5 tin nhắn buổi sáng hiển thị đầy đủ
- **And**: Người dùng có thể tiếp tục hội thoại từ chỗ dang dở

#### Scenario 2: Ngày mới — Session reset
- **Given**: Hôm qua người dùng đã chat 10 tin nhắn
- **When**: Người dùng mở ChatScreen ngày hôm sau
- **Then**: Chat screen trống, hiển thị Empty State: "Chào buổi sáng! Hỏi tôi bất cứ điều gì về dinh dưỡng hôm nay."
- **And**: Quick Actions bar hiển thị với gợi ý buổi sáng

---

## US-05: Xử lý giới hạn tin nhắn và nội dung không phù hợp
- **As a**: Hệ thống
- **I want to**: Kiểm soát số lượng tin nhắn và nội dung gửi AI
- **So that**: Tránh lạm dụng API quota và đảm bảo nội dung phù hợp

### Acceptance Criteria (Given - When - Then)

#### Scenario 1: Đạt giới hạn 50 tin nhắn/ngày
- **Given**: Người dùng đã gửi 50 tin nhắn trong ngày
- **When**: Người dùng cố gửi tin nhắn thứ 51
- **Then**: Thanh nhập liệu vô hiệu hóa
- **And**: Hiển thị thông báo: "Bạn đã đạt giới hạn 50 tin nhắn hôm nay. Hãy quay lại ngày mai nhé! 🌙"

#### Scenario 2: AI từ chối nội dung y khoa
- **Given**: Người dùng hỏi "Tôi bị tiểu đường, nên uống thuốc gì?"
- **When**: Tin nhắn được gửi cho AI
- **Then**: AI phản hồi: "Tôi chỉ có thể tư vấn về dinh dưỡng và chế độ ăn. Về vấn đề y khoa, vui lòng tham khảo ý kiến bác sĩ chuyên khoa."
- **And**: Disclaimer hiển thị: "⚕️ AI gợi ý tham khảo, không thay thế ý kiến chuyên gia y tế"
