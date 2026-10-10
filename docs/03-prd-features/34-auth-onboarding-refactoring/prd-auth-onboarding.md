# Product Requirement Document (PRD) — Gate 1 Sign-Off
## Sprint 27: Auth & Onboarding Flow Clean Architecture (v3.7.0)

- **Mã tính năng**: `PRD-S27-AUTH-ONBOARDING`
- **Chủ trì nghiệp vụ**: Sub-Agent BA (`business-analyst` — *The Pedantic Logician*)
- **Phê duyệt nghiệp vụ**: Sub-Agent PO (`product-owner` — *The Strategic Tyrant*)
- **Phê duyệt khả thi**: Sub-Agent Tech Lead (`tech-lead` — *The Pragmatic System Architect*)
- **Ngày phê duyệt**: 2026-10-10
- **Trạng thái**: 🟢 **GATE 1 APPROVED — ZERO SCOPE CREEP**

---

### 1. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (Metrics & ROI)

1. **First Impression & FTUX Onboarding**: Trải nghiệm lần đầu tiên của người dùng từ Splash -> Login -> Onboarding quyết định 80% tỷ lệ kích hoạt tài khoản D1 Activation.
2. **Loại bỏ nợ kỹ thuật (Hard Cap Elimination)**: Giải quyết 4 trong 6 file vi phạm Hard Cap còn lại của dự án (`clay_3d_food_art.dart`, `onboarding_page.dart`, `splash_page.dart`, `login_page.dart`), đưa số file Hard Cap về chỉ còn 2 file duy nhất.
3. **Hiệu năng hoạt ảnh (60 FPS Motion)**: Giữ vững trải nghiệm thị giác Zero-gravity trôi nổi của các món ăn 3D và điều hướng mượt mà.

---

### 2. Danh Mục Yêu Cầu Chức Năng (Functional Requirements)

#### FR-01: 3D Food Art Engine
- Tách rời các bộ hàm vẽ CustomPainter đồ ăn hoa quả bánh ngọt và món ăn thức uống mà không làm biến đổi bất kỳ pixel hay hiệu ứng thị giác nào.

#### FR-02: Quy Trình Khảo Sát 5 Bước (Onboarding Flow)
- Đảm bảo 5 bước khảo sát (Giới tính, Năm sinh & Chiều cao, Cân nặng & Mục tiêu cân nặng, Mức độ vận động, Mục tiêu hình thể) hoạt động trơn tru với PageController, truyền tham số chuẩn xác sang `GoalSummaryRoute`.

#### FR-03: Trải Nghiệm Khởi Động (Splash & Auth Routing)
- Giữ nguyên hiệu ứng One-shot Entrance Orchestration và Weightless Zero-Gravity Drift của 10 món ăn chòm sao.
- Kiểm tra auth state và chuyển tiếp chính xác sang `ShellRoute`, `OnboardingRoute` hoặc `LoginRoute`.

#### FR-04: Màn Hình Đăng Nhập (Login & Reset Password)
- Đăng nhập email/password, validation, Google Sign In button, và dialog đặt lại mật khẩu với thông báo rõ ràng.
