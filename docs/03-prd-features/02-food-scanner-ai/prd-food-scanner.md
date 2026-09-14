# PRD: Quét Thức Ăn Bằng Gemini AI (Food Scanner AI)

- **Mã tính năng**: `FEAT-02`
- **Bộ phận phụ trách**: BA Team
- **Trạng thái**: Approved
- **Đối chiếu QA**: `tests/02-manual-testcases/02-food-scanner-ai/` & `tests/03-bdd-gherkin-scenarios/food_scanner_gemini.feature`
- **Đối chiếu FE**: `frontend/lib/features/scanner/`

---

## 1. Mục Tiêu Nghiệp Vụ
Cho phép người dùng chụp ảnh đĩa thức ăn từ camera hoặc tải ảnh từ thư viện, sử dụng mô hình đa phương thức Gemini 2.0 Flash để tự động nhận diện tên món ăn, thành phần dinh dưỡng, ước lượng gram và tính toán calo/macros trong thời gian dưới 3 giây.

---

## 2. Luồng Nghiệp Vụ (Business Process Flow)
1. Người dùng nhấn nút quét nổi bật (Central Floating Action Button) ở thanh điều hướng dưới đáy.
2. Ứng dụng mở Camera Scanner với khung ngắm quét thức ăn (Scanning Viewfinder) và hiệu ứng quét laser phát sáng.
3. Người dùng chụp ảnh hoặc chọn ảnh từ thư viện thiết bị.
4. Ảnh được nén tối ưu (tối đa 1024x1024px, định dạng WebP/JPEG) và gửi đồng thời tới:
   - Firebase Storage (lưu trữ ảnh)
   - Gemini 2.0 Flash Multimodal API (thông qua prompt cấu trúc JSON)
5. Hiển thị BottomSheet kết quả nhận diện:
   - Tên món ăn và độ tin cậy (Confidence score).
   - Thanh hiển thị Macro (Carbs, Fat, Protein) chuẩn màu thương hiệu.
   - Trọng lượng ước tính (slider điều chỉnh gram từ 50g đến 1000g).
   - Chọn bữa ăn áp dụng (Bữa Sáng, Trưa, Tối, Bữa Phụ).
6. Người dùng nhấn "Lưu vào Nhật ký" -> Hệ thống tạo bản ghi MealLog mới trên Firestore và cập nhật Dashboard.
