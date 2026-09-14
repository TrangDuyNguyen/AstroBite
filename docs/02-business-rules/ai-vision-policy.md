# Chính Sách & Quy Chuẩn Xử Lý Ảnh Trí Tuệ Nhân Tạo (AI Vision Policy)

## 1. Mô Hình Sử Dụng
- **Mô hình chính**: Google Gemini 2.0 Flash (Multimodal Vision API).
- **Mục tiêu**: Nhận diện tên món ăn, thành phần cấu thành, ước tính trọng lượng (gram) và phân rã các chỉ số calo, Carbs, Fat, Protein.

---

## 2. Quy Định Định Dạng Dữ Liệu Đầu Ra (AI Structured Output)
Prompt gửi tới Gemini Vision API bắt buộc phải kèm chỉ thị sinh JSON có cấu trúc nghiêm ngặt:
```json
{
  "food_name": "Phở Bò Tái",
  "confidence_score": 0.92,
  "serving_size_g": 450,
  "calories": 480,
  "carbs_g": 65,
  "fat_g": 12,
  "protein_g": 28,
  "ingredients": ["Bánh phở", "Thịt bò tái", "Nước dùng xương bò", "Hành lá", "Rau mùi"],
  "health_notes": "Lượng natri trong nước dùng có thể cao"
}
```

---

## 3. Ngưỡng Tin Cậy & Kịch Bản Dự Phòng (Confidence Thresholds & Fallbacks)
- **Độ tin cậy >= 0.70**: Hiển thị kết quả trực tiếp trên BottomSheet để người dùng xác nhận hoặc điều chỉnh khẩu phần.
- **Độ tin cậy < 0.70 hoặc Ảnh không rõ nét**:
  - Ứng dụng thông báo: *"Không nhận diện rõ món ăn. Vui lòng chụp lại ở góc sáng hơn hoặc nhập tên món thủ công."*
  - Cung cấp danh sách 3 món gợi ý có xác suất cao nhất.
  - Cho phép người dùng chuyển nhanh sang chế độ nhập tay (Manual Entry).

---

## 4. Tuyên Bố Miễn Trừ Y Tế (Medical & AI Disclaimer)
- Mọi kết quả do AI cung cấp chỉ mang tính chất tham khảo và ước lượng.
- AstroBite hiển thị thông điệp cảnh báo rõ ràng dưới mỗi lần quét:
  > *"Số liệu calo và dinh dưỡng do AI ước tính dựa trên hình ảnh. Kết quả thực tế có thể thay đổi tùy thuộc vào cách chế biến và gia vị."*
