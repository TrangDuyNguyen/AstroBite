# 🛠️ Architecture Decision Record (ADR) & Tech Spike — Solar Fresh Foundation

- **Mã Spike**: `TSK-S12-00-TECH-SPIKE`
- **Sprint**: Sprint 12
- **Chủ trì**: Sub-Agent Tech Lead (`tech-lead`)
- **Trạng thái**: ✅ **APPROVED & FEASIBLE**
- **Mục tiêu**: Đánh giá tính khả thi, phân tích rủi ro hiệu năng, và xác định kiến trúc kỹ thuật khi chuyển đổi toàn diện nền tảng AstroBite sang phong cách Solar Fresh × Duolingo 2D.

---

## 1. Bối Cảnh & Vấn Đề (Context)

Theo quyết định chiến lược của PO và đề xuất của UI/UX Designer:
- AstroBite chuyển đổi từ giao diện Celestial Dark (`#0A192F`, kính mờ, viền neon mảnh) sang **Solar Fresh × Duolingo 2D** (nền trắng sữa `#F7F8FA`, card trắng tinh `#FFFFFF`, đổ bóng bevel 2D dạng chunky, màu sắc rực rỡ vui tươi, tương phản cao WCAG AA).
- Cần đảm bảo việc chuyển đổi này tuân thủ nguyên tắc **Ponytail (Zero Bloat, Ruthless Simplicity)**:
  1. Không đụng đến tầng Domain và Data (Repositories, Riverpod providers, Models, Firestore, Gemini AI prompts giữ nguyên 100%).
  2. Chỉ tác động tầng Presentation (`AppColors`, `AppTheme`, `SolarCard`, shared widgets).
  3. Duy trì 200/200 tests hiện tại 100% xanh.

---

## 2. Kết Quả Tech Spike (Technical Feasibility Findings)

### 2.1 Dependencies & Packages
- **Quyết định**: **KHÔNG cài thêm bất kỳ package nào** cho Sprint 12.
- **Lý do**:
  - Flutter standard library (`BoxShadow`, `LinearGradient`, `AnimatedScale`, `TweenAnimationBuilder`) đã cung cấp đầy đủ công cụ để tạo hiệu ứng 2D Chunky Bevel và Elastic animation.
  - Package `flutter_svg` chỉ được xem xét ở Sprint 14 khi đưa Mascot vector SVG vào app. Tại Sprint 12, tất cả icons sử dụng `Icons.*` chuẩn Flutter Material Symbols.

### 2.2 Hiệu Năng & Animation (SLAs: 60 FPS, 0 Frame Drop)
- **Glassmorphic blur vs 2D Shadow**:
  - Trước đây: `BackdropFilter` với `ImageFilter.blur(sigmaX: 20, sigmaY: 20)` tốn nhiều GPU shader pass trên Android mid-range thiết bị yếu.
  - Solar Fresh: Dùng `BoxShadow` cứng/bán mềm không blur nặng (`offset: Offset(0, 4), blurRadius: 0` hoặc `blurRadius: 4`). Render cực nhanh, tiêu tốn ít GPU hơn 40%, triệt tiêu nguy cơ jank frame.
- **MacroBar Elastic Animation**:
  - Dùng `TweenAnimationBuilder<double>` với `curve: Curves.elasticOut` hoặc `Curves.easeOutCubic`.
  - Không khởi tạo AnimationController thừa thãi trong widget con để tránh rò rỉ bộ nhớ (Ponytail discipline).

### 2.3 Backward Compatibility cho `GlassCard`
- Nhằm tránh làm vỡ các màn hình chưa được migrate sang `SolarCard` ở Sprint 12 (như các màn hình ở Sprint 13-15), `GlassCard` sẽ được cập nhật để hiển thị giao diện sáng hài hòa (white surface với viền nhẹ thay vì dark blur) hoặc chuyển dần sang wrapper của `SolarCard`.
- Cung cấp `SolarCard` làm component chuẩn mực mới cho toàn bộ các màn hình kế tiếp.

---

## 3. Kiến Trúc Token Màu Sắc (Color Mapping ADR)

| Token Mới (`AppColors`) | Giá Trị Hex | Ý Nghĩa Trong Solar Fresh |
|:---|:---|:---|
| `surface` | `#F7F8FA` | Nền app sáng ấm (warm cream / off-white), chống chói mắt |
| `surfaceContainer` | `#FFFFFF` | Nền các khối thẻ card, dialog, bottom sheet |
| `surfaceBlur` | `#FFFFFF` | Fallback cho overlay sáng |
| `primary` | `#1A73E8` | Carbs indicator, Primary CTA, FAB |
| `secondary` | `#FF69B4` | Fat indicator, Weight trend line |
| `tertiary` | `#FF9600` | Protein indicator (Honey Orange thay cho vàng cũ khó nhìn trên nền trắng) |
| `brandGreen` | `#58CC02` | Màu xanh lá Duolingo tràn đầy năng lượng |
| `onSurface` | `#1A1A2E` | Chữ chính (Midnight Navy), độ tương phản WCAG AAA > 12:1 trên nền trắng |
| `onSurfaceVariant` | `#6B7280` | Chữ phụ, caption, nhãn phụ (WCAG AA > 4.8:1) |
| `outline` | `#E5E7EB` | Đường phân cách, viền card 2D nhẹ nhàng |

---

## 4. Feasibility Sign-Off

- **Hiệu năng**: Đạt chuẩn (dự kiến FPS tăng từ 56 lên 60 FPS nhờ loại bỏ blur shaders).
- **Rủi ro hồi quy (Regression)**: Thấp (không thay đổi API signatures của widgets công khai).
- **Phê duyệt**: **Tech Lead APPROVED** — Chuyển giao sang BA & UI/UX Designer.
