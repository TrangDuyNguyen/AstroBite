# Từ Điển Dữ Liệu Thực Thể (Data Dictionary)

Tài liệu này định nghĩa cấu trúc dữ liệu cho các thực thể được lưu trữ trên Cloud Firestore và sử dụng trong toàn bộ hệ thống AstroBite.

---

## 1. Collection `users/{uid}`
Lưu trữ thông tin hồ sơ và mục tiêu calo của từng người dùng.

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả & Giá trị hợp lệ |
| :--- | :--- | :---: | :--- |
| `id` | String | Có | UID người dùng do Firebase Auth cấp |
| `email` | String | Có | Địa chỉ email đăng ký |
| `display_name` | String | Không | Tên hiển thị (VD: "Trang Nguyen") |
| `gender` | String | Có | `"male"` hoặc `"female"` |
| `birth_date` | Timestamp | Có | Ngày sinh (để tính tuổi) |
| `height_cm` | Number (double) | Có | Chiều cao tính theo cm (vd: 175.0) |
| `weight_kg` | Number (double) | Có | Cân nặng hiện tại (vd: 78.5) |
| `target_weight_kg`| Number (double)| Không | Cân nặng mục tiêu (vd: 72.0) |
| `activity_level` | String | Có | `"sedentary"`, `"light"`, `"moderate"`, `"very_active"` |
| `bmr` | Number (int) | Có | Lượng calo trao đổi chất cơ bản (kcal) |
| `tdee` | Number (int) | Có | Tổng calo tiêu hao hàng ngày (kcal) |
| `calorie_target` | Number (int) | Có | Mục tiêu calo hàng ngày (kcal) |
| `carbs_percent` | Number (int) | Có | Tỷ lệ % Carbs (mặc định 45) |
| `protein_percent`| Number (int) | Có | Tỷ lệ % Protein (mặc định 30) |
| `fat_percent` | Number (int) | Có | Tỷ lệ % Fat (mặc định 25) |
| `is_onboarding_completed` | Boolean | Có | `true`: Đã hoàn tất khảo sát; `false`: Đưa vào luồng Onboarding |
| `onboarding_step` | Number (int) | Không | Bước khảo sát hiện tại (1-5), dùng để khôi phục khi tắt app |
| `fitness_goal` | String | Có | `"lose_weight"`, `"maintain"`, `"gain_weight"` |
| `pal_multiplier` | Number (double) | Có | Hệ số mức vận động (1.20, 1.375, 1.55, 1.725, 1.90) |
| `safety_floor_applied` | Boolean | Không | `true` nếu áp dụng chặn sàn calo tối thiểu (Nam 1500, Nữ 1200) |
| `created_at` | Timestamp | Có | Thời gian tạo tài khoản |

---

## 2. Subcollection `users/{uid}/meal_logs/{logId}`
Lưu trữ các lần ghi nhận món ăn theo từng ngày.

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả & Giá trị hợp lệ |
| :--- | :--- | :---: | :--- |
| `id` | String | Có | Mã định danh bản ghi bữa ăn (UUID v4 sinh từ client) |
| `user_id` | String | Có | UID người sở hữu |
| `meal_type` | String | Có | `"breakfast"`, `"lunch"`, `"dinner"`, `"snack"` |
| `food_name` | String | Có | Tên món ăn hoặc chuỗi tổng hợp các món đa món (VD: "Cơm tấm, Sườn nướng, Chả trứng") |
| `serving_size_g` | Number (double) | Có | Tổng khẩu phần thực tế (gram) |
| `calories` | Number (double) | Có | Tổng calo nạp vào (kcal) |
| `carbs_g` | Number (double) | Có | Lượng Carbohydrates (g) |
| `fat_g` | Number (double) | Có | Lượng Chất béo (g) |
| `protein_g` | Number (double) | Có | Lượng Chất đạm (g) |
| `sodium_mg` | Number (double) | Không | Hàm lượng Natri / Muối (mg) (Mặc định 0.0 nếu chưa có) |
| `fiber_g` | Number (double) | Không | Hàm lượng Chất xơ (g) (Mặc định 0.0 nếu chưa có) |
| `sugar_g` | Number (double) | Không | Hàm lượng Đường (g) (Mặc định 0.0 nếu chưa có) |
| `dishes` | Array<Map> | Không | Danh sách các món con chi tiết trong bữa ăn đa món (Xem bảng 2.1) |
| `image_url` | String | Không | Đường dẫn ảnh trên Firebase Storage |
| `source` | String | Có | `"ai_scan"`, `"multi_scan"`, `"manual_entry"`, hoặc `"voice_log"` |
| `sync_status` | String | Có | Trạng thái đồng bộ: `"synced"`, `"pending_sync"`, `"failed"` |
| `last_modified_at`| Timestamp | Có | Thời điểm chỉnh sửa gần nhất (Dùng cho Last-Write-Wins sync) |
| `logged_at` | Timestamp | Có | Thời gian ăn (dùng để nhóm theo ngày) |

### 2.1. Cấu trúc phần tử trong mảng `dishes` (Dành cho bữa ăn đa món)

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả |
| :--- | :--- | :---: | :--- |
| `dish_name` | String | Có | Tên món ăn con (VD: "Sườn nướng") |
| `estimated_weight_g` | Number (int) | Có | Trọng lượng món con (gram) |
| `calories` | Number (int) | Có | Calo của riêng món con |
| `carbs_g` | Number (int) | Có | Carbs của món con (g) |
| `fat_g` | Number (int) | Có | Fat của món con (g) |
| `protein_g` | Number (int) | Có | Protein của món con (g) |
| `sodium_mg` | Number (double)| Không | Natri của món con (mg) |
| `fiber_g` | Number (double)| Không | Chất xơ của món con (g) |
| `sugar_g` | Number (double)| Không | Đường của món con (g) |
| `confidence_score` | Number (double)| Có | Độ tin cậy AI nhận diện (0.0 - 1.0) |
| `is_selected` | Boolean | Có | `true`: Được tính vào bữa; `false`: Bỏ chọn không ăn |
| `has_broth` | Boolean | Không | `true`: Món nước (Phở, Bún bò...); mặc định `false` |
| `broth_calories` | Number (int) | Không | Calo riêng của phần nước dùng (mặc định 0) |
| `broth_sodium_mg`| Number (double)| Không | Natri riêng của phần nước dùng (mg, mặc định 0.0) |
| `include_broth` | Boolean | Không | `true`: Người dùng ăn cả nước; `false`: Chỉ ăn cái (mặc định `true`) |
| `sub_items` | Array<Map> | Không | Danh sách toppings / món phụ con trong combo (Xem bảng 2.2) |

### 2.2. Cấu trúc phần tử trong mảng `sub_items` (Topping / Món phụ con)

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả |
| :--- | :--- | :---: | :--- |
| `name` | String | Có | Tên topping/món phụ (VD: "Mỡ hành", "Chả trứng", "Bì heo") |
| `calories` | Number (int) | Có | Lượng calo riêng của topping |
| `carbs_g` | Number (int) | Không | Lượng Carbs của topping (g, mặc định 0) |
| `protein_g` | Number (int) | Không | Lượng Protein của topping (g, mặc định 0) |
| `fat_g` | Number (int) | Không | Lượng Chất béo của topping (g, mặc định 0) |
| `is_selected` | Boolean | Có | `true`: Chọn ăn; `false`: Bỏ chọn (mặc định `true`) |

---

## 3. Cấu Trúc Bộ Nhớ Đệm Cục Bộ (Local Cache & Offline Storage)

Sử dụng bộ nhớ cục bộ hiệu năng cao (Hive Key-Value Box) trên thiết bị di động để bảo đảm tính khả dụng Offline-First:

### 3.1. Box `offline_meal_logs`
- **Khóa (Key)**: `String id` (UUID bản ghi).
- **Giá trị (Value)**: JSON map chứa toàn bộ các trường của bản ghi `meal_logs` tương thích với Firestore DTO.
- **Phạm vi lưu trữ**: Tối đa 30 ngày gần nhất của tài khoản hiện tại.

### 3.2. Box `sync_queue`
Lưu trữ danh sách các tác vụ đồng bộ đang chờ gửi lên server khi có mạng:

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả |
| :--- | :--- | :---: | :--- |
| `task_id` | String | Có | UUID tác vụ đồng bộ |
| `action` | String | Có | Loại hành động: `"create"`, `"update"`, `"delete"` |
| `entity_type` | String | Có | Loại thực thể: `"meal_log"`, `"user_profile"` |
| `entity_id` | String | Có | ID của bản ghi mục tiêu |
| `payload` | Map<String, dynamic> | Có | Dữ liệu đầy đủ cần gửi lên Firestore |
| `created_at` | DateTime | Có | Thời gian tạo tác vụ |
| `retry_count` | Number (int) | Có | Số lần đã thử lại (Tối đa 5 lần với Exponential Backoff) |
| `last_error` | String | Không | Lý do lỗi lần thử gần nhất |

---

## 4. Subcollection `users/{uid}/chat_sessions/{date}` (Sprint 03 — EPIC-07 AI Coach)
Lưu trữ lịch sử hội thoại AI Coach theo ngày. Mỗi ngày tạo 1 document mới (session reset hàng ngày).

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả & Giá trị hợp lệ |
| :--- | :--- | :---: | :--- |
| `date` | String | Có | Ngày session dạng `"YYYY-MM-DD"` (làm document ID) |
| `user_id` | String | Có | UID người sở hữu |
| `messages` | Array<Map> | Có | Danh sách tin nhắn hội thoại (Xem bảng 4.1) |
| `message_count` | Number (int) | Có | Tổng số tin nhắn trong ngày (giới hạn 50) |
| `created_at` | Timestamp | Có | Thời gian tạo session |
| `last_message_at` | Timestamp | Có | Thời gian tin nhắn cuối cùng |

### 4.1. Cấu trúc phần tử trong mảng `messages`

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả |
| :--- | :--- | :---: | :--- |
| `id` | String | Có | UUID tin nhắn |
| `role` | String | Có | `"user"` hoặc `"assistant"` |
| `content` | String | Có | Nội dung tin nhắn (text) |
| `timestamp` | Timestamp | Có | Thời gian gửi |
| `is_error` | Boolean | Không | `true` nếu là tin nhắn lỗi (timeout, network error) |

---

## 5. Document `users/{uid}` — Trường bổ sung cho Health Integration (Sprint 03 — EPIC-10)

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả & Giá trị hợp lệ |
| :--- | :--- | :---: | :--- |
| `health_connected` | Boolean | Không | `true`: Đã kết nối Apple Health / Health Connect; `false` hoặc null: Chưa kết nối |
| `health_write_enabled` | Boolean | Không | `true`: Bật đồng bộ calo nạp ngược về Health Platform; mặc định `false` |
| `health_platform` | String | Không | `"apple_healthkit"`, `"health_connect"`, hoặc `null` |
| `health_connected_at` | Timestamp | Không | Thời gian kết nối lần gần nhất |

---

## 6. Thực Thể Bộ Nhớ Tạm Client: `VoiceLogResult` (Sprint 20 — EPIC-VOICE)
Lưu trữ kết quả nhận diện giọng nói và bóc tách NLU từ Gemini 2.0 Flash trước khi ghi xuống `meal_logs`.

| Tên trường | Kiểu dữ liệu | Bắt buộc | Mô tả & Giá trị hợp lệ |
| :--- | :--- | :---: | :--- |
| `raw_transcript` | String | Có | Văn bản gốc nhận diện từ Speech-to-Text (VD: "Sáng nay ăn 1 tô phở bò") |
| `meal_type` | String | Có | `"breakfast"`, `"lunch"`, `"dinner"`, `"snack"` |
| `total_calories` | Number (int) | Có | Tổng calo nạp vào (kcal) |
| `protein_g` | Number (double) | Có | Lượng đạm (gam) |
| `carbs_g` | Number (double) | Có | Lượng tinh bột (gam) |
| `fat_g` | Number (double) | Có | Lượng chất béo (gam) |
| `sodium_mg` | Number (double) | Không | Hàm lượng Natri (mg) |
| `dishes` | List<DishItem> | Có | Danh sách chi tiết từng món con kèm gram và calo |
| `confidence_score`| Number (double)| Có | Điểm tin cậy NLU từ Gemini (0.0 – 1.0) |
| `created_at` | DateTime | Có | Thời điểm nhận diện |


