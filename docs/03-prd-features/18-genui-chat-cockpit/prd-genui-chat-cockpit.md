# Tài Liệu Yêu Cầu Sản Phẩm (PRD) — FEAT-18: Generative UI Chat Cockpit

- **Mã Feature**: `FEAT-18`
- **Mã Epic**: `EPIC-17` (Generative UI Chat Experience)
- **Phiên bản mục tiêu**: `v2.0.0` (Sprint 11)
- **Tác giả**: Sub-Agent Business Analyst (BA) — *"The Pedantic Logician"*
- **Người thẩm định & Phê duyệt**: Sub-Agent Product Owner (PO) — *"The Strategic Tyrant"*
- **Cố vấn Kiến trúc**: Sub-Agent Tech Lead — *"The Pragmatic System Architect"*
- **Cập nhật lần cuối**: 2026-09-26

---

## 🎯 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Measurable KPIs)

### 1.1. Nỗi đau người dùng (Problem Statement)
Trong phiên bản trước, tính năng AstroCoach Chat chỉ phản hồi văn bản tĩnh hoặc dùng cú pháp thẻ markdown thô sơ.
* Người dùng nhận được một đoạn text tư vấn dài dòng (3 - 5 câu), dẫn đến mỏi mắt và lười đọc (Wall of text fatigue).
* Sau khi được AI gợi ý món ăn, người dùng phải tự ghi nhớ rồi chuyển sang tab Diary hoặc Search để gõ lại tên món ➔ Tốn **20 - 35 giây** và dễ dẫn đến bỏ ghi nhật ký (Drop-off rate 40%).
* Chat thiếu tính tương tác 2 chiều và không gắn kết với dữ liệu thể trạng thực tế trong ngày.

### 1.2. Mục tiêu đo lường được (Measurable Success Metrics - CẤM DU DI)
| Chỉ Số Đo Lường | Hiện Tại | Mục Tiêu v2.0.0 (SLA) | Phương Pháp Đo |
| :--- | :---: | :---: | :--- |
| **Time-to-Understand Meal Advice** | 15.0s (đọc text) | **<= 2.0s** (xem Thẻ UI trực quan) | Usability testing thời gian nhận thức thông tin |
| **Time-to-Log Meal qua Chat** | 25.0s | **<= 3.0s** (1-Tap Log) | Thời gian từ khi AI trả về thẻ đến khi lưu nhật ký |
| **Độ trễ First Component (TTFT)** | 3.5s | **<= 1.2s** (Gemini 3.8 Flash Stream) | Benchmark mạng & response telemetry |
| **Tỷ lệ lỗi cú pháp Schema** | ~12% (regex text) | **0.0%** (Strict JSON Schema) | Automated schema validation telemetry |
| **Hiệu năng cuộn bong bóng chat** | 58 FPS | **>= 55 - 60 FPS** (0 rò rỉ RAM) | Flutter DevTools Performance overlay |

---

## 🧭 2. Phân Loại MoSCoW & Ranh Giới Tính Năng (In-Scope vs Out-of-Scope)

### 2.1. In-Scope (Must-Have & Should-Have cho Sprint 11)
* **`US-01` [Must-have]**: **CatalogItem `MealQuickLogCard`** — Hiển thị thẻ món ăn tương tác đầy đủ tên món, calo nổi bật, bộ 3 Macro bất biến (Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`), nút tăng giảm trọng lượng gram và nút CTA [1-Tap Log to Diary].
* **`US-02` [Must-have]**: **CatalogItem `MacroBudgetGauge`** — Biểu đồ phân khúc so sánh calo dự kiến của món ăn với số calo còn lại trong ngày (Remaining Calories), cảnh báo nếu vượt hạn mức.
* **`US-03` [Must-have]**: **GenUI Core Orchestration & Gemini 3.8 Flash Streaming** — Module SurfaceController & A2UI Transport Adapter, parse luồng JSON event từ Gemini 3.8 Flash sang dynamic UI với cơ chế Fallback Markdown an toàn.
* **`US-04` [Should-have]**: **CatalogItem `QuickChoiceChips`** — Dải các chip lựa chọn nhanh (ngữ cảnh bữa ăn, phong cách ăn) kích hoạt tương tác gửi tin nhắn tiếp theo tới AI mà không cần gõ bàn phím.

### 2.2. Out-of-Scope (Strictly Won't-Have — Chống Scope Creep)
* ❌ **AI Dynamic Styling**: Nghiêm cấm AI tự sinh mã CSS, đổi màu gradient tùy tiện; 100% component phải tuân thủ tokens `AppColors` Celestial Dark UI.
* ❌ **Voice / Audio Chat Integration**: Không tích hợp Whisper hoặc Audio Input trong Sprint này.
* ❌ **Community Sharing via Chat**: Không gửi thẻ món ăn sang người dùng khác.

---

## 📋 3. User Stories & Tiêu Chí Nghiệm Thu Chuẩn BDD (Given - When - Then)

### 🍲 US-01: Thẻ Dinh Dưỡng Tương Tác 1-Chạm (MealQuickLogCard)
- **As a**: Người dùng AstroBite đang trò chuyện với AI Coach.
- **I want to**: Nhìn thấy món ăn được tư vấn dưới dạng thẻ trực quan có thể tăng giảm trọng lượng và bấm lưu ngay.
- **So that**: Tôi có thể ghi nhận bữa ăn vào nhật ký mà không cần nhập liệu lại ở màn hình khác.

#### Scenario 1.1: Hiển thị thẻ và bấm 1-Tap Log thành công (Happy Path)
```gherkin
Given người dùng đang ở màn hình AstroCoach Chat
And gửi tin nhắn: "Trưa nay ăn 150g ức gà áp chảo được không?"
When Gemini 3.8 Flash phản hồi một component kiểu "MealQuickLogCard" với:
  | dishName | calories | protein | carbs | fat | weightG | mealType |
  | Ức gà áp chảo | 248 | 46.5 | 0.0 | 5.4 | 150 | lunch |
Then hệ thống dựng thẻ "MealQuickLogCard" với nền GlassCard (#112240)
And 3 Macro hiển thị đúng màu bất biến:
  | Macro | Màu Sắc Hex |
  | Carbs | #1A73E8 |
  | Protein | #FFD700 |
  | Fat | #FF69B4 |
When người dùng nhấn nút "Ghi Vào Nhật Ký" (1-Tap CTA)
Then hệ thống gọi TrackerRepository ghi nhận món vào bữa trưa
And nút bấm chuyển sang trạng thái "✓ Đã ghi nhận" trong vòng < 100ms
And cập nhật lại tổng calo trong ngày của người dùng.
```

#### Scenario 1.2: Người dùng điều chỉnh trọng lượng trên thẻ (Interactive Stepper)
```gherkin
Given thẻ "MealQuickLogCard" đang hiển thị với trọng lượng 150g (248 kcal)
When người dùng bấm nút stepper "+50g"
Then trọng lượng cập nhật thành 200g
And các chỉ số tự động co giãn theo tỷ lệ:
  | Chỉ số | Giá trị mới |
  | Calories | 330 kcal |
  | Protein | 62.0g |
  | Carbs | 0.0g |
  | Fat | 7.2g |
And trạng thái cập nhật mượt mà (60 FPS, không rebuild cả danh sách chat).
```

---

### 📊 US-02: Đồng Hồ Tiến Độ Ngân Sách Calo (MacroBudgetGauge)
- **As a**: Người dùng đang cân nhắc một món ăn phụ hoặc tráng miệng.
- **I want to**: Xem nhanh món ăn này chiếm bao nhiêu phần trăm trong hạn mức calo còn lại.
- **So that**: Tôi kiểm soát được việc không bị ăn lạm calo (Surplus) ngoài ý muốn.

#### Scenario 2.1: Hiển thị đồng hồ trong mức an toàn (Safe Budget)
```gherkin
Given người dùng còn lại 500 kcal trong hạn mức hôm nay
When AI gợi ý món ăn có "projectedCalories" = 300 kcal
And trả về component "MacroBudgetGauge"
Then widget hiển thị thanh đo tiến độ hai lớp:
  | Lớp hiển thị | Giá trị |
  | Calo dự kiến nạp | 300 kcal (Thanh sáng nổi bật #1A73E8) |
  | Calo còn lại sau khi ăn | 200 kcal còn dư (Màu xanh bảo đảm) |
And không có cảnh báo vượt hạn mức.
```

#### Scenario 2.2: Cảnh báo khi món ăn làm vượt ngân sách ngày (Budget Exceeded)
```gherkin
Given người dùng chỉ còn 200 kcal trong ngày
When AI gợi ý món ăn có "projectedCalories" = 450 kcal
Then widget "MacroBudgetGauge" hiển thị phần chênh lệch vượt mức (250 kcal thừa)
And dải màu chuyển sang Tertiary Warning (#FFD700)
And kèm thông báo vi mô: "Vượt 250 calo so với mục tiêu ngày".
```

---

### ⚡ US-03: GenUI Surface Controller & A2UI Streaming Orchestration
- **As a**: Hệ thống AstroBite.
- **I want to**: Phân tích luồng phản hồi streaming từ Gemini 3.8 Flash và dựng component tương thích.
- **So that**: Giao diện hiển thị nhanh tức thì, không bị crash kể cả khi gặp mạng chập chờn.

#### Scenario 3.1: Nhận diện và render luồng A2UI chuẩn xác
```gherkin
Given cuộc hội thoại chat gửi request tới Gemini 3.8 Flash
When luồng dữ liệu trả về chứa payload JSON dạng A2UI Component
Then SurfaceController bóc tách danh sách components và gán vào DataModel
And tìm kiếm component builder trong Catalog
And hiển thị component tương ứng thay thế cho Skeleton Shimmer trong < 1.2s.
```

#### Scenario 3.2: Fallback an toàn khi phản hồi là Text thuần túy hoặc Component lạ
```gherkin
Given Gemini 3.8 Flash trả về phản hồi là văn bản Markdown thông thường (không có component)
When SurfaceController phân tích cú pháp
Then hệ thống tự động fallback hiển thị bong bóng chat tin nhắn Text/Markdown chuẩn
And không có lỗi runtime ngoại lệ (0 crash, 0 freeze UI).
```

---

### 🔘 US-04: Dải Chip Lựa Chọn Nhanh (QuickChoiceChips)
- **As a**: Người dùng đang trò chuyện nhanh bằng một tay.
- **I want to**: Nhấn vào các chip lựa chọn gợi ý sẵn (ví dụ: "Bữa trưa", "Ăn nhiều đạm").
- **So that**: Tôi gửi lệnh cho AI chỉ với một thao tác bấm (Thumb Zone).

#### Scenario 4.1: Bấm chip gửi prompt phản hồi tức thì
```gherkin
Given AI kết thúc phản hồi bằng component "QuickChoiceChips" chứa các lựa chọn:
  | Chip Label | Action Payload |
  | Ức gà | "Tôi chọn ức gà" |
  | Cá hồi | "Tôi chọn cá hồi" |
  | Đậu hũ | "Tôi chọn đậu hũ" |
When người dùng bấm vào chip "Ức gà"
Then chip hiển thị hiệu ứng xúc giác (Haptic feedback)
And hệ thống tự động gửi tin nhắn "Tôi chọn ức gà" vào khung chat
And kích hoạt luồng trả lời tiếp theo từ AI.
```

---

## 🗄️ 4. Data Dictionary (Từ Điển Dữ Liệu Dành Cho GenUI)

### 4.1. Cấu Trúc A2uiComponent DTO
```dart
class A2uiComponent {
  final String id;
  final String type; // 'MealQuickLogCard' | 'MacroBudgetGauge' | 'QuickChoiceChips'
  final Map<String, dynamic> props;
}
```

### 4.2. Props Schema Của Từng Component
1. **`MealQuickLogCard` Props**:
   - `dishName` (String, required): Tên món ăn.
   - `calories` (int, required): Năng lượng (kcal).
   - `protein` (double, required): Gam chất đạm (Protein).
   - `carbs` (double, required): Gam chất bột đường (Carbohydrates).
   - `fat` (double, required): Gam chất béo (Fat).
   - `weightG` (int, optional, default: 100): Trọng lượng ước tính theo gram.
   - `mealType` (String, optional, default: 'snack'): 'breakfast' | 'lunch' | 'dinner' | 'snack'.
2. **`MacroBudgetGauge` Props**:
   - `projectedCalories` (int, required): Lượng calo của món ăn.
   - `remainingCalories` (int, required): Lượng calo còn lại trong ngày.
   - `targetCalories` (int, required): Tổng mục tiêu calo ngày.
3. **`QuickChoiceChips` Props**:
   - `chips` (List<Map<String, String>>, required): Danh sách `[{ "label": "Tên chip", "payload": "Nội dung gửi" }]`.
