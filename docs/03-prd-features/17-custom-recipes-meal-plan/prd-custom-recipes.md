# Tài Liệu Yêu Cầu Sản Phẩm (PRD) — FEAT-17: Custom Recipes & Meal Planning Architecture

- **Mã Feature**: `FEAT-17`
- **Mã Epic**: `EPIC-12` (Custom Recipes & Meal Plans)
- **Phiên bản mục tiêu**: `v1.9.0` (Sprint 10)
- **Tác giả**: Sub-Agent Business Analyst (BA) — *"The Pedantic Logician"*
- **Người thẩm định & Phê duyệt**: Sub-Agent Product Owner (PO) — *"The Strategic Tyrant"*
- **Cập nhật lần cuối**: 2026-09-25

---

## 🎯 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Measurable KPIs)

### 1.1. Nỗi đau người dùng (Problem Statement)
Người dùng thực hiện chế độ ăn kiêng (Eat-clean, Gym, Keto, Calorie Deficit) thường nấu nướng tại nhà theo mẻ (Meal-prep) hoặc chế biến các món kết hợp nhiều nguyên liệu (ví dụ: Bát salad ức gà quinoa bơ, sinh tố whey chuối yến mạch). 
- Hiện tại trên AstroBite, người dùng phải nhập từng nguyên liệu riêng lẻ vào nhật ký mỗi bữa, mất từ **35 - 50 giây** cho một bữa ăn.
- Khi lặp lại các món quen thuộc hàng ngày, việc nhập lại gây ma sát tương tác rất lớn, dẫn đến hiện tượng bỏ ghi nhật ký (Diary Churn) sau 7-10 ngày.

### 1.2. Mục tiêu đo lường được (Measurable Success Metrics)
| Chỉ Số Đo Lường | Hiện Tại | Mục Tiêu v1.9.0 (SLA) | Phương Pháp Đo |
| :--- | :---: | :---: | :--- |
| **Time-to-Log Recipe Meal** | 45.0s | **<= 4.0s** (1-Tap Log) | Stopwatch từ khi mở màn hình tới khi lưu thành công |
| **Độ chính xác tính Macro** | Thủ công | **100% chính xác** theo tỷ lệ nguyên liệu | Kiểm thử ma trận đơn vị (Unit tests) |
| **D30 User Retention** | 35% | **>= 45%** | Firebase Analytics funnel |
| **Offline Reliability** | - | **100% lưu cục bộ, tự sync khi có mạng** | Unit test offline mock |

---

## 🧭 2. Phân Loại MoSCoW & Ranh Giới Tính Năng (In-Scope vs Out-of-Scope)

### 2.1. In-Scope (Must-Have & Should-Have cho Sprint 10)
- **`US-01` [Must-have]**: **Interactive Recipe Builder** — Cho phép người dùng tạo công thức món ăn mới, thêm danh sách nguyên liệu từ dữ liệu món có sẵn, tự động tính tổng Calo và 3 Macro (Carbs `#1A73E8`, Protein `#FFD700`, Fat `#FF69B4`).
- **`US-02` [Should-have]**: **Dynamic Portion Scaler** — Cho phép điều chỉnh khẩu phần công thức theo hệ số (0.5x, 1x, 2x, 4x) để tự động co giãn trọng lượng nguyên liệu và giá trị dinh dưỡng tương ứng.
- **`US-03` [Must-have]**: **Weekly Meal Planner Calendar** — Lịch lập kế hoạch bữa ăn theo ngày (Sáng, Trưa, Tối, Bữa phụ), gán Recipe hoặc món ăn vào từng bữa trong tuần.
- **`US-04` [Must-have]**: **1-Tap Log to Diary** — Chuyển nhanh một bữa ăn đã lên kế hoạch (Meal Plan) vào Nhật ký ăn uống thực tế (Food Diary) chỉ với 1 chạm.

### 2.2. Out-of-Scope (Strictly Won't-Have — Chống Scope Creep)
- ❌ **Social Recipe Sharing / Community Feed**: Không chia sẻ công thức ra cộng đồng, không có like/comment/bình luận món.
- ❌ **Grocery Shopping List / Marketplace Ordering**: Không tích hợp siêu thị, không đặt mua nguyên liệu trực tuyến.
- ❌ **Automatic AI Recipe Generation**: Không dùng LLM tự sinh công thức ảo ở phiên bản này nhằm đảm bảo tính chính xác và kiểm soát chi phí.

---

## 📋 3. User Stories & Tiêu Chí Nghiệm Thu Chuẩn BDD (Given - When - Then)

### 🥑 US-01: Tạo Công Thức Món Ăn Đa Nguyên Liệu (Recipe Builder)
- **As a**: Người dùng nấu ăn theo chế độ tại nhà.
- **I want to**: Tạo một công thức món ăn gồm nhiều nguyên liệu và trọng lượng gram cụ thể.
- **So that**: Tôi có thể lưu lại công thức chuẩn của mình và xem tổng giá trị dinh dưỡng mà không phải cộng nhẩm.

#### Scenario 1.1: Tạo thành công công thức hợp lệ với Auto Macro Aggregation (Happy Path)
```gherkin
Given người dùng đang ở màn hình "Tạo Công Thức Món Ăn" (Recipe Builder)
And đã nhập tên công thức là "Salad Ức Gà Quinoa"
And thêm 2 nguyên liệu:
  | Nguyên liệu | Trọng lượng | Calo | Carbs | Protein | Fat |
  | Ức gà áp chảo | 150g | 247.5 | 0.0g | 46.5g | 5.4g |
  | Quinoa nấu chín | 100g | 120.0 | 21.3g | 4.4g | 1.9g |
When người dùng nhấn nút "Lưu Công Thức" (Celestial Gradient CTA)
Then hệ thống tự động tổng hợp tổng dinh dưỡng:
  | Tổng Calo | Tổng Carbs | Tổng Protein | Tổng Fat |
  | 367.5 kcal | 21.3g | 50.9g | 7.3g |
And lưu công thức vào bộ sưu tập cá nhân trong Cloud Firestore và Local Cache
And hiển thị thông báo "✓ Đã lưu công thức Salad Ức Gà Quinoa"
And đóng màn hình tạo, cập nhật danh sách công thức tức thì.
```

#### Scenario 1.2: Xử lý ngoại lệ khi chưa có nguyên liệu hoặc tên rỗng (Edge Case)
```gherkin
Given người dùng đang ở màn hình "Tạo Công Thức Món Ăn"
When người dùng để trống tên công thức hoặc danh sách nguyên liệu có 0 phần tử
And nhấn nút "Lưu Công Thức"
Then hệ thống chặn thao tác gửi dữ liệu
And hiển thị viền đỏ cảnh báo tại trường tên món hoặc danh sách nguyên liệu
And hiển thị SnackBar: "Vui lòng nhập tên công thức và ít nhất 1 nguyên liệu!".
```

---

### ⚖️ US-02: Co Giãn Khẩu Phần Động (Dynamic Portion Scaler)
- **As a**: Người dùng chuẩn bị khẩu phần ăn cho nhiều người hoặc nấu nhiều bữa (Meal-prep).
- **I want to**: Chọn hệ số khẩu phần (0.5x, 1x, 2x, 4x) trên màn hình chi tiết công thức.
- **So that**: Trọng lượng các nguyên liệu và giá trị dinh dưỡng tự động nhân/chia tương ứng.

#### Scenario 2.1: Thay đổi khẩu phần từ 1x sang 2x (Happy Path)
```gherkin
Given người dùng đang xem chi tiết công thức "Salad Ức Gà Quinoa" (Khẩu phần gốc 1x: 367.5 kcal, Ức gà 150g, Quinoa 100g)
When người dùng nhấn vào chip khẩu phần "2x"
Then trọng lượng hiển thị của từng nguyên liệu tự động nhân đôi:
  | Nguyên liệu | Trọng lượng sau scale |
  | Ức gà áp chảo | 300g |
  | Quinoa nấu chín | 200g |
And tổng calo và macro hiển thị tương ứng nhân 2:
  | Tổng Calo | Carbs | Protein | Fat |
  | 735.0 kcal | 42.6g | 101.8g | 14.6g |
And màu sắc 3 Macro tuân thủ nghiêm ngặt: Carbs (#1A73E8), Protein (#FFD700), Fat (#FF69B4).
```

---

### 📅 US-03: Lập Lịch Kế Hoạch Bữa Ăn Hàng Tuần (Meal Planner Calendar)
- **As a**: Người dùng có kế hoạch ăn uống kỷ luật.
- **I want to**: Xem lịch 7 ngày trong tuần và gán công thức hoặc món ăn vào các khung bữa (Sáng, Trưa, Tối, Phụ).
- **So that**: Tôi chủ động chuẩn bị thực phẩm từ trước mà không cần băn khoăn "hôm nay ăn gì".

#### Scenario 3.1: Gán công thức vào bữa Trưa ngày mai (Happy Path)
```gherkin
Given người dùng đang ở tab "Kế Hoạch Bữa Ăn" (Meal Planner)
When người dùng chọn ngày mai trên thanh trượt 7 ngày (Celestial Day Strip)
And nhấn nút "+" tại mục "Bữa Trưa"
And chọn công thức "Salad Ức Gà Quinoa" từ danh bạ công thức cá nhân
Then công thức được gán vào Bữa Trưa của ngày mai
And tổng calo dự kiến của ngày mai được cập nhật ngay lập tức
And thẻ món hiển thị biểu tượng Recipe Badge màu Midnight Cyan.
```

---

### ⚡ US-04: Ghi Nhật Ký 1 Chạm Từ Kế Hoạch (1-Tap Log to Diary)
- **As a**: Người dùng đã hoàn thành bữa ăn theo lịch trình.
- **I want to**: Nhấn nút "Ghi Nhật Ký" (Log Meal) ngay tại thẻ kế hoạch bữa ăn hôm nay.
- **So that**: Món ăn được nạp ngay vào nhật ký ăn uống chính thức (Food Diary) mà không phải gõ lại.

#### Scenario 4.1: Chuyển món từ Kế hoạch sang Nhật ký (Happy Path)
```gherkin
Given người dùng đang ở màn hình Home Cockpit hoặc tab Kế Hoạch Bữa Ăn vào ngày hôm nay
And có món "Salad Ức Gà Quinoa" đã lên lịch cho "Bữa Trưa"
When người dùng nhấn nút "✓ Ghi Vào Nhật Ký"
Then một bản ghi MealLog mới được tạo trong `meal_logs` cho Bữa Trưa hôm nay với đầy đủ dinh dưỡng của công thức
And trạng thái thẻ kế hoạch chuyển sang badge "Đã Ăn (✓ Logged)"
And thanh tiến độ Calo & Macro trên Home Cockpit cập nhật thời gian thực
And toàn bộ thao tác hoàn tất trong thời gian <= 500ms.
```

#### Scenario 4.2: Thao tác khi không có kết nối mạng (Offline Resilience)
```gherkin
Given thiết bị người dùng đang ở chế độ máy bay (Airplane Mode)
When người dùng nhấn "✓ Ghi Vào Nhật Ký" trên thẻ bữa ăn kế hoạch
Then bản ghi được lưu ngay vào SQLite / SharedPreferences Pending Queue cục bộ
And trạng thái chuyển thành "Đã Ăn (Chờ đồng bộ ☁️)"
And không xảy ra lỗi crash ứng dụng
When kết nối Internet được khôi phục
Then dữ liệu tự động đồng bộ lên Cloud Firestore trong nền.
```

---

## 🗄️ 4. Từ Điển Dữ Liệu & Ràng Buộc Kỹ Thuật (Data Dictionary)

### 4.1. Entity: `Recipe` (Collection: `recipes`)
| Trường (Field) | Kiểu (Type) | Bắt Buộc | Mô Tả & Ràng Buộc |
| :--- | :--- | :---: | :--- |
| `id` | `String` | Có | UUID v4 định danh công thức |
| `userId` | `String` | Có | ID người dùng tạo công thức |
| `name` | `String` | Có | Tên công thức (tối đa 60 ký tự, không rỗng) |
| `description`| `String?`| Không | Ghi chú chế biến (tối đa 250 ký tự) |
| `servings` | `int` | Có | Khẩu phần chuẩn mặc định (mặc định = 1, min = 1, max = 20) |
| `ingredients`| `List<RecipeIngredient>` | Có | Danh sách nguyên liệu cấu thành (tối thiểu 1 phần tử) |
| `totalCalories` | `double` | Có | Tổng calo tính toán của 1 khẩu phần (>= 0) |
| `totalCarbs` | `double` | Có | Tổng carbs tính toán (g) (>= 0) |
| `totalProtein` | `double` | Có | Tổng protein tính toán (g) (>= 0) |
| `totalFat` | `double` | Có | Tổng fat tính toán (g) (>= 0) |
| `createdAt` | `DateTime` | Có | Thời gian tạo (UTC) |
| `updatedAt` | `DateTime` | Có | Thời gian cập nhật gần nhất |

### 4.2. Value Object: `RecipeIngredient`
| Trường (Field) | Kiểu (Type) | Bắt Buộc | Mô Tả |
| :--- | :--- | :---: | :--- |
| `foodId` | `String` | Có | ID món gốc trong danh bạ thực phẩm |
| `name` | `String` | Có | Tên hiển thị nguyên liệu |
| `amountGrams`| `double` | Có | Trọng lượng nguyên liệu tính bằng gram (> 0) |
| `calories` | `double` | Có | Calo tương ứng với `amountGrams` |
| `carbs` | `double` | Có | Carbs tương ứng (g) |
| `protein` | `double` | Có | Protein tương ứng (g) |
| `fat` | `double` | Có | Fat tương ứng (g) |

### 4.3. Entity: `MealPlanItem` (Collection: `meal_plans`)
| Trường (Field) | Kiểu (Type) | Bắt Buộc | Mô Tả |
| :--- | :--- | :---: | :--- |
| `id` | `String` | Có | UUID v4 định danh kế hoạch |
| `userId` | `String` | Có | ID người dùng |
| `date` | `String` | Có | Ngày lập lịch định dạng ISO `YYYY-MM-DD` |
| `mealType` | `String` | Có | `breakfast`, `lunch`, `dinner`, `snack` |
| `recipeId` | `String?`| Không | ID công thức (nếu gán từ recipe) |
| `foodName` | `String` | Có | Tên món hiển thị trên thẻ kế hoạch |
| `calories` | `double` | Có | Calo dự kiến |
| `carbs` | `double` | Có | Carbs dự kiến (g) |
| `protein` | `double` | Có | Protein dự kiến (g) |
| `fat` | `double` | Có | Fat dự kiến (g) |
| `isLogged` | `bool` | Có | Cờ đánh dấu đã ghi vào nhật ký hay chưa (mặc định = false) |

---

## 🔒 5. Ràng Buộc Phi Chức Năng (Non-Functional Requirements)

1. **Hiệu năng (SLA)**: 
   - Render danh sách công thức: Thời gian khởi động màn hình <= 300ms, cuộn 60 FPS.
   - Thao tác 1-Tap Log: Phản hồi UI tức thì <= 100ms (Optimistic Update).
2. **Quy chuẩn màu sắc bất biến (Celestial Dark UI)**:
   - Nền: `AppColors.surface` (`#0A192F`). Thẻ nổi: `AppColors.surfaceContainer` (`#112240`).
   - Carbs: `#1A73E8` (Primary). Protein: `#FFD700` (Tertiary). Fat: `#FF69B4` (Secondary).
3. **Mã nguồn Ponytail**:
   - Tái sử dụng `GlassCard`, `MacroBar`, `MealTypeChip` sẵn có trong `lib/shared/widgets/`.
   - Không cài thêm bất kỳ package bên thứ ba nào cho tính toán lịch hay macro.
