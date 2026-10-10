# Kế Hoạch Kiểm Thử Hồi Quy (Test Plan) — Gate 3 Sign-Off
## Sprint 27: Auth & Onboarding Flow Clean Architecture

- **Chủ trì kiểm thử**: Sub-Agent QA Tester (`qa-tester` — *The Paranoid Inquisitor*)
- **Phê duyệt**: Sub-Agent Tech Lead & Reviewer
- **Ngày ký duyệt**: 2026-10-10
- **Trạng thái**: 🧪 **GATE 3 APPROVED — ZERO DU DI**

---

### 1. Ma Trận Test Cases Bắt Buộc

| Mã TC | Phân hệ kiểm thử | Kịch bản chi tiết | Tiêu chuẩn pass |
| :--- | :--- | :--- | :--- |
| **TC-S27-01** | `Clay3DFoodArt` | Render cả 10 loại món ăn 3D (`apple`, `avocado`, `croissant`, `pizza`, `iceCream`, `sunnyEgg`, `cookie`, `ramen`, `coffee`, `cosmicStar`). | Không ném ngoại lệ CustomPaint, render chuẩn kích thước. |
| **TC-S27-02** | `SplashPage` | Render logo AstroBite, title, và lớp 10 món ăn trôi nổi weightless. | Khởi tạo animation controllers an toàn, điều hướng timeout không crash. |
| **TC-S27-03** | `LoginPage` | Nhập email, password, hiển thị nút Google Sign In và dialog quên mật khẩu. | Validation email/password hoạt động, form submit đúng controller. |
| **TC-S27-04** | `OnboardingPage` | Điều hướng qua 5 bước khảo sát, lưu trữ state và chuyển sang `GoalSummaryRoute`. | Step bar cập nhật 1..5, các giá trị số và lựa chọn được bảo toàn. |

---

### 2. Tiêu Chuẩn Nghiệm Thu Kỹ Thuật
- **`flutter analyze`**: 0 errors, 0 warnings.
- **`check_file_length.sh`**: 4 file `clay_3d_food_art.dart`, `onboarding_page.dart`, `splash_page.dart`, `login_page.dart` đều $< 250$ dòng.
- **`flutter test`**: Toàn bộ 322 tests hiện tại tiếp tục PASS 100%.
