# PRD: Hệ Thống Gamification & Chuỗi Ngày Dinh Dưỡng Vũ Trụ (Cosmic Streak & Energy Engine)

- **Mã tính năng**: `FEAT-11`
- **Mã Epic liên kết**: `EPIC-13` (Gamification & Streak Engine)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA) — *"The Pedantic Logician"*
- **Trạng thái**: 🟡 **In Review (Chờ PO Phê Duyệt Gate 1)**
- **Mục tiêu phiên bản**: `v1.4.0` (Sprint 05)
- **Tham chiếu kiến trúc**: `docs/04-specifications/adr-05-gamification-and-widgets.md` (Gate 0)
- **Đối chiếu UI/UX**: `docs/03-prd-features/11-gamification-streak/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `tests/03-bdd-gherkin-scenarios/gamification_streak.feature` (Gate 3)
- **Đối chiếu FE**: `lib/features/gamification/` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- Khảo sát hành vi người dùng dinh dưỡng cho thấy **68% người dùng từ bỏ app sau ngày thứ 4** vì cảm giác ghi chép đơn điệu, áp lực tính calo và thiếu động lực tức thì.
- Khi người dùng lỡ quên ghi chép 1 ngày, họ cảm thấy thất bại ("broken chain syndrome") và có xu hướng xóa ứng dụng thay vì tiếp tục.
- Hệ thống cần một cơ chế tâm lý tích cực (Positive Reinforcement) gắn kết với triết lý **Cosmic Nutrition**: xem mỗi ngày nạp calo/macro chuẩn là một ngày "nạp đầy năng lượng hành tinh" và trao thưởng danh hiệu vũ trụ xứng đáng.

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Tăng D30 Retention**: Đưa tỷ lệ giữ chân sau 30 ngày từ **35% lên ≥ 42%**.
- **Tăng Daily Active Users (DAU)**: Đạt mức tăng trưởng **+30%** sau 4 tuần triển khai.
- **Tỷ lệ tham gia Streak**: ≥ 75% người dùng tích cực duy trì chuỗi từ 3 ngày trở lên.
- **Giảm tỷ lệ Churn khi lỡ quên 1 ngày**: Giảm **60%** tỷ lệ bỏ app nhờ cơ chế bảo vệ chuỗi **Starlight Shield**.
- **Hiệu năng hệ thống**: Thời gian tính toán và hiển thị Streak < **30ms**; chuyển động hạt năng lượng đạt **60 FPS** ổn định.

---

## 2. Đối Tượng Người Dùng (Target Personas)

1. **Người Cần Kỷ Luật Thép (Accountability Seekers)**: Dễ nản chí sau 3-5 ngày, cần nhìn thấy con số chuỗi ngày tăng dần để có động lực mở app ghi log mỗi bữa.
2. **Người Thích Chinh Phục (Gamers & Achievers)**: Bị kích thích bởi việc sưu tập các huy hiệu hiếm, mở khóa các danh hiệu vũ trụ (Celestial Titles) khi hoàn thành các mục tiêu macro khó.
3. **Người Dùng Bận Rộn Hay Quên (Accidental Forgetters)**: Rất dễ quên log đồ ăn vào cuối tuần; cần có khiên bảo vệ (Starlight Shield) để không cảm thấy công sức cả tuần đổ sông đổ biển.

---

## 3. Quy Tắc Nghiệp Vụ & Luồng Hoạt Động (Business Rules & Logic)

### 3.1. Định Nghĩa "Ngày Ăn Sạch / Ngày Hoạt Động" (Active Cosmic Day)
1. **Điều kiện ghi nhận ngày hợp lệ**:
   - Người dùng ghi nhận ít nhất **1 món ăn (Meal Log)** trong ngày theo giờ địa phương (`localDate: yyyy-MM-dd`).
2. **Điều kiện "Ngày Hoàn Hảo" (Perfect Cosmic Day)**:
   - Tổng calo tiêu thụ trong ngày đạt từ **85% đến 110%** mục tiêu hàng ngày (`dailyTargetCalories`).
   - Đạt "Perfect Day" sẽ nhân đôi điểm kinh nghiệm vũ trụ (Starlight XP) và thắp sáng toàn bộ vòng hào quang Celestial Core.

### 3.2. Cơ Chế Tính Chuỗi (Streak Engine Logic)
- **Bắt đầu chuỗi**: Ngày đầu tiên có log $\rightarrow$ `currentStreak = 1`.
- **Duy trì chuỗi**: Nếu ngày hôm nay ($D$) có log và ngày hôm qua ($D-1$) đã có log $\rightarrow$ `currentStreak += 1`.
- **Kỷ lục chuỗi**: `longestStreak = max(longestStreak, currentStreak)`.
- **Cơ chế Starlight Shield (Khiên Bảo Vệ)**:
  - Mỗi tài khoản khởi tạo được tặng **1 Khiên miễn phí**.
  - Cứ mỗi **7 ngày chuỗi liên tiếp** đạt được, người dùng nhận thêm **1 Khiên** (Tối đa tích lũy: **2 Khiên**).
  - Nếu người dùng quên log ngày hôm qua ($D-1$), nhưng hôm nay ($D$) mở app ghi log:
    - Nếu còn Khiên: Tự động trừ 1 Khiên, giữ nguyên chuỗi và cộng tiếp ngày hôm nay. Hiển thị thông báo: *"Khiên Tinh Tú đã bảo vệ chuỗi ngày của bạn!"*.
    - Nếu không còn Khiên: Chuỗi bị đặt lại về `1`.

### 3.3. Danh Mục Huy Hiệu Tiểu Vũ Trụ (Cosmic Badges)

| ID Huy Hiệu | Tên Huy Hiệu | Điều Kiện Mở Khóa | Ý Nghĩa Vũ Trụ |
|:---|:---|:---|:---|
| `starlight_novice` | **Tân Binh Tinh Tú** | Đạt chuỗi 3 ngày liên tiếp | Tia sáng đầu tiên nhen nhóm trong tiểu vũ trụ cá nhân. |
| `pulsar_pioneer` | **Thám Hiểm Pulsar** | Đạt chuỗi 7 ngày liên tiếp | Năng lượng phát xung tuần hoàn đều đặn, tạo thói quen bền vững. |
| `supernova_titan` | **Chiến Thần Siêu Tân Tinh** | Đạt chuỗi 30 ngày liên tiếp | Bùng nổ chuyển hóa dinh dưỡng, cơ thể lột xác hoàn toàn. |
| `protein_hunter` | **Thợ Săn Đạm Vũ Trụ** | Đạt 100% mục tiêu Protein trong 5 ngày liên tiếp | Xây dựng cơ bắp vững chắc bằng các khối cấu tạo hành tinh. |
| `macro_master` | **Bậc Thầy Cân Bằng** | Đạt cả 3 chỉ số Carbs/Fat/Protein chuẩn mục tiêu trong 3 ngày | Thế cân bằng hoàn hảo của vũ trụ dinh dưỡng. |

---

## 4. Kịch Bản Kiểm Thử Chấp Nhận Nghiệp Vụ BDD (Given-When-Then)

### Kịch Bản 1: Người dùng log món ăn đầu tiên trong ngày kế tiếp
- **Given**: Người dùng đang có chuỗi `currentStreak = 3`, ngày hoạt động gần nhất là `2026-09-18`.
- **When**: Hôm nay là `2026-09-19`, người dùng chụp ảnh scan hoặc nhập thủ công một món ăn vào nhật ký.
- **Then**: Hệ thống cập nhật `currentStreak = 4`, `lastActiveDate = "2026-09-19"`.
- **And**: Vòng năng lượng Cosmic Energy Ring hiển thị hiệu ứng ánh sáng chúc mừng chuỗi 4 ngày.

### Kịch Bản 2: Bảo vệ chuỗi ngày bằng Khiên Tinh Tú (Starlight Shield)
- **Given**: Người dùng có chuỗi `currentStreak = 6`, ngày log gần nhất là `2026-09-17`, số khiên `starlightShields = 1`.
- **When**: Ngày `2026-09-18` người dùng không vào app, đến ngày `2026-09-19` người dùng mở app và log bữa trưa.
- **Then**: Hệ thống tiêu hao 1 khiên (`starlightShields = 0`), duy trì chuỗi `currentStreak = 7` (tính bù ngày 18 và cộng ngày 19).
- **And**: Hiển thị popup Celestial: *"Khiên Tinh Tú đã kích hoạt! Chuỗi 7 ngày của bạn được bảo toàn trọn vẹn"*.
- **And**: Tặng huy hiệu `pulsar_pioneer` vì vừa cán mốc 7 ngày.

### Kịch Bản 3: Đứt chuỗi khi không còn khiên bảo vệ
- **Given**: Người dùng có chuỗi `currentStreak = 5`, ngày log gần nhất là `2026-09-16`, số khiên `starlightShields = 0`.
- **When**: Ngày `2026-09-19` (bỏ lỡ 2 ngày liên tiếp) người dùng log món ăn mới.
- **Then**: Hệ thống ghi nhận kỷ lục `longestStreak = 5`, đặt lại chuỗi hiện tại `currentStreak = 1`.
- **And**: Hiển thị thông điệp khích lệ dịu dàng: *"Không sao cả! Tiểu vũ trụ luôn sẵn sàng khởi động lại bất kỳ lúc nào."*

---

## 5. Từ Điển Dữ Liệu Thực Thể (Data Dictionary)

```json
{
  "streakId": "string (userId)",
  "currentStreak": "int (>= 0)",
  "longestStreak": "int (>= 0)",
  "lastActiveDate": "string (yyyy-MM-dd)",
  "starlightShields": "int (0..2)",
  "activeDates": ["string (yyyy-MM-dd)"],
  "unlockedBadges": [
    {
      "badgeId": "string",
      "unlockedAt": "timestamp (ISO-8601)",
      "title": "string"
    }
  ],
  "updatedAt": "timestamp (ISO-8601)"
}
```

---

## 6. Phê Duyệt Cổng 1 (Gate 1 Sign-Off)

- **Soạn thảo**: Sub-Agent Business Analyst (BA) — **HOÀN TẤT & ĐẦY ĐỦ TIÊU CHÍ**
- **Trình nộp**: Sub-Agent Product Owner (PO) để thẩm định và phê duyệt trước khi chuyển sang Gate 2 (UI/UX).
