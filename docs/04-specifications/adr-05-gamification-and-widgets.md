# ADR-05: Kiến Trúc Gamification (Streak Engine), Mobile Widgets & Cố Vấn Dinh Dưỡng Dài Hạn

- **Trạng thái**: 🟢 **ĐÃ PHÊ DUYỆT (Accepted)**
- **Chủ trì**: Sub-Agent Tech Lead (`tech-lead`) — *"The Pragmatic System Architect"*
- **Người thẩm định**: Sub-Agent Product Owner (PO)
- **Ngày ban hành**: 2026-09-19
- **Phạm vi kỹ thuật**: `EPIC-13` (Gamification & Streak Engine), `EPIC-11` (Mobile Widgets), `EPIC-07-EXT` (AstroCoach Contextual Memory)
- **Phiên bản mục tiêu**: AstroBite `v1.4.0` (Sprint 05)

---

## 1. Bối Cảnh & Vấn Đề Kỹ Thuật (Context & Problem Statement)

AstroBite bước vào Sprint 05 với mục tiêu sống còn là **D30 Retention ≥ 35%**. Để đạt được mục tiêu này, hệ thống cần giải quyết 3 bài toán kiến trúc:

1. **Tính toán Chuỗi Ngày Ăn Sạch (Streak Engine)**:
   - Cần một thuật toán tính chuỗi ngày hoạt động liên tục (Active Streak) chính xác theo múi giờ địa phương (`localDate: YYYY-MM-DD`) của người dùng, không bị lệch khi chuyển đổi giữa UTC và Local Timezone.
   - Hỗ trợ cơ chế **Starlight Shield (Khiên Bảo Vệ Streak)**: Cho phép bỏ lỡ 1 ngày mà không bị đứt chuỗi.
   - Lưu trữ ngoại tuyến (Offline-first): Cập nhật tức thì trên Local Cache và đồng bộ Firestore ngầm (Background Sync).

2. **Đồng Bộ Dữ Liệu Ra Màn Hình Khóa / Màn Hình Chính (Mobile Widgets)**:
   - Dữ liệu Calo còn lại, Carbs/Fat/Protein cần được cập nhật ra Widget ngoài OS (iOS WidgetKit & Android AppWidget) ngay khi người dùng ghi log hoặc khi hệ thống nhận dữ liệu calo tiêu thụ từ Apple Health / Health Connect.
   - Cần hỗ trợ Deep-link `astrobite://scanner` mở thẳng camera AI Scan với độ trễ < 300ms.

3. **Cố Vấn AI Dài Hạn (Contextual Memory & 1-Tap Log)**:
   - Gemini Chat cần nhận được tóm tắt thể trạng (BMR, TDEE, cân nặng, dị ứng, mục tiêu) và dinh dưỡng 3 ngày gần nhất trong System Prompt mà không làm phình to context window.
   - Phản hồi gợi ý món ăn có thể chuyển đổi thành cấu trúc JSON chuẩn `FoodLog` để người dùng lưu trực tiếp vào Firestore chỉ bằng 1 chạm.

---

## 2. Quyết Định Kiến Trúc (Architectural Decisions)

### 2.1. Quyết Định 1: Thuật Toán & Mô Hình Dữ Liệu Streak (Deterministic Streak Calculation)

* **Tiêu chuẩn "Ngày Hợp Lệ" (Active Day)**:
  - Một ngày được tính là "Active Day" nếu người dùng ghi nhận ít nhất **1 bữa ăn (Meal Log)** trong ngày đó (`foodLogs.isNotEmpty`).
  - Đạt điều kiện "Perfect Cosmic Day" (Vòng năng lượng nạp 100%) nếu Calo nạp vào nằm trong khoảng `[Target - 15%, Target + 10%]`.

* **Xử lý Múi Giờ (Timezone Resilient)**:
  - Mọi bản ghi ngày sử dụng định dạng chuỗi chuẩn ISO Date cục bộ: `yyyy-MM-dd` (ví dụ: `2026-09-19`).
  - Không dựa vào `DateTime.now().day` thuần túy để so sánh chênh lệch thời gian, mà dùng chuẩn ngày chuẩn hóa `DateTime(year, month, day)`.

* **Cấu trúc thực thể `StreakRecord` (Domain Layer)**:
```dart
@freezed
class StreakRecord with _$StreakRecord {
  const factory StreakRecord({
    required int currentStreak,          // Số ngày liên tiếp hiện tại
    required int longestStreak,          // Kỷ lục chuỗi dài nhất
    required String lastActiveDate,      // yyyy-MM-dd của ngày log gần nhất
    required int starlightShields,       // Số khiên bảo vệ còn lại (tối đa 2)
    required List<String> activeDates,   // Danh sách 30 ngày gần nhất có log
    required List<String> unlockedBadgeIds, // Danh sách ID huy hiệu đã mở
    required DateTime updatedAt,
  }) = _StreakRecord;
}
```

* **Logic Cập Nhật Chuỗi (State Transition)**:
  - Khi có meal log mới trong ngày $D$:
    - Nếu $D == lastActiveDate$: Giữ nguyên `currentStreak` (đã tính ngày hôm nay).
    - Nếu $D == lastActiveDate + 1$: `currentStreak += 1`. Cập nhật `longestStreak = max(longestStreak, currentStreak)`.
    - Nếu $D > lastActiveDate + 1$:
      - Khoảng cách $Gap = D - lastActiveDate - 1$.
      - Nếu $Gap == 1$ và $starlightShields > 0$: Tiêu hao 1 khiên (`starlightShields -= 1`), duy trì chuỗi `currentStreak += 1` kèm cờ thông báo `shieldConsumed = true`.
      - Ngược lại: Đứt chuỗi, gán `currentStreak = 1`.

---

### 2.2. Quyết Định 2: Kiến Trúc Đồng Bộ Mobile Widget (`home_widget`)

* **Lựa chọn Thư Viện**:
  - Áp dụng nguyên tắc **Ponytail (Ngắn gọn, chuẩn stdlib/plugin phổ quát)**: Sử dụng package [`home_widget`](https://pub.dev/packages/home_widget) đã được kiểm chứng cho Flutter.
  - Dữ liệu được serialize dưới dạng Key-Value trong SharedPreferences (Android) và AppGroup UserDefaults (iOS).

* **Dữ liệu chia sẻ qua AppGroup / SharedPreferences**:
```json
{
  "remainingCalories": 650,
  "targetCalories": 2200,
  "consumedCalories": 1550,
  "carbsGrams": 180,
  "fatGrams": 45,
  "proteinGrams": 110,
  "currentStreak": 5,
  "lastUpdated": "2026-09-19T14:30:00Z"
}
```

* **Đồng Bộ Tự Động (Reactive Sync)**:
  - Khi `dailySummaryNotifierProvider` hoặc `streakNotifierProvider` thay đổi trạng thái, một Listener ngầm kích hoạt `HomeWidget.saveWidgetData()` và gọi `HomeWidget.updateWidget()`.
  - Không tạo background service liên tục gây hao pin; chỉ cập nhật khi app có thay đổi dữ liệu hoặc push notification ngầm.

---

### 2.3. Quyết Định 3: AstroCoach Contextual Prompt & 1-Tap Log Engine

* **System Prompt Tối Giản (Ponytail Context Injection)**:
  - Chỉ nhúng thông tin cốt lõi (tối đa 250 tokens):
  ```
  User Profile: [Age: 28, Gender: Male, Weight: 72kg, Goal: Fat Loss, TDEE: 2150 kcal].
  Today Summary: [Consumed: 1200 kcal, Remaining: 950 kcal, Protein: 65g/140g].
  Dietary Restrictions: [No peanuts, Low lactose].
  ```
* **Cấu Trúc Gợi Ý 1-Tap Log (Actionable Metadata)**:
  - Khi gợi ý món ăn cụ thể, Gemini đính kèm block JSON ẩn hoặc thẻ định danh:
  ```json
  <!--astrobite-food:{"name":"Ức gà áp chảo","calories":250,"protein":31.0,"carbs":0.0,"fat":3.5,"servingSize":"150g","mealType":"lunch"}-->
  ```
  - Giao diện `ChatBubble` bắt regex thẻ này và tự động render nút bấm Celestial Button: **[+ Thêm Vào Bữa Trưa (250 kcal)]**. Khi bấm, gọi trực tiếp `foodLogRepository.createLog()`.

---

## 3. Đánh Giá Hiệu Năng & SLAs (Feasibility & Benchmarks)

| Hạng Mục | Tiêu Chuẩn Cam Kết (SLA) | Giải Pháp Kiến Trúc Đảm Bảo |
|:---|:---:|:---|
| **Streak Evaluation Latency** | **< 30ms** | Tính toán thuần túy in-memory Dart; đọc từ Local SQLite/SharedPreferences trước khi sync Firebase. |
| **Cosmic Energy Ring FPS** | **≥ 58 FPS** | Sử dụng `CustomPainter` kết hợp `RepaintBoundary` cô lập; không repaint lại toàn bộ HomePage khi kim tiến độ quay. |
| **Widget Update Latency** | **< 100ms** | Ghi bất đồng bộ xuống Key-Value Store nền tảng ngay sau khi `DailySummary` tính xong. |
| **Deep-link Scanner Launch** | **< 400ms** | AutoRoute điều hướng trực tiếp tới `FoodScannerRoute` bỏ qua các bước trung gian. |

---

## 4. Ký Duyệt Kiến Trúc (Architecture Sign-Off)

- **Tech Lead**: *Sub-Agent Tech Lead ("The Pragmatic System Architect")* — **APPROVED**
- **Đánh giá**: Kiến trúc tuân thủ triệt để nguyên tắc **Ponytail** (tận dụng code có sẵn, không đẻ microservices, không thư viện rác, độ trễ tối thiểu). Sẵn sàng chuyển giao cho Sub-Agent BA và UI/UX Designer.
