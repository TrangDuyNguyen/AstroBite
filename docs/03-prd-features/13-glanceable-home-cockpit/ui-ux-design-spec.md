# Hồ Sơ Đặc Tả Thiết Kế Giao Diện (Gate 2 UI/UX Design Spec)
## Màn Hình Tổng Quan Hôm Nay: Glanceable Celestial Cockpit

- **Mã tính năng**: `FEAT-13`
- **Mã Epic liên kết**: `EPIC-15`
- **Bộ phận phụ trách**: Sub-Agent Mobile UI/UX Designer — *"The Celestial Aesthetic Purist"*
- **Mô hình AI vận hành**: Gemini 3.8 Flash (Medium) / Google Stitch MCP
- **Mã định danh Stitch Screen**: `projects/4740603587325816667/screens/db13f5531baf4aeab67ab09be0b5bafa`
- **Trạng thái**: 🟢 **Approved (Gate 2 Sign-Off by BA & PO)**
- **Ngày hoàn thành**: 2026-09-22

---

## 🎨 1. Bản Vẽ Mockup Thị Giác & Bố Cục Tổng Thể (Visual Ground Truth)

> [!NOTE]
> Bản vẽ được sinh tự động và tinh chỉnh từ Google Stitch MCP, dựa trên Design System **Celestial Dark UI** của AstroBite.

![Bản vẽ Giao diện Concept 1: Celestial Cockpit](/Users/nguyenduytrang/.gemini/antigravity-ide/brain/27662239-8d58-4944-b74d-2cccbfeef13d/demo1_cockpit.png)

---

## 📐 2. Bản Vẽ Bố Cục Chi Tiết Theo Lưới 4pt (Screen Layout Blueprint)

```
┌─────────────────────────────────────────────────────────────┐  0pt (Top)
│ [Avatar]   Hôm nay • Thứ Hai, 27 Th07      [🔥 7 Ngày Streak]│  AppBar (h: 56pt)
├─────────────────────────────────────────────────────────────┤
│ [Celestial Offline Banner (Khi offline)]                    │  h: 36pt (nếu có)
├─────────────────────────────────────────────────────────────┤
│ [DatePickerStrip: 7 ngày xoay vòng]                         │  h: 64pt, p: 16pt
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ╔═══════════════════════════════════════════════════════╗  │  CELESTIAL COCKPIT
│  ║ 🚀 CELESTIAL COCKPIT           Mục tiêu: 2.100 kcal   ║  │  Card Container
│  ║                                                       ║  │  (bg: #112240)
│  ║  ┌──────────────┐     🔵 Carbs       120 / 220g (55%) ║  │  Bo góc: 16px
│  ║  │  Còn lại     │     [═════════════             ]    ║  │  Padding: 16pt
│  ║  │   650        │     🟡 Protein     85 / 130g  (65%) ║  │  Viền: 1px sao mờ
│  ║  │   KCAL       │     [══════════════════        ]    ║  │
│  ║  └──────────────┘     🩷 Fat         38 / 65g   (58%) ║  │
│  ║   (Arc: 130pt)        [══════════════            ]    ║  │
│  ║                                                       ║  │
│  ║  ───────────────────────────────────────────────────  ║  │
│  ║  🔬 Vi chất: Natri 1.400mg • Xơ 22g • Đường 28g  ▾    ║  │  Collapsible Pill
│  ╚═══════════════════════════════════════════════════════╝  │  h: ~210pt
│                                                             │
├─────────────────────────────────────────────────────────────┤
│ Nhật ký bữa ăn (4 bữa • Cần nạp đủ duy trì năng lượng)      │  h: 28pt, p: 16pt
├─────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────┐  │  Meal Cards
│  │ 🍳 Bữa sáng  • Phở bò tái nạm      450 kcal  [  ✓  ]  │  │  p: 12pt
│  │    C: 55g | P: 28g | F: 12g                           │  │  Touch Target >= 44pt
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ 🥗 Bữa trưa  • Cơm gà áp chảo      620 kcal  [  ✓  ]  │  │
│  │    C: 45g | P: 42g | F: 14g                           │  │
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ 🍲 Bữa tối   • Salad bơ cá hồi     380 kcal  [  ✓  ]  │  │
│  │    C: 20g | P: 15g | F: 12g                           │  │
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │ 🍎 Bữa phụ   • Chưa ghi nhận món ăn          [ (+) ]  │  │  Nút (+) 44x44pt
│  └───────────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│  [✨ Gợi ý từ AstroCoach: Cần thêm 45g Protein hôm nay...]   │  h: 44pt (1 dòng)
├─────────────────────────────────────────────────────────────┤
│ [Bottom Nav: Today (Active) | Coach | 📷 Scan FAB | Profile] │  h: 64pt + Safe Area
└─────────────────────────────────────────────────────────────┘
```

---

## 🎨 3. Ánh Xạ Design Tokens Chuẩn Celestial Dark UI

| Thành phần giao diện | Token / Thuộc tính | Giá trị màu / Kích thước |
| :--- | :--- | :--- |
| **Nền tổng thể ứng dụng** | `AppColors.surface` | `#0A192F` (Midnight Sky) |
| **Bề mặt Thẻ Cockpit & Bữa ăn** | `AppColors.surfaceContainer` | `#112240` (Deep Navy), bo góc `16px` |
| **Đường viền thẻ kính** | `AppColors.outline` | `0x1FFFFFFF` (Ánh sao viền mờ 1px) |
| **Vòng Calo Progress Arc** | `AppColors.primary` (hoặc Tertiary nếu lố calo) | `#1A73E8` (Electric Blue glow) |
| **Thanh tiến độ Carbs** | `AppColors.primary` | `#1A73E8` (Bất biến) |
| **Thanh tiến độ Protein** | `AppColors.tertiary` | `#FFD700` (Bất biến) |
| **Thanh tiến độ Fat** | `AppColors.secondary` | `#FF69B4` (Bất biến) |
| **Chữ số Calo nổi bật** | `Typography: custom-calorie` | `26pt Bold`, `letterSpacing: +0.5` |
| **Touch target nút (+) / tick** | `AppValues.touchTarget` | Tối thiểu `44 × 44pt` |

---

## 🔄 4. Đặc Tả 5 Trạng Thái Giao Diện Bắt Buộc (5 UI States)

1. **Default State (Bình thường)**:
   - Hiển thị đầy đủ Cockpit với số liệu calo, 3 thanh macro và 4 bữa ăn kèm danh sách món đã log.
2. **Loading / Skeleton Shimmer State**:
   - Khối Cockpit và 4 thẻ bữa ăn hiển thị hiệu ứng Shimmer trên nền container `#112240` (chu kỳ 1.5s), không giật khung hình.
3. **Empty State (Đầu ngày mới - Chưa ăn gì)**:
   - Số calo còn lại bằng đúng mục tiêu (vd: 2.100 kcal).
   - 3 thanh macro ở mức 0%.
   - Chip trạng thái: `🌌 THẮP SÁNG TIỂU VŨ TRỤ HÔM NAY`.
   - 4 bữa ăn hiển thị chữ *"Chưa ghi nhận món ăn"* kèm nút `+` Quick-add mời gọi.
4. **Error / Overflow State (Vượt ngân sách calo)**:
   - Khi Calo nạp > Calo mục tiêu: Vòng tròn đổi sang màu cảnh báo Vàng Gold (`#FFD700`), hiển thị `+X kcal vượt ngân sách`. Viền thẻ Cockpit phát sáng vàng cảnh báo.
5. **Offline State**:
   - `CelestialOfflineBanner` xuất hiện phía trên đỉnh màn hình, toàn bộ dữ liệu đọc từ bộ nhớ đệm cục bộ (Local Cache) phản hồi tức thì < 10ms.

---

## ✍️ 5. Biên Bản Ký Duyệt Thiết Kế Gate 2 (Design Sign-Off)

- **Đại diện BA**: Ký duyệt 100% đối soát nghiệp vụ theo PRD FEAT-13.
- **Đại diện PO**: Phê duyệt trải nghiệm người dùng đạt tiêu chuẩn Time-to-Understand < 1.5 giây, công thái học chuẩn 44pt và hệ màu Celestial Dark UI bất biến.
- **Phán quyết**: 🟢 **GATE 2 SIGNED OFF — Chuyển giao sang Gate 3 (QA) & Gate 4 (Dev FE)**.
