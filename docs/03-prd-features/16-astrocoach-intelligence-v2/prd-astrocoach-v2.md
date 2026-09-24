# Tài Liệu Yêu Cầu Sản Phẩm (PRD — Product Requirements Document)
# AstroCoach AI Intelligence v2: Trợ Lý Dinh Dưỡng Theo Ngữ Cảnh Thời Gian Thực

- **Mã tính năng**: `FEAT-16`
- **Mã Epic liên kết**: `EPIC-18` (AstroCoach AI Intelligence v2 & Conversational Nutritionist)
- **Tác giả phụ trách**: Sub-Agent Business Analyst (BA) — *"The Pedantic Logician"*
- **Trạng thái tài liệu**: 🟢 **READY FOR GATE 1 SIGN-OFF**
- **Phiên bản mục tiêu**: `v1.8.0` (Sprint 09)
- **Tham chiếu kiến trúc**: [`docs/03-prd-features/16-astrocoach-intelligence-v2/adr-008-astrocoach-v2-architecture.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/16-astrocoach-intelligence-v2/adr-008-astrocoach-v2-architecture.md)

---

## 1. Tóm Tắt Mục Tiêu Nghiệp Vụ & Bài Toán Người Dùng

### 1.1. Nỗi Đau Hiện Tại Của Người Dùng (User Pain Points)
1. **Thiếu sự thấu hiểu ngữ cảnh**: Người dùng mở màn hình Coach nhưng Coach không tự biết hôm nay họ đã ăn những gì, thừa calo hay thiếu chất gì để chủ động khuyên nhủ.
2. **Khó chuyển hóa lời khuyên thành hành động (Friction in Actionability)**: Khi AI gợi ý *"Nên ăn 150g ức gà và 1 củ khoai lang cho bữa tối"*, người dùng phải tự nhớ, thoát ra ngoài màn hình chính, vào nhập tay từng món mất nhiều thao tác.
3. **Câu hỏi gợi ý cố định, nhàm chán**: Các nút bấm nhanh (Quick action chips) hiện tại bị gắn cứng (`const`), không thay đổi theo khung giờ sáng/trưa/tối hay theo lượng calo còn lại.

### 1.2. Mục Tiêu Sản Phẩm (Product Objectives & OKRs)
- **D30 Retention**: Tăng tỷ lệ giữ chân D30 từ 35% lên **>= 42%** nhờ tính năng đồng hành cá nhân hóa mỗi ngày.
- **Coach Engagement Rate**: Đạt **>= 45%** người dùng hoạt động hằng ngày mở tab AstroCoach ít nhất 1 lần/ngày.
- **1-Tap Log Conversion**: **>= 25%** số lượng gợi ý món ăn từ Coach được người dùng bấm 1 chạm thêm vào nhật ký.

---

## 2. Danh Sách User Stories Chuẩn BDD (Given - When - Then)

### 🌟 US-01: Thanh Chỉ Số Dinh Dưỡng Ngữ Cảnh Hôm Nay (Context Header Strip)
> **Là một** người dùng AstroBite,  
> **Tôi muốn** nhìn thấy ngay tình trạng calo và chất dinh dưỡng còn lại của ngày hôm nay ở đầu màn hình Coach,  
> **Để** tôi biết chính xác mình đang cần bổ sung hoặc hạn chế chất gì trước khi trò chuyện với AI.

- **Kịch bản BDD 1: Hiển thị chỉ số thời gian thực khi có dữ liệu**
  - **Given** người dùng đã đăng nhập và đã ghi nhận một số bữa ăn trong ngày hôm nay với tổng 1230 kcal trên mục tiêu 2051 kcal (còn lại 821 kcal).
  - **When** người dùng mở màn hình AstroCoach AI (Tab 2).
  - **Then** hệ thống hiển thị thanh kính mờ `Context Header Strip` ở trên cùng với thông tin: *"Còn 821 kcal • Đạm: 56/154g • Béo: 40/46g"* và trạng thái vi chất.

- **Kịch bản BDD 2: Tự động cập nhật khi người dùng ghi thêm món mới**
  - **Given** thanh chỉ số đang hiển thị còn lại 821 kcal.
  - **When** một món ăn mới được ghi vào nhật ký (qua 1-tap card hoặc camera scan).
  - **Then** thanh chỉ số lập tức cập nhật lại số calo và macro mới mà không cần khởi động lại ứng dụng.

---

### 🌟 US-02: Khuyến Nghị & Cảnh Báo Sức Khỏe Chủ Động (Proactive Health Insights)
> **Là một** người dùng quan tâm đến sức khỏe,  
> **Tôi muốn** Coach chủ động cảnh báo khi tôi nạp quá nhiều muối hoặc thiếu chất đạm nghiêm trọng,  
> **Để** tôi điều chỉnh khẩu phần kịp thời bảo vệ sức khỏe.

- **Kịch bản BDD 1: Cảnh báo khi lượng Natri trong ngày vượt ngưỡng an toàn**
  - **Given** tổng lượng Natri (Sodium) đã ghi trong ngày hôm nay vượt quá 2300mg (ví dụ: 3118mg sau bữa trưa ăn bún riêu mắm tôm).
  - **When** người dùng mở màn hình Coach hoặc gửi lời chào.
  - **Then** tin nhắn mở đầu của Coach sẽ chủ động nhắc nhở: *"Lưu ý: Bữa trưa của bạn có hàm lượng Natri khá cao (3118mg). Chiều và tối nay bạn nên uống thêm nhiều nước lọc và ưu tiên các món thanh đạm, luộc/hấp ít gia vị nhé! 💧"*.

- **Kịch bản BDD 2: Nhắc nhở bù đạm khi lượng Protein còn thiếu lớn**
  - **Given** người dùng mới chỉ đạt dưới 40% mục tiêu Protein mà đã đến bữa tối.
  - **When** người dùng bấm nút gợi ý bữa tối.
  - **Then** Coach ưu tiên gợi ý các món giàu đạm (ức gà, cá ngừ, đậu phụ, trứng) và giải thích rõ số gram đạm món ăn sẽ bù đắp.

---

### 🌟 US-03: Thẻ Món Ăn Tương Tác 1-Chạm (Interactive Holographic Meal Card)
> **Là một** người dùng bận rộn,  
> **Tôi muốn** các món ăn Coach khuyên dùng hiển thị dưới dạng thẻ thông minh có đầy đủ calo/macro và nút bấm trực tiếp,  
> **Để** tôi có thể lưu ngay món ăn đó vào nhật ký chỉ với 1 cú chạm.

- **Kịch bản BDD 1: Bóc tách và hiển thị thẻ món ăn tương tác**
  - **Given** người dùng hỏi: *"Gợi ý cho tôi bữa phụ dưới 200 kcal?"*.
  - **When** Gemini AI trả về câu trả lời chứa khối cấu trúc `astrobite-meal`.
  - **Then** giao diện chat hiển thị đoạn văn bản giải thích kèm một thẻ kính mờ `HolographicMealActionCard` chứa:
    - Tên món ăn (VD: *"Sữa chua Hy Lạp kèm hạt chia"*).
    - Con số Calo nổi bật (VD: *"160 kcal"*).
    - Bộ 3 chỉ số dinh dưỡng mini: Carbs 12g • Đạm 15g • Béo 4g.
    - Nút bấm nổi bật: *"Thêm vào Bữa phụ (+160 cal)"*.

- **Kịch bản BDD 2: Thao tác 1-chạm lưu món thành công (1-Tap Log)**
  - **When** người dùng chạm vào nút *"Thêm vào Bữa phụ (+160 cal)"*.
  - **Then** hệ thống:
    1. Ghi món ăn vào nhật ký hôm nay qua `FoodLogRepository` với `source: 'coach_recommend'`.
    2. Cập nhật trạng thái nút bấm thành *"✓ Đã lưu vào Bữa phụ"* (màu xanh lá/success và vô hiệu hóa nút để tránh lưu đúp).
    3. Hiển thị SnackBar thông báo: *"Đã lưu Sữa chua Hy Lạp vào Bữa phụ!"*.
    4. Thanh `Context Header Strip` tự động trừ 160 kcal trong lượng calo còn lại.

---

### 🌟 US-04: Gợi Ý Động Theo Thời Gian Thực (Dynamic Time-of-Day Quick Chips)
> **Là một** người dùng thường xuyên mở app,  
> **Tôi muốn** các nút gợi ý câu hỏi thay đổi thông minh theo buổi sáng, trưa, tối hoặc theo tình trạng dinh dưỡng hiện tại,  
> **Để** tôi không phải gõ phím mà vẫn hỏi trúng nhu cầu tức thời.

- **Kịch bản BDD 1: Khung giờ buổi sáng (05:00 - 10:30)**
  - **When** người dùng mở Coach vào buổi sáng.
  - **Then** các quick chips hiển thị: *"✨ Bữa sáng nhanh ít calo"*, *"☕ Cà phê nào không béo?"*, *"🍳 Món sáng giàu protein"*.
- **Kịch bản BDD 2: Khung giờ buổi trưa (11:00 - 13:30)**
  - **When** người dùng mở Coach vào buổi trưa.
  - **Then** các quick chips hiển thị: *"🍱 Gợi ý cơm trưa văn phòng"*, *"🥗 Bữa trưa Eat Clean"*, *"🥩 Bù đạm cho buổi chiều"*.
- **Kịch bản BDD 3: Khung giờ buổi tối (17:30 - 21:00)**
  - **When** người dùng mở Coach vào buổi tối.
  - **Then** các quick chips hiển thị: *"🌙 Bữa tối nhẹ bụng dễ ngủ"*, *"🍲 Bữa tối theo calo còn lại"*, *"🍵 Đồ uống thư giãn không calo"*.

---

## 3. Từ Điển Dữ Liệu & Hợp Đồng Dữ Liệu (Data Contract)

### 3.1. Hợp đồng khối dữ liệu `astrobite-meal`
```json
{
  "dishName": "Tên món ăn cụ thể",
  "calories": 320,
  "protein": 35,
  "carbs": 25,
  "fat": 8,
  "sodiumMg": 350.0,
  "fiberG": 4.5,
  "sugarG": 2.0,
  "mealType": "dinner" // "breakfast" | "lunch" | "dinner" | "snack"
}
```

### 3.2. Cấu trúc mở rộng của `ChatMessage`
```dart
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final Map<String, dynamic>? recommendedMeal; // Dữ liệu món ăn trích xuất nếu có
  final bool isLogged; // Đánh dấu người dùng đã bấm lưu món ăn này hay chưa
}
```

---

## 4. Ràng Buộc Phi Chức Năng (Non-Functional Requirements)

1. **Hiệu năng & SLA**:
   - Thời gian phản hồi AI: `<= 2.5 giây`.
   - Thời gian thực thi 1-Tap Log: `<= 100ms` (phản hồi xúc giác Haptic Feedback + cập nhật UI ngay lập tức).
   - Tốc độ khung hình khi cuộn tin nhắn: `>= 58 FPS`.
2. **Bảo mật & Y đức (AI Safety & Disclaimers)**:
   - Nghiêm cấm đưa ra chẩn đoán y tế hoặc kê đơn thực phẩm chức năng trị bệnh.
   - Luôn duy trì thông báo miễn trừ trách nhiệm y khoa ở footer: *"AstroCoach AI cung cấp thông tin tham khảo về dinh dưỡng, không thay thế lời khuyên y tế chuyên môn."*.
3. **Chuẩn mã nguồn**:
   - Tuân thủ 100% Ponytail (không cài package chat bên ngoài, tận dụng `flutter_riverpod`, `cloud_firestore`, `google_generative_ai`).
