# PRD: Tiện Ích Màn Hình Khóa & Màn Hình Chính (Mobile Widgets & Quick Glance)

- **Mã tính năng**: `FEAT-12`
- **Mã Epic liên kết**: `EPIC-11` (Mobile Widgets & Quick Glance)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA) — *"The Pedantic Logician"*
- **Trạng thái**: 🟡 **In Review (Chờ PO Phê Duyệt Gate 1)**
- **Mục tiêu phiên bản**: `v1.4.0` (Sprint 05)
- **Tham chiếu kiến trúc**: `docs/04-specifications/adr-05-gamification-and-widgets.md` (Gate 0)
- **Đối chiếu UI/UX**: `docs/03-prd-features/12-mobile-widgets/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `tests/03-bdd-gherkin-scenarios/mobile_widgets.feature` (Gate 3)
- **Đối chiếu FE**: `lib/features/widgets/` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
- Người dùng ăn uống 3-4 lần mỗi ngày. Để kiểm tra *"Còn bao nhiêu calo để ăn bữa tối?"*, họ phải rút điện thoại, mở khóa, tìm icon AstroBite, chờ app khởi động rồi mới xem được con số. Ma sát này khiến người dùng lười kiểm tra trước khi gọi món.
- Khi người dùng ngồi vào bàn ăn, việc tìm nút chụp ảnh mất từ 6-10s. Nếu có một nút tắt ngay trên màn hình khóa hoặc màn hình chính để mở thẳng camera AI Scan, thời gian log món ăn sẽ giảm xuống **< 2s**.

### 1.2. Mục Tiêu Nghiệp Vụ & Chỉ Số Đo Lường (KPIs & Metrics)
- **Tần suất liếc nhìn (Glance Frequency)**: Trung bình mỗi người dùng kích hoạt/xem tiện ích Widget ≥ **4 lần/ngày**.
- **Tốc độ mở máy ảnh quét món (Launch to Scan)**: Giảm từ **8.5s xuống < 2s** thông qua Deep Link `astrobite://scanner`.
- **Tăng tỷ lệ log bữa ăn đầy đủ**: Tăng **25%** số bữa ăn được ghi nhận trong ngày đối với người dùng cài đặt widget.
- **Thời gian đồng bộ dữ liệu (Sync Latency)**: Widget phản ánh số liệu mới trong vòng **< 200ms** sau khi người dùng lưu bữa ăn.

---

## 2. Đối Tượng Người Dùng (Target Personas)

1. **Người Bận Rộn Không Thích Mở App (Glance-and-Go Users)**: Chỉ cần liếc màn hình khóa để biết còn ăn được 650 kcal hay không trước khi chọn món trong menu nhà hàng.
2. **Người Ưa Tiện Lợi (Quick-Action Advocates)**: Muốn bấm thẳng vào Widget để camera AI bật lên ngay lập tức, chụp đĩa cơm và cất điện thoại.

---

## 3. Quy Tắc Nghiệp Vụ & Cấu Trúc Dữ Liệu Đồng Bộ (Business Rules & Schema)

### 3.1. Các Kích Thước Widget Hỗ Trợ
1. **Small Widget (2x2)**:
   - Hiển thị Calo còn lại (Remaining Calories) cỡ lớn.
   - Vòng tròn tiến độ thu nhỏ (Mini Celestial Arc).
   - Số ngày chuỗi Streak hiện tại `🔥 5`.
2. **Medium Widget (4x2)**:
   - Bao gồm toàn bộ thông tin của Small Widget.
   - Bổ sung 3 thanh tiến độ chất đa lượng Carbs (Xanh `#1A73E8`), Fat (Hồng `#FF69B4`), Protein (Vàng `#FFD700`).
   - Nút Quick Action: **[📷 Quét Món]** (Deep Link mở trực tiếp `FoodScannerPage`).
3. **LockScreen Circular Widget (iOS 16+ & Android Lockscreen)**:
   - Tiến độ % calo dạng vòng đo và con số calo còn lại.

### 3.2. Cấu Trúc Key-Value Chia Sẻ (Shared Data Contract)

```json
{
  "remaining_calories": 650,
  "consumed_calories": 1550,
  "target_calories": 2200,
  "carbs_grams": 180,
  "fat_grams": 45,
  "protein_grams": 110,
  "current_streak": 5,
  "has_shield": true,
  "last_updated": "2026-09-19T14:45:00Z"
}
```

---

## 4. Kịch Bản Kiểm Thử Chấp Nhận BDD (Given-When-Then)

### Kịch Bản 1: Cập nhật Widget tức thì khi thêm món ăn
- **Given**: Tiện ích Medium Widget đang hiển thị "Còn lại 1200 kcal".
- **When**: Người dùng vào app và ghi log bữa trưa 500 kcal.
- **Then**: Hệ thống ghi dữ liệu mới xuống Key-Value Store nền tảng.
- **And**: Widget cập nhật thành "Còn lại 700 kcal" trong thời gian < 200ms.

### Kịch Bản 2: Deep Link mở trực tiếp máy ảnh AI Scan
- **Given**: Người dùng đang ở màn hình chính của điện thoại ngoài ứng dụng.
- **When**: Người dùng chạm vào nút [📷 Quét Món] trên AstroBite Widget.
- **Then**: Ứng dụng khởi động và chuyển hướng thẳng vào `FoodScannerRoute`.
- **And**: Camera sẵn sàng chụp với độ trễ < 400ms.

---

## 5. Phê Duyệt Cổng 1 (Gate 1 Sign-Off)

- **Soạn thảo**: Sub-Agent Business Analyst (BA) — **HOÀN TẤT & ĐẦY ĐỦ TIÊU CHÍ**
- **Trình nộp**: Sub-Agent Product Owner (PO) phê duyệt.
