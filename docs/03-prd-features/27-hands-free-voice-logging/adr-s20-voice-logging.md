# Architecture Decision Record (ADR-S20-VOICE-LOG)
# Thiết Kế Kiến Trúc Hệ Thống Ghi Nhật Ký Bằng Giọng Nói (AstroVoice AI)

- **Trạng thái**: 🟢 **PROPOSED (Chờ Hội Đồng Tech Lead & PO Duyệt)**
- **Ngày quyết định**: 05/10/2026
- **Sprint**: Sprint 20
- **Phiên bản mục tiêu**: `v3.0.0`
- **Người đề xuất**: Sub-Agent Tech Lead (`tech-lead`) & Sub-Agent PO (`product-owner`)
- **Phạm vi**: `features/voice_log` (hoặc `features/voice`), `shared/ui_kit`, `core/services`

---

## 1. Bối Cảnh & Vấn Đề (Context & Problem Statement)

AstroBite hiện sở hữu 2 phương thức ghi nhận thức ăn:
1. **Camera AI Scanner**: Cực kỳ mạnh mẽ với thị giác máy tính, bóc tách nước dùng và topping món Việt trong 1.85s (Sprint 19). Tuy nhiên, phương thức này đòi hỏi người dùng phải có món ăn trước mặt.
2. **Manual Food Entry**: Nhập tay, chọn khẩu phần qua Slider/Quick Steppers. Tuy nhiên, luồng này tốn từ 30–50 giây, gây rào cản tâm lý rất lớn cho người dùng bận rộn (đang lái xe, nấu nướng, hoặc nhớ lại bữa ăn sau khi đã rời quán).

**Mục tiêu Sprint 20 (`v3.0.0`)**: 
Xây dựng tính năng **AstroVoice AI (Hands-Free Voice Logging)** cho phép người dùng chỉ cần bấm giữ hoặc chạm Mic và nói 1 câu tự nhiên bằng tiếng Việt (VD: *"Trưa nay ăn 1 đĩa cơm tấm sườn chả với 1 ly trà đá ít đường"*), hệ thống tự động nhận diện giọng nói, phân tích ngữ nghĩa qua Gemini 2.0 Flash NLU và trả về thẻ GenUI `MealQuickLogCard` để lưu 1-Tap trong vòng **$\le 1.5$ giây**.

---

## 2. Các Phương Án Kỹ Thuật Đã Đánh Giá (Options Analysis)

### 🔴 Phương Án 1: Thu âm file Audio raw (`record`) ➔ Gửi trực tiếp lên Gemini 2.0 Flash Multimodal Audio
- **Cơ chế**: Dùng thư viện thu âm file `.m4a` / `.wav`, upload binary audio lên Gemini API và chờ Gemini vừa nghe vừa dịch và trích xuất dinh dưỡng.
- **Ưu điểm**: 1 API call duy nhất từ audio ra JSON.
- **Nhược điểm**:
  - Độ trễ lớn: Upload 200KB audio qua 4G mất ~1.2s + Gemini xử lý âm thanh mất ~2.0s = **Tổng độ trễ $\ge 3.2s$** (vi phạm SLA $\le 2.0s$).
  - Không có phản hồi trực quan thời gian thực (User nói vào màn hình mà không thấy chữ chạy ra, cảm giác bị đơ/lag).
  - Tốn băng thông dữ liệu di động của người dùng.

### 🟢 Phương Án 2 (ĐƯỢC CHỌN - Chuẩn Ponytail): On-Device Speech Recognition (`speech_to_text`) + Gemini 2.0 Flash Text NLU
- **Cơ chế**:
  1. Sử dụng thư viện `speech_to_text: ^7.0.0` tích hợp trực tiếp Engine nhận diện giọng nói bản địa của OS (Apple Speech Framework trên iOS, Google Speech Recognizer trên Android) với locale `vi-VN`.
  2. Văn bản hiển thị dạng streaming trực tiếp trên màn hình theo thời gian thực (Live Text Feedback).
  3. Khi người dùng kết thúc câu nói (hoặc nhả Mic), văn bản dạng chuỗi tinh gọn (~50 bytes) được chuyển tới Gemini 2.0 Flash NLU Prompt chuyên biệt.
  4. Gemini trả về JSON dinh dưỡng trong vòng **0.8s – 1.0s**.
  5. Thẻ GenUI `MealQuickLogCard` render lập tức với nút 1-Tap Log.
- **Ưu điểm vượt trội**:
  - **Siêu nhanh**: Tổng độ trễ toàn trình chỉ từ **$\sim 1.1s - 1.4s$** (đạt xuất sắc SLA $\le 1.5s$).
  - **Băng thông siêu nhẹ**: Gửi vài chục bytes text thay vì hàng trăm kilobytes audio.
  - **Chi phí tối thiểu (Zero Speech Cost)**: STT chạy on-device 100% miễn phí, chỉ tính token văn bản siêu rẻ của Gemini Flash.
  - **Trải nghiệm WOW**: Người dùng nhìn thấy giọng nói biến thành chữ ngay lập tức, có thể chạm sửa nhanh nếu phát âm sai tên quán hoặc tên món đặc thù.

---

## 3. Kiến Trúc Hệ Thống (Feature-First Clean Architecture)

```
lib/features/voice/
├── data/
│   ├── datasources/
│   │   ├── voice_recognition_service.dart   # Bọc speech_to_text, abstract interface
│   │   └── gemini_voice_nlu_datasource.dart # Gemini 2.0 Flash NLU prompt & parser
│   └── repositories/
│       └── voice_log_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── voice_log_result.dart            # Chứa transcript, parsed dishes, macros
│   └── repositories/
│       └── voice_log_repository.dart
└── presentation/
    ├── controllers/
    │   └── voice_log_controller.dart        # Riverpod AsyncNotifier (Listening -> Parsing -> Ready)
    └── widgets/
        ├── astro_voice_sheet.dart           # ClaySheet chứa hiệu ứng sóng âm & GenUI Card
        ├── voice_pulsing_mic_button.dart    # Nút Mic Claymorphic hiệu ứng lan tỏa sóng âm
        └── live_transcript_bubble.dart      # Bong bóng hiển thị văn bản trực tiếp
```

---

## 4. Kỷ Luật Ponytail & Thiết Kế Kháng Lỗi (Resilience & Testability)

1. **Thiết Kế Kháng Lỗi Kiểm Thử (Headless Testing)**:
   - `VoiceRecognitionService` được thiết kế dưới dạng abstract class với implementation `SpeechToTextRecognitionService` (runtime) và `FakeVoiceRecognitionService` (unit/widget test).
   - Tuyệt đối không để xảy ra lỗi `MissingPluginException` khi chạy test CI tự động (`flutter test`).
2. **Quy Tắc Nhận Diện Bữa Ăn Theo Giờ Mặc Định (Time-of-Day Fallback)**:
   - Nếu câu nói của người dùng không nhắc đến bữa (VD chỉ nói: *"2 quả chuối và 1 hộp sữa chua"*):
     - 05:00 – 10:30 ➔ Bữa sáng (`breakfast`)
     - 10:31 – 14:00 ➔ Bữa trưa (`lunch`)
     - 14:01 – 17:30 ➔ Bữa phụ (`snack`)
     - 17:31 – 22:00 ➔ Bữa tối (`dinner`)
     - 22:01 – 04:59 ➔ Bữa khuya / Bữa phụ (`snack`)
3. **Tái Sử Dụng Triệt Để GenUI Sẵn Có**:
   - Tái sử dụng trực tiếp `MealQuickLogCard` và `A2uiParser` từ Sprint 11, không viết lại thẻ hiển thị dinh dưỡng từ đầu.
4. **Phản Hồi Xúc Giác & Âm Thanh (Sensory Polish)**:
   - Kích hoạt `HapticFeedback.mediumImpact()` khi bắt đầu nghe và `HapticFeedback.lightImpact()` khi AI hoàn tất phân tích.

---

## 5. Quyết Định Của Tech Lead & Phê Duyệt Của PO
- **Tech Lead**: Ký duyệt phương án STT On-Device + Gemini Flash NLU.
- **Product Owner**: Ký duyệt phạm vi Sprint 20 cho mốc phát hành `v3.0.0`.
