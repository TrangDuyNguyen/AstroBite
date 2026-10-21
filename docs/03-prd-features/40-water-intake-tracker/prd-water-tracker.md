# PRD-040: Water Intake & Hydration Tracker (Theo dõi lượng nước uống)

> **Sub-Agent**: Business Analyst (`business-analyst`) — *"The Pedantic Logician"*  
> **Gate**: Gate 1 (PRD & BDD Given-When-Then Specification)  
> **Feature**: `FEAT-S33-WATER-TRACKER` | **Epic**: `EPIC-HYDRATE-01` | **Version**: `v3.5.0`  
> **Status**: ✅ **DUYỆT XONG GATE 1 (PO & Tech Lead Sign-Off)**

---

## 1. Executive Summary & Success Metrics

- **Mục tiêu**: Tối ưu thói quen uống đủ nước mỗi ngày cho người dùng AstroBite bằng widget Claymorphic 60 FPS tích hợp trên Dashboard, hỗ trợ ghi nhận tức thời (1-tap quick log: +250ml, +500ml).
- **North Star Metric**:
  - Tỷ lệ người dùng duy trì streak uống nước $\ge 7$ ngày đạt **$\ge 45\%$**.
  - Thời gian ghi nhận nước (Log latency): **$< 1.5\text{s}$** từ khi mở app đến khi lưu thành công.
  - Tỷ lệ hoàn thành mục tiêu nước hàng ngày (Goal Achievement Rate): **$\ge 60\%$**.

---

## 2. User Stories & BDD Scenarios (Given - When - Then)

### 🧪 US-01: Quick Log Nước từ Home Dashboard (1-Tap)
- **As a** Người dùng AstroBite,
- **I want** Ghi nhận nhanh 250ml hoặc 500ml nước trực tiếp trên thẻ Home Dashboard,
- **So that** Tôi không tốn thời gian mở nhiều màn hình phức tạp.

```gherkin
Scenario: Ghi nhận nhanh 250ml nước thành công
  Given Người dùng đang ở màn hình Home Dashboard
  And Lượng nước hiện tại của ngày là 500ml trên mục tiêu 2000ml (25%)
  When Người dùng nhấn vào nút "+250ml" trên thẻ ClayWaterCard
  Then Lượng nước tăng ngay lập tức lên 750ml (37.5%)
  And Làn sóng nước (wave animation) dâng lên mượt mà 60 FPS
  And Dữ liệu được ghi vào SharedPreferences trong < 10ms
  And Hệ thống tự động đồng bộ lên Firestore ngầm
```

### 🧪 US-02: Đạt Mục Tiêu Nước Hàng Ngày (Goal Celebration)
- **As a** Người dùng đạt 100% mục tiêu nước trong ngày,
- **I want** Nhận được phản hồi thị giác chúc mừng (Micro-interaction),
- **So that** Tôi cảm thấy được khích lệ duy trì thói quen lành mạnh.

```gherkin
Scenario: Uống đủ 2000ml nước trong ngày
  Given Lượng nước hiện tại là 1800ml / 2000ml
  When Người dùng ghi thêm 250ml nước
  Then Tổng lượng nước hiển thị là 2050ml / 2000ml (102%)
  And Thẻ nước chuyển sang hiệu ứng chúc mừng (Goal Achieved badge)
  And Tích lũy điểm kinh nghiệm / streak sức khỏe cho người dùng
```

### 🧪 US-03: Hoạt Động Hoàn Toàn Ngoại Tuyến (Offline-First)
```gherkin
Scenario: Ghi nhận nước khi mất kết nối mạng
  Given Thiết bị đang ở chế độ Máy bay hoặc không có Internet
  When Người dùng nhấn "+500ml" nước
  Then Lượng nước trên UI vẫn cập nhật ngay lập tức không có độ trễ
  And Dữ liệu được lưu an toàn trong Local Cache
  When Thiết bị có kết nối mạng trở lại
  Then Dữ liệu tự động đồng bộ lên Cloud Firestore mà không gây xung đột
```

---

## 3. Data Dictionary

| Trường Dữ Liệu | Kiểu Dữ Liệu | Bắt Buộc | Mô Tả | Ví Dụ |
| :--- | :--- | :---: | :--- | :--- |
| `id` | `String` | Có | Định danh log ngày (yyyyMMdd) | `"20261021"` |
| `userId` | `String` | Có | UID của người dùng Firebase | `"usr_astro_982"` |
| `date` | `String` | Có | Ngày ghi nhận ISO (YYYY-MM-DD) | `"2026-10-21"` |
| `currentMl` | `int` | Có | Tổng lượng nước đã uống trong ngày (ml) | `1250` |
| `targetMl` | `int` | Có | Mục tiêu nước của ngày (ml) | `2000` |
| `entries` | `List<WaterEntry>` | Có | Danh sách các lần uống chi tiết | `[{timestamp, amountMl}]` |
| `updatedAt` | `DateTime` | Có | Thời điểm cập nhật cuối cùng | ISO timestamp |

---

## 4. Gate 1 Sign-Off Board

- [x] **Sub-Agent BA (`business-analyst`)**: Bàn giao đầy đủ User Stories BDD & Data Dictionary.
- [x] **Sub-Agent PO (`product-owner`)**: Ký duyệt mục tiêu kinh doanh & SLA.
- [x] **Sub-Agent Tech Lead (`tech-lead`)**: Đồng ký duyệt tính khả thi kỹ thuật (Feasibility).
