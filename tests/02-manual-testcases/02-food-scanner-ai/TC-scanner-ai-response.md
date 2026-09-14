# Testcases Phản Hồi Nhận Diện Từ Gemini AI (AI Response Testcases)

- **Module**: `02-food-scanner-ai`
- **Tham chiếu BA**: `docs/03-prd-features/02-food-scanner-ai/user-stories.md` (US-03)

---

### TC-AI-001: Nhận diện thành công món ăn phổ biến (Phở Bò)
- **Test Steps**:
  1. Chụp ảnh rõ nét một tô Phở Bò nóng có đủ thịt bò và bánh phở.
  2. Chờ ứng dụng gửi yêu cầu tới Gemini 2.0 Flash Vision API.
- **Expected Result**:
  - Thời gian phản hồi < 3.0 giây.
  - BottomSheet kết quả trượt lên mượt mà:
    - Tên món hiển thị: "Phở Bò" (hoặc Phở Bò Tái/Nạm).
    - Confidence score hiển thị >= 80%.
    - Chỉ số calo ước tính nằm trong khoảng hợp lý: 450 - 550 kcal.
    - Màu sắc hiển thị macro chuẩn: Carbs xanh `#1A73E8`, Fat hồng `#FF69B4`, Protein vàng `#FFD700`.
- **Severity**: S1 (Blocker)

---

### TC-AI-002: Xử lý khi ảnh chụp không phải là món ăn (Ảnh đồ vật/xe cộ)
- **Test Steps**:
  1. Hướng camera chụp một chiếc laptop hoặc bàn phím máy tính.
  2. Chờ kết quả phản hồi từ AI.
- **Expected Result**:
  - AI phát hiện không phải món ăn hoặc độ tin cậy < 40%.
  - Hiển thị thông báo nhẹ nhàng: *"Không nhận diện được thực phẩm trong hình ảnh này. Vui lòng thử lại với đĩa thức ăn hoặc nhập thủ công."*
  - Không tạo bản ghi rác vào cơ sở dữ liệu.
- **Severity**: S2 (Critical)
