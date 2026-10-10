# Thiết Kế UI/UX Blueprint Lưới 4pt — Gate 2 Sign-Off
## Sprint 27: Auth & Onboarding Flow Clean Architecture

- **Chủ trì thiết kế**: Sub-Agent UI/UX Designer (`ui-ux-designer` — *The Celestial Aesthetic Purist*)
- **Phê duyệt**: Sub-Agent PO & Tech Lead
- **Ngày ký duyệt**: 2026-10-10
- **Trạng thái**: 🎨 **GATE 2 APPROVED — STRICT 4PT GRID**

---

### 1. Bố Cục `SplashPage`

```
┌─────────────────────────────────────────────────────────────┐
│ (🍎 Apple 3D)                  (✨ Star 3D)   (🥐 Croissant)│
│                                                             │
│             [ 🪐 CosmicLogoBadge (size: 96) ]               │
│             "ASTROBITE" (34pt, Tracking: 3.0)               │
│             "AI FOOD SCANNER & CALORIE TRACKER" (10.5pt)    │
│                                                             │
│ (🥑 Avocado 3D)                                (🍪 Cookie)  │
│                                                             │
│              [=====-----] Loading Indicator                 │
│                                                             │
│ (🍦 IceCream)                                  (🍕 Pizza)   │
│       (🍜 Ramen)            (☕ Coffee)         (🍳 Egg)    │
└─────────────────────────────────────────────────────────────┘
```

---

### 2. Bố Cục `LoginPage`

```
┌─────────────────────────────────────────────────────────────┐
│ [ 🪐 CosmicLogoBadge (size: 64) ]                           │
│ "AstroBite" - Chào mừng trở lại                             │
│                                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ LoginFormCard (ClayCard r:24)                           │ │
│ │ [📧 Email: ClayTextField]                               │ │
│ │ [🔒 Mật khẩu: ClayTextField + Eye icon]                 │ │
│ │ [Quên mật khẩu? -> Mở Dialog]                           │ │
│ │ [ ClayButton: ĐĂNG NHẬP (height: 52) ]                  │ │
│ │ ────────── HOẶC ──────────                              │ │
│ │ [ GoogleSignInButton ]                                  │ │
│ └─────────────────────────────────────────────────────────┘ │
│ Chưa có tài khoản? Đăng ký ngay                            │
└─────────────────────────────────────────────────────────────┘
```

---

### 3. Bố Cục `OnboardingPage` (5 Bước Khảo Sát)

```
┌─────────────────────────────────────────────────────────────┐
│ [< Quay lại]            Bước X / 5                          │
│ [====] [====] [====] [====] [====] Thanh tiến độ 5 vạch     │
│                                                             │
│ [🏷️ Category Pill: TIỂU VŨ TRỤ SINH HỌC]                    │
│ Tiêu đề bước khảo sát (24pt bold)                           │
│ Mô tả giải thích chuẩn y khoa Mifflin-St Jeor               │
│                                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ OnboardingSelectCard / Numeric TextFields               │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ [ ClayButton: Tiếp tục / Xem Kế Hoạch Cá Nhân (h: 52) ]     │
└─────────────────────────────────────────────────────────────┘
```
