# Thiết Kế Chi Tiết Hệ Thống AstroVoice AI (Hands-Free Voice Logging Spec)

> **Tài liệu**: Superpowers Architectural Design Specification  
> **Dự án**: AstroBite (`astrobite`)  
> **Phiên bản mục tiêu**: `v3.0.0` (Sprint 20)  
> **Tác giả**: Sub-Agent Tech Lead & Sub-Agent PO  
> **Trạng thái**: 🟢 **GATE 0 DRAFT & READY FOR BRAINSTORMING SIGN-OFF**

---

## 1. Tầm Nhìn Sản Phẩm & Chỉ Số Thành Công (Product Vision & OKRs)

- **Mục tiêu tối thượng**: Xóa bỏ hoàn toàn rào cản thời gian và thao tác gõ phím khi ghi nhận nhật ký ăn uống.
- **Trải nghiệm đích**: Người dùng chỉ mất **dưới 3 giây** từ lúc mở app, nói 1 câu tự nhiên tới khi dữ liệu bữa ăn được lưu trọn vẹn vào Food Diary.
- **Chỉ số SLAs**:
  - Tỷ lệ nhận diện đúng món ăn & khẩu phần: $\ge 90\%$.
  - Tổng thời gian phản hồi (Speech End ➔ GenUI Rendered): $\le 1.5$ giây.
  - Tốc độ khung hình hiển thị sóng âm: $\ge 55$ FPS (zero stutter).
  - Tỷ lệ crash do cấp quyền Microphone: $0\%$.

---

## 2. Luồng Người Dùng & Các Trạng Thái Giao Diện (UX Flow & 5 States)

```
[Chạm Nút Mic Nổi hoặc Quick Action Bar]
                   │
                   ▼  (Haptic Pulse + Mở AstroVoiceSheet)
      [Trạng thái 1: LISTENING - Đang Lắng Nghe]
      - Hiển thị Cosmic Pulsing Ripple & Sóng Âm (Waveform)
      - Live Speech-to-Text streaming: hiển thị chữ chạy theo giọng nói
                   │
                   ▼  (User ngừng nói sau 1.2s hoặc nhấn nút "Xong")
      [Trạng thái 2: PARSING - Đang Phân Tích Gemini NLU]
      - Shimmer Loader nhẹ nhàng
      - Gemini 2.0 Flash phân tích số lượng, calo, macro
                   │
                   ▼
      [Trạng thái 3: READY / SUCCESS - Hiển thị GenUI Card]
      - Card `MealQuickLogCard` hiển thị: Tên món, Khẩu phần, Calo, 3 Macro
      - Nút "Lưu Vào Bữa Ăn (1-Tap)" [Xanh Duolingo 3D]
      - Nút "Sửa Nhanh" nếu muốn chỉnh lại calo hoặc gram
                   │
     ┌─────────────┴─────────────┐
     ▼                           ▼
[Lưu Thành Công]           [Xử Lý Lỗi / Edge Cases]
- Ghi vào FoodLog          - Trạng thái 4: EMPTY (Không nghe thấy tiếng nói)
- Đồng bộ Cockpit & Arc    - Trạng thái 5: ERROR (Mất mạng / Gemini từ chối)
```

---

## 3. Gemini 2.0 Flash NLU System Prompt Specification

Prompt được tinh chỉnh chuyên sâu để xử lý ngôn ngữ tự nhiên tiếng Việt, từ lóng ăn uống, và các đơn vị ước lượng dân dã:

```text
Bạn là chuyên gia dinh dưỡng và trợ lý phân tích ngôn ngữ tự nhiên (NLU) cho ứng dụng AstroBite.
Nhiệm vụ của bạn là nhận vào một câu nói ghi chép bữa ăn bằng tiếng Việt tự nhiên và trích xuất thành JSON dinh dưỡng có cấu trúc.

Quy tắc phân tích:
1. Xác định bữa ăn: Nếu người dùng có nhắc "sáng", "trưa", "tối", "xế", "phụ" thì ánh xạ sang: breakfast, lunch, dinner, snack. Nếu không nhắc, sử dụng inferred_meal_type được cung cấp.
2. Bóc tách các món ăn (dishes): Tách riêng từng món, ước tính khối lượng (grams) theo đơn vị nói (bát, tô, đĩa, cái, quả, ly, cốc, hộp).
3. Tính toán dinh dưỡng:
   - calories (kcal - số nguyên)
   - carbs_g, protein_g, fat_g (gam - số thực 1 chữ số thập phân)
   - sodium_mg (miligam)
4. Phân loại thuộc tính đặc biệt:
   - Nhận diện nước dùng (has_broth, broth_calories) nếu là món bún/phở/hủ tiếu.
   - Nhận diện ghi chú bổ sung (ví dụ: "ít đường", "nhiều rau", "không mỡ hành").

Định dạng JSON đầu ra bắt buộc:
{
  "meal_type": "breakfast" | "lunch" | "dinner" | "snack",
  "total_calories": number,
  "macros": {
    "protein_g": number,
    "carbs_g": number,
    "fat_g": number
  },
  "sodium_mg": number,
  "dishes": [
    {
      "dish_name": string,
      "estimated_weight_g": number,
      "calories": number,
      "protein_g": number,
      "carbs_g": number,
      "fat_g": number,
      "notes": string?
    }
  ],
  "confidence_score": number
}
```

---

## 4. Kế Hoạch Phân Rã WBS & Story Points (Sprint 20)

| Mã Task | Phân Đoạn & File Trọng Tâm | Gate | Mô Tả | Sub-Agent | SP |
|:---|:---|:---:|:---|:---:|:---:|
| `TSK-S20-00-SPIKE` | `docs/superpowers/specs/`, `adr-s20-voice-logging.md` | **G0** | Tech Lead & PO: Brainstorming & Architectural Spec cho Voice Logging | `tech-lead` | 1 |
| `TSK-S20-01-PRD` | `docs/03-prd-features/27-hands-free-voice-logging/` | **G1** | BA: Soạn thảo PRD & BDD Given-When-Then cho luồng nói tự nhiên | `business-analyst` | 2 |
| `TSK-S20-02-DESIGN` | `docs/03-prd-features/27-hands-free-voice-logging/ui-ux-design.md` | **G2** | UI/UX Designer: Thiết kế AstroVoiceSheet, Pulsing Mic & 5 States | `ui-ux-designer` | 2 |
| `TSK-S20-03-TEST-PLAN` | `docs/03-prd-features/27-hands-free-voice-logging/gate-3-test.md` | **G3** | QA Tester: Thiết kế bộ test cases biên (âm thanh ồn, ngắt lời, tiếng lóng) | `qa-tester` | 1 |
| `TSK-S20-04-VOICE-SERVICE` | `features/voice/data/datasources/`, `pubspec.yaml` | **G4** | Native Dev: Cấu hình `speech_to_text`, cấp quyền Mic iOS/Android, Mockable Service | `flutter-native-dev` | 3 |
| `TSK-S20-05-VOICE-UI` | `features/voice/presentation/`, `home_page.dart` | **G4** | Dev FE: Dựng AstroVoiceSheet, tích hợp GenUI MealQuickLogCard 1-Tap Log | `flutter-core-dev` | 4 |
| `TSK-S20-06-REVIEW` | Git Diff Sprint 20 | **G5** | Reviewer: Ponytail Diff Review, zero bloat, zero test regression | `code-reviewer` | - |
| `TSK-S20-07-VERIFY` | Automated Test Suite | **G6** | QA Tester: 100% test pass thực chất, đo đạc SLA latency $\le 1.5s$ | `qa-tester` | - |
| `TSK-S20-08-SECURITY` | Security Audit & AppSec | **G6.5** | Security Auditor: Kiểm toán quyền Microphone PII & Prompt Injection qua giọng nói | `security-auditor` | - |
| `TSK-S20-09-RELEASE` | Tag release `v3.0.0` | **G7** | Hội Đồng Tối Cao: Ký duyệt phát hành siêu cột mốc v3.0.0 | `product-owner` | - |

**Tổng Story Points**: **13 SP**.

---

## 5. Kết Luận Gate 0
Thiết kế kiến trúc tận dụng triệt để nền tảng On-Device Speech Recognition kết hợp với sức mạnh suy luận tiếng Việt của Gemini 2.0 Flash NLU, bảo đảm tốc độ siêu tốc $\le 1.5s$, chi phí 0đ cho tầng âm thanh và đạt chuẩn Ponytail tối giản.
