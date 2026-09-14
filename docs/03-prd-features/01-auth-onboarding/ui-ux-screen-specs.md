# Đặc Tả Giao Diện (UI/UX Screen Specs): Auth & Onboarding

## 1. Danh Sách Màn Hình
- `SCR-01`: WelcomeScreen (`/welcome`)
- `SCR-02`: LoginScreen (`/login`)
- `SCR-03`: RegisterScreen (`/register`)
- `SCR-04`: OnboardingStepScreen (`/onboarding`)
- `SCR-05`: GoalCalculationSummaryScreen (`/onboarding/summary`)

---

## 2. Quy Chuẩn Thiết Kế & Design Tokens
- **Background**: `AppColors.surface` (`#0A192F` Midnight Blue).
- **Form Card**: `GlassCard` với `BackdropFilter` mờ 20px và đường viền ánh sao mỏng (`0x33FFFFFF`).
- **Primary CTA Button**: Nút bấm gradient xanh Celestial (`#1A73E8` -> `#0D47A1`), chiều cao 52pt, bo góc 16pt, ripple effect xúc giác.
- **Typography**: Header font Outfit Bold 28pt, Body font Inter Regular 15pt màu `#E0E6ED`.
- **Spacing**: Tuân thủ lưới 4pt (Padding ngang 24pt, khoảng cách giữa các input field 16pt).

---

## 3. Đặc Tả Chi Tiết Màn Hình Đăng Nhập (`SCR-02`)
- **Logo & Tiêu đề**: Icon thiên hà `🌌 AstroBite` nổi bật trên nền Midnight Blue, phụ đề "Đăng nhập để tiếp tục hành trình dinh dưỡng".
- **Trường Email**: `AuthTextField` kèm icon phong bì `Icons.email_outlined`, bàn phím `emailAddress`, validator kiểm tra định dạng RFC 5322.
- **Trường Mật khẩu**: `AuthTextField` kèm icon khóa `Icons.lock_outline`, suffix icon hình con mắt (`Icons.visibility` / `Icons.visibility_off`) cho phép bật/tắt hiển thị mật khẩu.
- **Quên mật khẩu**: Nút bấm nhỏ dạng text căn phải, mở dialog nhập email khôi phục mật khẩu.
- **Nút Đăng nhập chính**: `AuthSubmitButton` với hiệu ứng loading spinner mượt mà khi xử lý.
- **Đường phân cách**: Hai đường kẻ ngang gradient mờ kèm nhãn "HOẶC" ở giữa.
- **Nút Đăng nhập Google**: Nút container chuẩn Celestial Dark UI (`AppColors.surfaceContainer`), biểu tượng đa sắc Google kèm dòng chữ "Tiếp tục với Google", hỗ trợ phản hồi xúc giác (InkWell).
- **Điều hướng Đăng ký**: Dòng chữ "Chưa có tài khoản? Đăng ký ngay" chuyển sang `RegisterRoute`.

---

## 4. Bảng Ánh Xạ Mã Lỗi Firebase Auth (Vietnamese Error Mapping)
| Firebase Error Code | Thông báo hiển thị (Vietnamese) |
|---|---|
| `user-not-found` | Tài khoản không tồn tại. Vui lòng kiểm tra lại email hoặc đăng ký mới. |
| `wrong-password` | Mật khẩu không chính xác. Vui lòng thử lại. |
| `invalid-credential` | Email hoặc mật khẩu không chính xác. |
| `invalid-email` | Địa chỉ email không đúng định dạng. |
| `user-disabled` | Tài khoản của bạn đã bị khóa. Vui lòng liên hệ hỗ trợ. |
| `too-many-requests` | Bạn đã thử quá nhiều lần. Vui lòng đợi trong giây lát rồi thử lại. |
| `network-request-failed` | Không có kết nối mạng. Vui lòng kiểm tra Internet của bạn. |
| `popup-closed-by-user` | Thao tác đăng nhập Google đã được hủy. |

