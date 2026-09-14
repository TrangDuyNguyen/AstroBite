# Testcases Điều Chỉnh Khẩu Phần Dinh Dưỡng (Portion Edit Testcases)

- **Module**: `02-food-scanner-ai`
- **Tham chiếu BA**: `docs/03-prd-features/02-food-scanner-ai/user-stories.md` (US-03)

---

### TC-POR-001: Điều chỉnh slider trọng lượng món ăn và tính lại chỉ số tức thì
- **Preconditions**: Đang ở BottomSheet kết quả nhận diện món "Gà rán" (AI gợi ý khẩu phần 200g, 500 kcal, 25g Carbs, 30g Protein, 30g Fat).
- **Test Steps**:
  1. Kéo slider Portion Size từ `200g` lên `300g` (+50%).
  2. Quan sát sự thay đổi của các chỉ số hiển thị.
- **Expected Result**:
  - Calo tự động tăng thành: `500 * 1.5 = 750 kcal`.
  - Carbs: `25 * 1.5 = 37.5g`.
  - Protein: `30 * 1.5 = 45g`.
  - Fat: `30 * 1.5 = 45g`.
  - Nút lưu "Lưu vào Bữa Trưa (750 kcal)" phản ánh đúng giá trị mới.
- **Severity**: S2 (Critical)
