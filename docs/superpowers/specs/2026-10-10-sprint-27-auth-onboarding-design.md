# Architectural Decision Record (ADR-033) & System Design Spec
## Sprint 27: Auth & Onboarding Flow Clean Architecture (v3.7.0)

- **Trạng thái**: 🟢 **APPROVED** (Sub-Agent Tech Lead & System Architect Sign-Off)
- **Mã Epic / Feature**: `EPIC-REF-06` / `FEAT-S27-AUTH-ONBOARDING`
- **Quy mô cam kết**: **13 Story Points**
- **Mục tiêu chính**: Giải phẫu 4 "God Files" cuối cùng của phân hệ Authentication & First-Time User Experience (FTUX):
  1. `lib/features/auth/presentation/widgets/clay_3d_food_art.dart` (762 dòng ➔ $< 100$ dòng)
  2. `lib/features/auth/presentation/pages/onboarding_page.dart` (677 dòng ➔ $< 160$ dòng)
  3. `lib/features/auth/presentation/pages/splash_page.dart` (650 dòng ➔ $< 150$ dòng)
  4. `lib/features/auth/presentation/pages/login_page.dart` (504 dòng ➔ $< 160$ dòng)

---

### 1. Bối Cảnh & Vấn Đề Kỹ Thuật (Context & Problem Statement)

1. **`clay_3d_food_art.dart` (762 dòng)**: File dài nhất hiện tại trên repo. Tập hợp 10 hàm CustomPainter vẽ 10 loại đồ ăn 3D khác nhau trong cùng một file.
2. **`onboarding_page.dart` (677 dòng)**: Trộn lẫn cả 5 bước khảo sát (Gender, Age & Height, Weight & Target, Activity Level, Fitness Goal) cùng các PageController và widget card lựa chọn.
3. **`splash_page.dart` (650 dòng)**: Chứa danh sách cấu hình 10 spec đồ ăn trôi nổi Zero-gravity, animation controllers cho logo, và lớp giao diện chòm sao.
4. **`login_page.dart` (504 dòng)**: Vừa chạm ngưỡng chặn cứng 500 dòng với form đăng nhập, dialog reset password và layout animation.

---

### 2. Thiết Kế Module Bóc Tách (Decomposition Blueprint)

#### A. Phân hệ 3D Food Art (`lib/features/auth/presentation/widgets/`):
- `clay_3d_fruits_pastry_painters.dart` (~240 dòng): Apple, Avocado, Croissant, Pizza, IceCream painters.
- `clay_3d_meals_drinks_painters.dart` (~240 dòng): SunnyEgg, Cookie, Ramen, Coffee, CosmicStar painters.
- `clay_3d_food_art.dart` (< 90 dòng): Enum `Clay3DFoodType`, widget chính và delegator.

#### B. Phân hệ Onboarding (`lib/features/auth/presentation/widgets/onboarding_steps/`):
- `onboarding_select_card.dart` (~70 dòng): Card chọn lựa có icon, trạng thái active và hiệu ứng chạm.
- `onboarding_step_gender.dart` (~70 dòng): Khảo sát giới tính sinh học (Nam / Nữ).
- `onboarding_step_metrics.dart` (~160 dòng): Khảo sát năm sinh, chiều cao, cân nặng và cân nặng mục tiêu.
- `onboarding_step_lifestyle.dart` (~150 dòng): Khảo sát cường độ vận động và mục tiêu dinh dưỡng.
- `onboarding_page.dart` (< 160 dòng): Màn hình chính điều phối tiến trình 5 bước và thanh PageView.

#### C. Phân hệ Splash (`lib/features/auth/presentation/`):
- `widgets/splash_constellation_specs.dart` (~170 dòng): Định nghĩa `SplashFoodItemSpec` và bộ dữ liệu chòm sao 10 món.
- `widgets/splash_floating_food_item.dart` (~110 dòng): Component render từng món ăn trôi nổi weightless.
- `widgets/splash_cosmic_hero_view.dart` (~130 dòng): Component logo badge, slogan và thanh tiến trình.
- `pages/splash_page.dart` (< 150 dòng): Màn hình chính điều phối auth check và timer navigation.

#### D. Phân hệ Login (`lib/features/auth/presentation/`):
- `widgets/login_reset_password_dialog.dart` (~90 dòng): Dialog gửi liên kết đặt lại mật khẩu.
- `widgets/login_form_card.dart` (~170 dòng): Card form đăng nhập, validation, submit button, Google Sign In.
- `widgets/login_header_view.dart` (~70 dòng): Header tiêu đề và badge nhận diện.
- `pages/login_page.dart` (< 160 dòng): Màn hình đăng nhập sạch sẽ.

---

### 3. Nguyên Tắc Ponytail & Tuân Thủ Clean Code

- **Tái sử dụng tối đa**: Sử dụng `ClayCard`, `ClayButton`, `ClayTextField`, `AppValues`, `AppColors`.
- **Zero Bloat & Dead Code Elimination**: Không đưa thêm packages mới.
- **Tiêu chuẩn chặn cứng**: 100% các file sau khi tái cấu trúc phải $< 300$ dòng.
