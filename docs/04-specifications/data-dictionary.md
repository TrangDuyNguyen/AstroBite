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
| `source` | String | Có | `"ai_scan"`, `"multi_scan"`, hoặc `"manual_entry"` |
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

