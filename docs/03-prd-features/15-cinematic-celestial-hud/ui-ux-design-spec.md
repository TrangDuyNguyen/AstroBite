# Hồ Sơ Đặc Tả Thiết Kế Giao Diện (Gate 2 UI/UX Design Spec)
## Đại Trùng Tu Giao Diện: Cinematic Celestial UI & Holographic AR HUD Scanner

- **Mã tính năng**: `FEAT-15`
- **Mã Epic liên kết**: `EPIC-17` (Cinematic Celestial UI & Holographic AR HUD Scanner)
- **Bộ phận phụ trách**: Sub-Agent Mobile UI/UX Designer — *"The Celestial Aesthetic Purist"*
- **Trạng thái**: 🟢 **ĐÃ PHÊ DUYỆT (Approved by User & PO Gate 2 Sign-off)**
- **Mục tiêu phiên bản**: `v1.7.0` (Sprint 08)
- **Tham chiếu PRD**: [`docs/03-prd-features/15-cinematic-celestial-hud/prd-cinematic-celestial-hud.md`](file:///Users/nguyenduytrang/flutter_project/AstroBite/docs/03-prd-features/15-cinematic-celestial-hud/prd-cinematic-celestial-hud.md)

---

## 🎨 1. Google Stitch MCP Integration & Visual Ground Truth

Thiết kế của màn hình **AR Food Scanner & Holographic Nutrition Review** đã được tự động sinh và lưu trữ trên hệ thống máy chủ **Google Stitch MCP** tuân thủ 100% tài liệu `DESIGN.md` và bảng mã màu `AppColors`:

| Thuộc tính MCP Stitch | Giá trị chi tiết |
| :--- | :--- |
| **Project ID** | `projects/4740603587325816667` ("AstroBite Design System") |
| **Design System Asset** | `assets/0714ee32493c4b57824bc613d5d8da78` (Celestial Dark UI) |
| **Screen ID** | `projects/4740603587325816667/screens/902c781fecba432a84504fb895c44886` |
| **Tên Màn Hình** | **AstroBite - Holographic AR HUD Food Scanner** |
| **Độ phân giải bản vẽ** | `780 x 1768` (Tỷ lệ chuẩn Mobile 390x844pt @2x Retina) |
| **Snapshot Mockup URL** | [Xem Ảnh Chụp Thiết Kế Trực Quan](https://lh3.googleusercontent.com/aida/AEtjO1Wtwc5p3Xo6fs0TAuPSqJsxOmKEiEEAPZU1re_GNpZRMN2FRHKdT5MBnKpF1Y-uufyIrnZiMO2B83nbic8lGFNOCmZ924iCK0cWYj603pwnUVYK0eKKlMDwg9VSYHFF3QTDJBtODiFsagpY3gnU9C40oVbTvlgLhL83FqWDMLCQKqqhUI-1Cny6TEx49iF1MPi6ms1nEa7ecoaGl493m-9h4QBBrw2RqEi_nVFLoGWJ5Rn3Iyaf1AkVdLo) |
| **Mã Nguồn Bố Cục (HTML/CSS)** | [Tải Tệp HTML Layout Chuẩn](https://contribution.usercontent.google.com/download?c=CgthaWRhX2NvZGVmeBJ7Eh1hcHBfY29tcGFuaW9uX2dlbmVyYXRlZF9maWxlcxpaCiVodG1sXzM1ZDA5MzIwMjg2ZjRlOTBiOTc4NjFjZWEwZDFiNzM5EgsSBxDX2ISe8RsYAZIBIwoKcHJvamVjdF9pZBIVQhM0NzQwNjAzNTg3MzI1ODE2NjY3&filename=&opi=96797242) |

---

## 🧭 2. Sơ Đồ Điều Hướng & Luồng Trải Nghiệm (Mermaid Flow)

```mermaid
graph TD
    A[Màn hình Chính / Home Cockpit] -->|Chạm FAB Camera trung tâm| B(CameraPage: Viewfinder AR HUD)
    
    subgraph AR HUD Scanner Experience
        B -->|Khung ngắm Sci-Fi xoay 60 FPS| B1[Double Corner Brackets + Rotating Reticle]
        B1 -->|Vệt quét laser quét dọc| B2[Scanner Beam Animation]
        B2 -->|AI phát hiện thức ăn| B3[Telemetry: FOCAL LOCK 98%]
        B3 -->|Gắn thẻ nổi trên món ăn| B4[Floating Tag: Phở Bò Tái Nạm - 450 kcal]
    end

    subgraph Holographic Review & Logging
        B4 -->|Mở phiếu kính mờ từ đáy| C(Holographic Bento Sheet)
        C -->|Xem lượng calo & vòng tiến độ| C1[Hero Calorie 450 kcal + 21% Target Gauge]
        C -->|Xem bộ 3 Macro chuẩn màu| C2[🔵 Carbs 52g | 🟡 Protein 28g | 🩷 Fat 14g]
        C -->|Chạm Stepper điều chỉnh khẩu phần| C3[Steppers: -50g / 1 Bát 350g / 1 Đĩa 300g / +50g]
        C3 -->|Chạm nút Lưu ở đáy màn hình| C4[Nút Lưu vào Nhật ký - Electric Blue 48pt]
        C4 -->|Hoàn tất và quay lại Cockpit| A
    end
```

---

## 📐 3. Bản Vẽ Bố Cục Chi Tiết Theo Lưới 4pt (Screen Layout Blueprint)

```
┌─────────────────────────────────────────────────────────────┐  0pt (Top)
│ [ < ]       AR Food Scanner  ✦         [ ⚡ ]   [ ▦ ]       │  Top Bar (h: 56pt, Glassmorphism)
│             Gemini Vision AI 2.0 • Active                   │  Subtitle cyan #38BDF8
├─────────────────────────────────────────────────────────────┤
│                                                             │
│         ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐               │  AR HUD Corner Brackets
│         │   [FOCAL LOCK: 98.4% CONFIDENCE]  │               │  Neon #1A73E8
│   X:104 │                                   │ Z:0.84m       │
│   Y:382 │              ( ( ✦ ) )            │ FPS:60        │  Rotating Reticle Ring
│         │                                   │               │  Vertical Laser Beam
│         └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘               │
│                            │                                │
│               ┌────────────────────────┐                    │  Floating Holographic Tag
│               │ 🍽️ Phở Bò Tái Nạm [AI] │  450 kcal          │  (GlassCard #112240)
│               └────────────────────────┘                    │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  ═════════════════════════════════════════════════════════  │  BENTO GLASS SHEET
│  ─── (Drag Handle) ───────────────────────────────────────  │  (#112240, blur 20, border 1px)
│                                                             │
│  450 kcal                              ( 21% ) Mục tiêu     │  Hero Calorie & Dial
│  Khẩu phần tiêu chuẩn • 1 Bát (350g)     2,100 kcal         │
│                                                             │
│  ┌────────────────┐  ┌────────────────┐  ┌────────────────┐ │  HOLOGRAPHIC MACRO TRIAD
│  │ 🔵 Carbs       │  │ 🟡 Protein     │  │ 🩷 Fat         │ │  (Strict Token Colors)
│  │ 52g (48%)      │  │ 28g (24%)      │  │ 14g (28%)      │ │  Micro progress bar
│  │ [========    ] │  │ [====        ] │  │ [=====       ] │ │
│  └────────────────┘  └────────────────┘  └────────────────┘ │
│                                                             │
│  Điều chỉnh khẩu phần:                                      │  Portion Steppers
│  [ -50g ]  [ 🔵 1 Bát (~350g) ]  [ 1 Đĩa (~300g) ]  [ +50g ]│  (Min touch 44pt)
│                                                             │
│  [ 🔄 ]  [        ✓  Lưu vào Nhật ký (Primary CTA)        ] │  Sticky Bottom Bar (h: 48pt)
└─────────────────────────────────────────────────────────────┘  Thumb Zone
```

---

## 🎨 4. Bảng Ánh Xạ Tokens & Widget Flutter Cho Đội Ngũ Dev

Đội ngũ Dev FE (`flutter-core-dev`) bắt buộc ánh xạ chuẩn xác từ mẫu Stitch sang Flutter Widgets:

| Thành phần Stitch HTML/CSS | Token Trong `AppColors` | Widget Triển Khai Flutter | Ghi chú & Ràng buộc |
| :--- | :--- | :--- | :--- |
| Nền toàn màn hình (`#0A192F`) | `AppColors.surface` | `Scaffold(backgroundColor: AppColors.surface)` | Nền Midnight Navy không đổi |
| Tấm kính nổi Bento (`#112240`) | `AppColors.surfaceContainer` | `GlassCard` hoặc `Container` bo góc 24px | `surfaceTintColor: Colors.transparent` |
| Hiệu ứng kính mờ (`backdrop-blur-xl`) | `AppColors.surfaceBlur` | `BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20))` | Định nghĩa cạnh 1px trắng mờ |
| Góc ngắm AR HUD (`#1A73E8`) | `AppColors.primary` | `CustomPainter` (`ScanningViewfinder`) | Đường nét 3px, bo góc 8px, glow |
| Vòng xoay tâm ngắm (`hud-rotating`) | `AppColors.primary` | `RotationTransition` + `CustomPainter` (dashed arc) | Chạy mượt mà 60 FPS |
| Chỉ số Carbs (`#1A73E8`) | `AppColors.primary` | `MacroBar` / Bento Pill màu Primary | Bất biến ngữ nghĩa Carbs |
| Chỉ số Protein (`#FFD700`) | `AppColors.tertiary` | `MacroBar` / Bento Pill màu Tertiary | Bất biến ngữ nghĩa Protein |
| Chỉ số Chất béo (`#FF69B4`) | `AppColors.secondary` | `MacroBar` / Bento Pill màu Secondary | Bất biến ngữ nghĩa Fat |
| Nút bấm chính (*Lưu vào Nhật ký*) | `AppColors.primary` | `ElevatedButton` hoặc `Container` bóng đổ `0 4px 20px #1A73E8` | Chiều cao 48pt, bo tròn full pill |

---

## 📱 5. Đặc Tả 5 Trạng Thái Giao Diện (5 Screen States)

1. **Default State**: Camera hoạt động mượt mà, khung ngắm AR HUD hiển thị tọa độ telemetry và vòng tròn tâm ngắm nhẹ nhàng xoay 60 FPS.
2. **Detection Locked State**: Nhãn AI Verified nổi trên món ăn, vệt laser dừng ở điểm khóa mục tiêu, phiếu Bento kính mờ bung nhẹ từ đáy với hiệu ứng lò xo mượt mà.
3. **Loading / Analyzing Shimmer State**: Khi người dùng bấm chụp hoặc chọn ảnh từ thư viện, vòng tâm ngắm chuyển sang xung nhịp màu xanh cyan 1.5s chu kỳ, hiển thị dòng chữ *"AI đang phân tích cấu trúc dinh dưỡng..."*.
4. **Empty / No Food Detected State**: Khung ngắm hiển thị viền vàng mờ, thông báo hướng dẫn: *"Không tìm thấy món ăn trong khung hình. Vui lòng căn chỉnh lại góc máy hoặc chọn Nhập tay."*.
5. **Offline State**: Huy hiệu Offline màu hổ phách xuất hiện góc trên, thông báo: *"Chế độ ngoại tuyến: Gemini AI trên thiết bị sẽ xử lý dữ liệu và đồng bộ khi có mạng."*.
