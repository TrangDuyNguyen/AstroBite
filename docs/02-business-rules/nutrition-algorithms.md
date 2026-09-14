# Quy Tắc Nghiệp Vụ Tính Toán Dinh Dưỡng (Nutrition Algorithms)

## 1. Công Thức Tính Tỷ Lệ Trao Đổi Chất Cơ Bản (BMR)
AstroBite sử dụng công thức **Mifflin-St Jeor** chuẩn y khoa hiện đại:
- **Nam giới**:
  $$\text{BMR} = 10 \times \text{Cân nặng (kg)} + 6.25 \times \text{Chiều cao (cm)} - 5 \times \text{Tuổi} + 5$$
- **Nữ giới**:
  $$\text{BMR} = 10 \times \text{Cân nặng (kg)} + 6.25 \times \text{Chiều cao (cm)} - 5 \times \text{Tuổi} - 161$$

---

## 2. Công Thức Tính Tổng Tiêu Hao Năng Lượng Hàng Ngày (TDEE)
$$\text{TDEE} = \text{BMR} \times \text{Hệ số vận động (PAL)}$$

| Cấp độ vận động | Mô tả | Hệ số PAL |
| :--- | :--- | :---: |
| **Sedentary** | Ít vận động, ngồi văn phòng | 1.20 |
| **Lightly Active** | Vận động nhẹ (tập 1-3 ngày/tuần) | 1.375 |
| **Moderately Active**| Vận động vừa phải (tập 3-5 ngày/tuần)| 1.55 |
| **Very Active** | Vận động nhiều (tập 6-7 ngày/tuần) | 1.725 |
| **Extremely Active** | Vận động cực nặng, lao động thể lực | 1.90 |

---

## 3. Điều Chỉnh Calo Theo Mục Tiêu Thể Trạng
- **Giảm cân (Lose Weight)**: `Mục tiêu calo = TDEE - 500 kcal` (Giảm ~0.5kg/tuần). Giới hạn an toàn tối thiểu: Nam >= 1500 kcal, Nữ >= 1200 kcal.
- **Giữ cân (Maintain Weight)**: `Mục tiêu calo = TDEE`.
- **Tăng cơ / Tăng cân (Gain Weight)**: `Mục tiêu calo = TDEE + 300 kcal`.

---

## 4. Phân Bổ Tỷ Lệ Đa Lượng (Macro Split Distribution)
Theo mục tiêu mặc định cân bằng (Balanced Diet):
- **Carbohydrates**: 45% tổng calo (1g Carbs = 4 kcal)
- **Protein**: 30% tổng calo (1g Protein = 4 kcal)
- **Fat**: 25% tổng calo (1g Fat = 9 kcal)
*(Người dùng có thể tùy biến tỷ lệ này trong màn hình Profile)*.
