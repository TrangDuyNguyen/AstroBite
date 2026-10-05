# PRD: Sprint 20 - Hands-Free Voice Logging (AstroVoice AI)

- **Mã Epic**: `EPIC-VOICE`
- **Mã Feature**: `FEAT-S20-VOICE-LOG`
- **Người soạn thảo**: Sub-Agent Business Analyst (BA) — *The Pedantic Logician*
- **Người thẩm định**: Sub-Agent Product Owner (PO) — *The Strategic Tyrant* & Sub-Agent Tech Lead
- **Trạng thái**: 🟡 Submitted for Gate 1 Review
- **Phiên bản mục tiêu**: `v3.0.0`
- **Đối chiếu QA**: `test/features/voice/`
- **Đối chiếu FE**: `lib/features/voice/`

---

## 1. Bối Cảnh Nghiệp Vụ & Nỗi Đau Người Dùng (Problem Statement)

1. **Rào Cản Nhập Liệu Chậm (High Input Friction)**:
   - Ghi nhật ký thủ công (`ManualEntryPage`) tốn từ **35 – 55 giây**: Mở app ➔ Chuyển tab ➔ Gõ tìm kiếm từng món ➔ Chọn đơn vị gram ➔ Lặp lại với từng món phụ hoặc đồ uống.
   - Máy quét hình ảnh (`CameraScannerPage`) rất nhanh (~2s), nhưng bắt buộc người dùng phải có đĩa thức ăn vật lý ngay trước ống kính camera.
2. **Ngữ Cảnh Sử Dụng Thực Tế (Real-World Use-Cases)**:
   - Người dùng thường nhớ ra việc ghi chép sau khi đã ăn xong và rời khỏi quán, khi đang lái xe máy/ô tô, đang bế con, hoặc đang dọn dẹp bếp. Trong các bối cảnh này, việc chụp ảnh là bất khả thi và việc gõ bàn phím rất bất tiện và nguy hiểm.
3. **Thói Quen Ngôn Ngữ Dân Dã Của Người Việt**:
   - Người Việt nói chuyện ăn uống theo thói quen tự nhiên: *"Sáng nay ăn tô phở bò tái nạm nhiều hành, 2 quẩy với ly cà phê sữa ít ngọt"*. Họ không bao giờ nhớ hoặc muốn tra cứu "100g bánh phở luộc" hay "50g thịt bò".

👉 **Giải pháp**: Xây dựng tính năng **AstroVoice AI**, biến giọng nói tự nhiên thành dữ liệu dinh dưỡng chuẩn xác, cho phép ghi nhận bữa ăn hoàn chỉnh trong vòng **dưới 3 giây** mà không cần gõ một phím nào.

---

## 2. Mục Tiêu Nghiệp Vụ Đo Lường Được (OKRs & Success Metrics)

* **M1 (Bùng Nổ Tần Suất Ghi Chép - Logging Frequency)**: Tăng số lượng nhật ký bữa ăn trung bình trên mỗi Active User từ **2.1 lần/ngày ➔ 3.4 lần/ngày** (+62%) nhờ loại bỏ ma sát nhập liệu.
* **M2 (Cắt Giảm Thời Gian Time-to-Log Tối Đa)**: Giảm thời gian hoàn thành 1 lượt ghi nhận bữa ăn từ 45s xuống **dưới 3 giây** (nói 1.5s + AI xử lý 1.0s + chạm lưu 0.1s).
* **M3 (Độ Trễ Hệ Thống SLA Toàn Trình)**: Tổng thời gian từ thời điểm dứt tiếng nói (Speech End) đến khi Thẻ GenUI hiển thị sẵn sàng **≤ 1.5 giây**.
* **M4 (Độ Chính Xác Bóc Tách Thực Phẩm NLU)**: Đạt tỷ lệ phân loại đúng món ăn, số lượng và bữa ăn **≥ 90%** trên tập 50 câu nói tiếng Việt phổ thông và địa phương (Bắc, Trung, Nam).

---

## 3. Chân Dung Người Dùng Mục Tiêu (Target Personas)

1. **Persona A: Dân Văn Phòng Bận Rộn (Busy Professional)**:
   - Ăn trưa vội, về đến văn phòng mới nhớ ra chưa ghi nhật ký.
   - Hành vi: Nhấn giữ nút Mic trên màn hình chính, nói nhanh 1 câu trong 2 giây rồi bấm lưu tức thì.
2. **Persona B: Tài Xế / Người Di Chuyển Thường Xuyên (Commuter / Driver)**:
   - Đang lái xe hoặc trên đường, không thể nhìn chằm chằm vào màn hình hoặc gõ chữ.
   - Hành vi: Bật chế độ giọng nói, nói rảnh tay (Hands-free) và nghe/nhìn thẻ tổng kết nhanh.
3. **Persona C: Gymer / Người Thực Hiện Chế Độ Ăn Khắt Khe**:
   - Thường uống Whey protein, ăn chuối, các bữa phụ nhiều lần trong ngày.
   - Hành vi: Đọc nhanh các món ăn vặt ("1 muỗng whey vị vani pha 300ml nước") để không quên calo bữa phụ.

---

## 4. Luồng Trải Nghiệm Người Dùng (User Flow)

```
[Màn hình chính HomePage / ManualEntryPage]
                      │
                      ▼ (Chạm nút Mic nổi hoặc thanh tìm kiếm giọng nói)
          [Mở AstroVoiceSheet (ClaySheet)]
                      │
     ┌────────────────┴────────────────┐
     ▼                                 ▼
[Chưa Cấp Quyền Mic]          [Đã Cấp Quyền Mic]
- Hiển thị Dialog xin quyền    - Rung haptic nhẹ (mediumImpact)
- Nút "Cho phép sử dụng Mic"   - Bắt đầu lắng nghe (LISTENING)
                                       │
                                       ▼
                       [Người dùng nói tiếng Việt]
                       - Sóng âm Pulsing Ripple dao động theo âm lượng
                       - Dòng chữ chạy thời gian thực (Live Transcript)
                                       │
                                       ▼ (Ngừng nói sau 1.2s hoặc bấm "Xong")
                       [Trạng thái PARSING (Gemini 2.0 Flash NLU)]
                       - Shimmer loader êm dịu (Thời gian: ~0.8s - 1.0s)
                                       │
                                       ▼
                       [Trạng thái READY (Thành công)]
                       - Rung haptic nhẹ (lightImpact)
                       - Render thẻ GenUI `MealQuickLogCard`
                       - Hiển thị: Bữa ăn (Sáng/Trưa/Tối), Tên món, Khẩu phần, Calo, 3 Macro
                                       │
                                       ▼
                       [Nút bấm 3D "Lưu Vào Nhật Ký (1-Tap)"]
                       - Ghi vào FoodLogRepository trong < 150ms
                       - Đóng sheet, cập nhật tức thì CalorieProgressArc & Cockpit
```

---

## 5. Danh Sách Yêu Cầu Chức Năng (Functional Requirements - FR)

### FR-01: Điểm Kích Hoạt & Cấp Quyền (Entry Points & Permissions)
- Nút Mic nổi (`VoicePulsingMicButton`) xuất hiện ở:
  1. Góc dưới bên phải màn hình `HomePage` (trên thanh Cockpit).
  2. Bên trong thanh tìm kiếm của `ManualEntryPage`.
  3. Tích hợp trong quick action của `CoachPage`.
- Khi người dùng chạm vào lần đầu, hệ thống kiểm tra quyền:
  - Nếu chưa có quyền: Hiển thị hộp thoại xin cấp quyền rõ ràng theo tiêu chuẩn OS (`RECORD_AUDIO` trên Android, `NSMicrophoneUsageDescription` trên iOS).
  - Nếu bị từ chối vĩnh viễn: Hiển thị nút dẫn tới Cài đặt máy (App Settings).

### FR-02: Nhận Diện Giọng Nói Thời Gian Thực (On-Device Speech-to-Text)
- Sử dụng Speech Engine on-device qua `speech_to_text` với locale cố định `vi-VN` (tiếng Việt).
- Hiển thị bong bóng văn bản thời gian thực (`LiveTranscriptBubble`) ngay khi người dùng cất giọng.
- Tự động phát hiện khoảng lặng (Silence Timeout): Nếu người dùng ngừng nói trong **1.2 giây**, hệ thống tự động hoàn tất câu và chuyển sang bước phân tích.
- Nút "Dừng / Xong" để người dùng chủ động kết thúc câu nói sớm.

### FR-03: Động Cơ Phân Tích Ngôn Ngữ Dinh Dưỡng (Gemini 2.0 Flash NLU Engine)
- Gửi văn bản nhận diện được kèm theo thời gian hiện tại (`DateTime.now()`) lên Gemini 2.0 Flash.
- Trích xuất cấu trúc dữ liệu JSON chuẩn mực bao gồm:
  - `meal_type`: `breakfast`, `lunch`, `dinner`, `snack`.
  - `total_calories`, `protein_g`, `carbs_g`, `fat_g`, `sodium_mg`.
  - `dishes`: Danh sách các món con kèm trọng lượng ước tính (grams).
- **Quy tắc suy luận bữa ăn theo giờ mặc định (Time-of-Day Fallback)**:
  - Nếu câu nói chứa từ khóa bữa (VD: "sáng", "trưa", "tối", "xế", "đêm") ➔ Ưu tiên ánh xạ từ khóa.
  - Nếu câu nói KHÔNG chứa từ khóa bữa:
    - `05:00 – 10:30` ➔ `breakfast` (Bữa sáng)
    - `10:31 – 14:00` ➔ `lunch` (Bữa trưa)
    - `14:01 – 17:30` ➔ `snack` (Bữa phụ chiều)
    - `17:31 – 22:00` ➔ `dinner` (Bữa tối)
    - `22:01 – 04:59` ➔ `snack` (Bữa khuya)

### FR-04: Thẻ Xác Nhận GenUI & Lưu 1 Chạm (A2UI MealQuickLogCard)
- Tái sử dụng thành phần GenUI `MealQuickLogCard` đã được chứng minh hiệu quả trong Sprint 11.
- Hiển thị đầy đủ:
  - Tên món tổng hợp hoặc danh sách món.
  - Huy hiệu bữa ăn (`ClayMealChip` màu pastel tương ứng).
  - Vòng calo và 3 thanh macro (Carbs, Protein, Fat) theo màu sắc bất biến: Carbs `#1CB0F6`, Fat `#FF5C8D`, Protein `#FF9600`.
- Nút bấm chính: `[⚡ Lưu Vào Bữa Ăn]` màu xanh Duolingo 3D, lưu vào `FoodLogRepository` và phát tín hiệu đồng bộ Cockpit ngay lập tức.
- Nút phụ: `[✏️ Sửa Lại]` cho phép mở `ManualEntryPage` hoặc `ScanReviewPage` với các trường đã được điền sẵn nếu người dùng muốn điều chỉnh số gram.

### FR-05: Xử Lý 5 Trạng Thái Giao Diện Bắt Buộc (5 UI States)
1. **Listening**: Hiệu ứng lan tỏa sóng âm (Pulsing Ripple) với màu `AppColors.primary`, chữ live stream.
2. **Parsing**: Hiệu ứng Shimmer `ClaySkeletonLoader` với thông điệp *"AstroBite AI đang tính toán dinh dưỡng..."*.
3. **Ready**: Hiển thị trọn vẹn thẻ GenUI sẵn sàng lưu.
4. **Empty**: Khi không nhận được âm thanh hoặc người dùng chỉ nói tiếng ồn vô nghĩa ➔ Thông báo *"Không nghe rõ, vui lòng thử lại"* kèm nút Mic để nói lại.
5. **Error**: Khi mất kết nối internet hoặc API Gemini quá tải ➔ Thông báo lỗi thân thiện kèm ô gõ text để người dùng tự nhập tay câu nói mà không bị mất công.

---

## 6. Yêu Cầu Phi Chức Năng (Non-Functional Requirements - NFR)

- **NFR-01 (Thời Gian Phản Hồi)**: Toàn trình từ khi ngừng nói đến khi thẻ GenUI hiển thị không vượt quá **1.5 giây**.
- **NFR-02 (Tốc Độ Khung Hình)**: Animation sóng âm và hiệu ứng chuyển trạng thái đạt **≥ 55 FPS**.
- **NFR-03 (Bảo Mật Quyền Riêng Tư PII)**:
  - Audio giọng nói chỉ xử lý on-device qua Speech Recognizer của OS, tuyệt đối không gửi file âm thanh thô lên bất kỳ server đám mây nào.
  - Chỉ gửi đoạn text văn bản đã chuyển đổi sang Gemini API.
- **NFR-04 (Zero Memory Leak & Test Isolation)**:
  - Toàn bộ Speech Stream Controller và Animation Controller phải được `dispose()` sạch sẽ khi đóng modal sheet.
  - Tạo `FakeVoiceRecognitionService` cách ly hoàn toàn kiểm thử tự động, không để phát sinh lỗi `MissingPluginException`.

---

## 7. Ma Trận Đối Soát Nghiệp Vụ (Traceability Matrix)

| Yêu Cầu Chức Năng | User Story Tương Ứng | Thành Phần Triển Khai | Kiểm Thử Nghiệm Thu |
|:---|:---:|:---|:---:|
| FR-01: Entry Point & Permission | US-20.1 | `VoicePulsingMicButton`, Permission Handler | `TC-S20-01` |
| FR-02: Live STT Streaming | US-20.2 | `VoiceRecognitionService`, `LiveTranscriptBubble` | `TC-S20-02` |
| FR-03: Gemini 2.0 Flash NLU | US-20.3 | `GeminiVoiceDatasource`, Prompt Engine | `TC-S20-03` |
| FR-04: GenUI & 1-Tap Save | US-20.4 | `AstroVoiceSheet`, `MealQuickLogCard` | `TC-S20-04` |
| FR-05: 5 Trạng Thái & Lỗi | US-20.5 | 5 States trong `VoiceLogController` | `TC-S20-05` |
