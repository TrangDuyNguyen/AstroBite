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
| `id` | String | Có | Mã định danh bản ghi bữa ăn |
| `user_id` | String | Có | UID người sở hữu |
| `meal_type` | String | Có | `"breakfast"`, `"lunch"`, `"dinner"`, `"snack"` |
| `food_name` | String | Có | Tên món ăn (VD: "Phở Bò") |
| `serving_size_g` | Number (double) | Có | Khẩu phần thực tế (gram) |
| `calories` | Number (double) | Có | Tổng calo nạp vào (kcal) |
| `carbs_g` | Number (double) | Có | Lượng Carbohydrates (g) |
| `fat_g` | Number (double) | Có | Lượng Chất béo (g) |
| `protein_g` | Number (double) | Có | Lượng Chất đạm (g) |
| `image_url` | String | Không | Đường dẫn ảnh trên Firebase Storage |
| `source` | String | Có | `"ai_scan"` hoặc `"manual_entry"` |
| `logged_at` | Timestamp | Có | Thời gian ăn (dùng để nhóm theo ngày) |
