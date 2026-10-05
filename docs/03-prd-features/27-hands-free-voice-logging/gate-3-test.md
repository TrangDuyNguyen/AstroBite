# Kế Hoạch & Ma Trận Kiểm Thử Gate 3 (Master Test Plan & BVA Matrix)
# Hands-Free Voice Logging (AstroVoice AI)

- **Mã Epic**: `EPIC-VOICE`
- **Mã Feature**: `FEAT-S20-VOICE-LOG`
- **Tác giả**: Sub-Agent QA / QC Lead (`qa-tester`) — *The Paranoid Inquisitor*
- **Đối chiếu Nghiệp vụ**: [`prd-s20-voice.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/27-hands-free-voice-logging/prd-s20-voice.md) & [`user-stories.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/27-hands-free-voice-logging/user-stories.md)
- **Đối chiếu Thiết kế**: [`ui-ux-design.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/27-hands-free-voice-logging/ui-ux-design.md)
- **Phiên bản mục tiêu**: `v3.0.0`
- **Khẩu hiệu**: *"Mọi dòng code đều có lỗi, trừ khi được chứng minh qua 100% test pass thực chất và 0 fake green test."*

---

## 1. Ma Trận Phân Vùng Tương Đương & Phân Tích Giá Trị Biên (EP & BVA Matrix)

| Mã TC | Phân Loại | Kịch Bản & Đầu Vào Kiểm Thử (Input / Action) | Kỳ Vọng Đầu Ra Nghiệm Thu (Expected Result) | Truy Xuất US |
|:---|:---:|:---|:---|:---:|
| `TC-S20-01` | EP (Quyền) | Người dùng bấm nút Mic lần đầu & Từ chối cấp quyền Mic | Không crash, đóng modal, hiển thị SnackBar hướng dẫn mở Cài đặt | `US-20.1` |
| `TC-S20-02` | EP (Streaming) | Người dùng nói câu tiếng Việt: "1 tô phở bò tái nạm" | Chữ stream ra `LiveTranscriptBubble` theo từng cụm từ thời gian thực | `US-20.2` |
| `TC-S20-03` | BVA (Timeout) | Người dùng ngừng nói quá 1.2s | Hệ thống tự động chuyển trạng thái từ `LISTENING` sang `PARSING` | `US-20.2` |
| `TC-S20-04` | EP (Đa món) | Câu nói đa món: "1 đĩa cơm sườn, 2 cái quẩy, 1 ly trà đá ít ngọt" | Gemini NLU bóc tách đúng 3 món con, gán đúng gram và tính tổng calo | `US-20.3` |
| `TC-S20-05` | EP (Quy tắc giờ) | Câu nói KHÔNG chỉ định bữa: "1 quả chuối, 1 hộp sữa chua" lúc 8:00 sáng | Tự động ánh xạ `meal_type` thành `breakfast` (Sáng) | `US-20.3` |
| `TC-S20-06` | BVA (Đơn vị lạ) | Câu nói chứa từ lóng/đơn vị dân dã: "làm tô bún riêu đầy đặn" | NLU ánh xạ trọng lượng hợp lý (~550g - 650g), calo ước tính đúng biên | `US-20.3` |
| `TC-S20-07` | EP (1-Tap Log) | Chạm nút 3D "⚡ Lưu Vào Bữa Ăn" trên thẻ `MealQuickLogCard` | Lưu vào `FoodLogRepository` trong $< 150ms$, đóng sheet, cập nhật Cockpit | `US-20.4` |
| `TC-S20-08` | BVA (Im lặng) | Người dùng mở Mic nhưng không nói gì sau 5 giây | Chuyển sang trạng thái `EMPTY`, hiển thị nút "Nói lại" & "Gõ phím" | `US-20.5` |
| `TC-S20-09` | Phá Hoại (Mất mạng) | Đang gửi text lên Gemini thì rớt mạng Internet (SocketException) | Chuyển sang trạng thái `ERROR`, giữ nguyên văn bản vừa nhận dạng | `US-20.5` |
| `TC-S20-10` | Headless Test | Chạy widget test và unit test trên môi trường CI không có Microphone | `FakeVoiceRecognitionService` hoạt động hoàn hảo, 0 MissingPluginException | Toàn bộ |

---

## 2. Kịch Bản BDD Gherkin Chi Tiết (`test/features/voice/voice_logging.feature`)

```gherkin
Feature: Hands-Free Voice Logging (AstroVoice AI)

  Background:
    Given Người dùng đã đăng nhập với tài khoản hợp lệ
    And Hệ thống đã cấu hình FakeVoiceRecognitionService cho môi trường test

  Scenario: TC-S20-04: Bóc tách câu nói đa món Việt Nam chính xác
    Given Màn hình AstroVoiceSheet đang mở ở trạng thái LISTENING
    When Giọng nói nhận diện được chuỗi: "1 tô phở bò tái nạm và 2 cái quẩy"
    And Người dùng dừng nói trong 1.2 giây
    Then Trạng thái chuyển sang PARSING
    And Sau 0.8 giây Gemini NLU trả về dữ liệu dinh dưỡng:
      | dish_name         | calories | protein_g | carbs_g | fat_g |
      | Phở bò tái nạm    | 520      | 28.0      | 65.0    | 16.0  |
      | Quẩy (2 cái)      | 160      | 3.0       | 22.0    | 7.0   |
    And Tổng calo hiển thị trên thẻ GenUI là 680 kcal
    And Trạng thái giao diện chuyển thành READY

  Scenario: TC-S20-07: Lưu nhật ký 1 chạm và đóng Sheet tức thì
    Given Trạng thái AstroVoiceSheet đang là READY với bữa ăn 680 kcal
    When Người dùng chạm vào nút Duolingo 3D "Lưu Vào Bữa Ăn"
    Then Nhật ký mới được ghi vào FoodLogRepository với source là "voice_log"
    And Modal Sheet đóng lại trong vòng dưới 200ms
    And Vòng cung CalorieProgressArc cập nhật tăng thêm 680 kcal
```

---

## 3. Tiêu Chí Nghiệm Thu SLAs Phi Chức Năng (Non-Functional Gates)

1. **AI Round-Trip Latency**: Thời gian xử lý NLU của Gemini 2.0 Flash đối với đoạn text $\le 1.0s$ (toàn trình từ ngắt giọng $\le 1.5s$).
2. **Animation FPS**: Sóng âm dao động $\ge 55$ FPS, không gây giật lag khi người dùng đang nói.
3. **Memory Leaks**: 0 rò rỉ RAM (triệt tiêu `StreamSubscription` và `AnimationController`).
4. **Pass Rate**: 100% tests vượt qua thực chất (Bao gồm 266 bài test hồi quy + bộ test mới của Sprint 20).
