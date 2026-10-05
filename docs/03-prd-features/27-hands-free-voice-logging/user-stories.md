# User Stories & BDD Acceptance Criteria (Sprint 20)
# Hands-Free Voice Logging (AstroVoice AI)

- **Mã Epic**: `EPIC-VOICE`
- **Mã Feature**: `FEAT-S20-VOICE-LOG`
- **Tác giả**: Sub-Agent Business Analyst (BA) — *The Pedantic Logician*
- **Đối chiếu QA**: `test/features/voice/`
- **Phiên bản mục tiêu**: `v3.0.0`

---

## 📖 Danh Sách User Stories (5 Core Stories)

---

### US-20.1: Kích Hoạt Chế Độ Giọng Nói & Xin Cấp Quyền Microphone
- **As a**: Người dùng đang bận tay hoặc muốn ghi chép bữa ăn nhanh,
- **I want to**: Chạm vào nút Micro nổi trên màn hình chính hoặc thanh tìm kiếm,
- **So that**: Tôi có thể mở giao diện AstroVoice và được hướng dẫn cấp quyền ghi âm rõ ràng.

#### BDD Scenarios (Acceptance Criteria):

```gherkin
Scenario: Người dùng lần đầu chạm nút Mic và cấp quyền thành công
  Given người dùng đang ở màn hình HomePage
  And ứng dụng chưa được cấp quyền Microphone
  When người dùng chạm vào nút Mic nổi "VoicePulsingMicButton"
  Then hệ thống hiển thị hộp thoại giải thích lý do sử dụng Microphone cho AstroVoice
  When người dùng chọn "Cho phép"
  Then quyền Microphone được cấp thành công
  And modal "AstroVoiceSheet" mở lên
  And thiết bị rung haptic phản hồi nhẹ
  And trạng thái chuyển sang "LISTENING" với vòng sóng âm lan tỏa

Scenario: Người dùng từ chối cấp quyền Microphone
  Given người dùng đang ở hộp thoại xin quyền Microphone
  When người dùng bấm "Từ chối"
  Then modal AstroVoice đóng lại
  And thanh SnackBar hiển thị thông báo "AstroVoice cần quyền Micro để nghe bạn nói"
  And kèm nút "Mở Cài Đặt" để người dùng cấp quyền lại khi cần
```

---

### US-20.2: Nhận Diện Giọng Nói Thời Gian Thực (Live Transcript Streaming)
- **As a**: Người dùng đang nói tên bữa ăn bằng tiếng Việt,
- **I want to**: Thấy từng chữ mình nói hiện ra trên màn hình ngay lập tức,
- **So that**: Tôi biết ứng dụng đang lắng nghe chính xác những gì tôi phát âm.

#### BDD Scenarios (Acceptance Criteria):

```gherkin
Scenario: Hiển thị dòng chữ trực tiếp khi người dùng nói câu hoàn chỉnh
  Given modal "AstroVoiceSheet" đang ở trạng thái "LISTENING"
  When người dùng nói bằng tiếng Việt: "Sáng nay ăn 1 tô phở bò tái nạm với 2 cái quẩy"
  Then bong bóng "LiveTranscriptBubble" hiển thị từng cụm từ theo thời gian thực
  And sóng âm hiển thị chuyển động nhấp nhô theo biên độ âm thanh
  When người dùng ngừng nói trong 1.2 giây
  Then hệ thống tự động khóa bản ghi nhận dạng
  And trạng thái chuyển ngay sang "PARSING"
```

---

### US-20.3: Phân Tích Ngữ Nghĩa Dinh Dưỡng Qua Gemini 2.0 Flash NLU
- **As a**: Hệ thống AstroBite,
- **I want to**: Chuyển chuỗi văn bản đã nhận diện sang Gemini 2.0 Flash NLU,
- **So that**: Tôi bóc tách được danh sách món ăn, số lượng gram, bữa ăn và bảng calo/macro chính xác.

#### BDD Scenarios (Acceptance Criteria):

```gherkin
Scenario: Phân tích thành công câu nói có nhiều món và đơn vị dân dã
  Given đoạn văn bản nhận dạng được là "Trưa nay ăn 1 đĩa cơm tấm sườn chả và 1 ly trà đá ít đường"
  And thời gian hiện tại là 12:15 trưa
  When gửi yêu cầu tới Gemini 2.0 Flash NLU
  Then hệ thống nhận về kết quả JSON trong thời gian <= 1.0 giây
  And "meal_type" được xác định là "lunch"
  And danh sách món tách riêng:
    | dish_name             | calories | protein_g | carbs_g | fat_g |
    | Cơm tấm sườn chả      | 620      | 28        | 75      | 24    |
    | Trà đá ít đường       | 15       | 0         | 4       | 0     |
  And tổng calo được tính chính xác là 635 kcal

Scenario: Phân tích câu nói không có từ chỉ bữa ăn (Time-of-Day Fallback)
  Given đoạn văn bản là "1 quả chuối và 1 hộp sữa chua không đường"
  And thời điểm ghi nhận là 08:30 sáng
  When Gemini NLU phân tích
  Then "meal_type" tự động gán là "breakfast" dựa theo quy tắc khung giờ
  And tổng calo phản ánh đúng 1 quả chuối (105 kcal) + 1 sữa chua (65 kcal) = 170 kcal
```

---

### US-20.4: Xác Nhận Qua Thẻ GenUI & Lưu 1 Chạm (1-Tap Quick Log)
- **As a**: Người dùng đã nhận diện xong bữa ăn,
- **I want to**: Xem lại bảng tóm tắt dinh dưỡng trên thẻ GenUI và bấm lưu 1 chạm,
- **So that**: Tôi hoàn tất việc ghi nhật ký trong chưa đầy 1 giây mà không cần vào form chi tiết.

#### BDD Scenarios (Acceptance Criteria):

```gherkin
Scenario: Người dùng bấm lưu 1 chạm trên thẻ GenUI MealQuickLogCard
  Given trạng thái "AstroVoiceSheet" chuyển sang "READY"
  And thẻ GenUI hiển thị "Cơm tấm sườn chả - 635 kcal"
  And thanh 3 Macro hiển thị đúng màu Carbs (#1CB0F6), Fat (#FF5C8D), Protein (#FF9600)
  When người dùng chạm nút "⚡ Lưu Vào Bữa Ăn"
  Then hệ thống tạo một FoodLogDto mới
  And lưu vào "FoodLogRepository" thành công trong thời gian < 150ms
  And modal sheet tự động đóng lại
  And vòng cung CalorieProgressArc trên HomePage cập nhật thêm 635 kcal
  And hiển thị SnackBar chúc mừng: "Đã lưu bữa trưa thành công!"
```

---

### US-20.5: Xử Lý Ngoại Lệ Mất Mạng, Tiếng Ồn & Chuyển Sang Nhập Bàn Phím
- **As a**: Người dùng đang ở nơi ồn ào hoặc mạng chập chờn,
- **I want to**: Nhận được thông báo lỗi rõ ràng và có thể chuyển sang gõ chữ ngay,
- **So that**: Tôi không bị mất nội dung vừa nói và không bị ức chế vì ứng dụng treo.

#### BDD Scenarios (Acceptance Criteria):

```gherkin
Scenario: Người dùng không nói gì hoặc môi trường quá ồn không bắt được tiếng
  Given trạng thái là "LISTENING"
  When sau 5 giây không nhận diện được bất kỳ từ nào
  Then trạng thái chuyển sang "EMPTY"
  And hiển thị thông báo: "AstroBite chưa nghe rõ món bạn vừa nói"
  And cung cấp nút "Nói lại" và nút "Gõ bằng bàn phím"

Scenario: Thiết bị mất kết nối mạng khi đang phân tích Gemini NLU
  Given người dùng nói xong nhưng máy bị mất mạng Internet
  When gửi yêu cầu tới Gemini NLU bị timeout hoặc exception
  Then trạng thái chuyển sang "ERROR"
  And hiển thị thẻ báo lỗi: "Không thể kết nối với AI, vui lòng thử lại"
  And văn bản đã nhận dạng vẫn được giữ nguyên trong ô nhập liệu để người dùng không phải nói lại
```
