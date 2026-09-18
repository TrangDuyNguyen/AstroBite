# PRD: Nhập Món Ăn Thủ Công (Manual Food Entry)

- **Mã tính năng**: `FEAT-03-MANUAL`
- **Tên tính năng**: Nhập Món Ăn Thủ Công (Manual Food Entry)
- **Thuộc module**: Nhật Ký Dinh Dưỡng & Theo Dõi Calo (`FEAT-03`)
- **Bộ phận phụ trách**: BA Team
- **Trạng thái**: Approved
- **Đối chiếu QA**: `tests/02-manual-testcases/03-diary-calorie-tracker/TC-manual-food-entry.md` & `tests/03-bdd-gherkin-scenarios/manual_food_entry.feature`
- **Đối chiếu FE**: `lib/features/tracker/presentation/pages/manual_entry_page.dart`

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ

### 1.1 Vấn Đề Cần Giải Quyết
- Mặc dù tính năng Quét thức ăn AI (`FEAT-02`) mang lại sự tiện lợi cao, người dùng vẫn gặp các tình huống không thể hoặc không tiện chụp ảnh (môi trường thiếu sáng, ăn tại nơi công cộng cần kín đáo, món ăn tự nấu tại nhà theo định lượng riêng, hoặc camera/kết nối mạng không khả dụng).
- Người dùng cần một phương thức ghi chép nhật ký nhanh, trực quan, cho phép tra cứu các món ăn Việt Nam phổ biến và tự do định nghĩa món ăn tùy chỉnh.

### 1.2 Mục Tiêu Đo Lường Được (KPIs/Metrics)
- Tỷ lệ hoàn thành ghi nhận món ăn thủ công đạt >= 95% mà không gặp lỗi.
- Thời gian trung bình để người dùng tìm kiếm và lưu một món ăn có sẵn vào nhật ký: < 10 giây.
- 100% bản ghi lưu trữ vào Firestore có trường `source: "manual_entry"` và tính toán đúng số calo/macro.

---

## 2. Đối Tượng Người Dùng (Target Personas)
- **Người ăn kiêng tính calo chính xác (Calorie/Macro Tracker)**: Cần điều chỉnh chính xác số gram ăn vào để đảm bảo thâm hụt calo (Deficit) hoặc nạp đủ đạm (Protein target).
- **Người dùng văn phòng bận rộn**: Thường xuyên ăn các món ăn hàng ngày quen thuộc (Cơm tấm, Phở, Bún chả, Bánh mì...) và muốn ghi nhanh trong 2 cú chạm.
- **Người tập gym/thể hình (Fitness Enthusiast)**: Tự nấu ăn theo công thức riêng, cần nhập trực tiếp thành phần dinh dưỡng tùy chỉnh.

---

## 3. Luồng Nghiệp Vụ (User Journey & Flow)

```mermaid
flowchart TD
    Start([Điểm Vào: Tab Nhập Tay / Nút + Bữa Ăn / Fallback Camera]) --> SelectMeal[1. Chọn Bữa Ăn: Sáng, Trưa, Tối, Phụ]
    SelectMeal --> ChooseMode{2. Người Dùng Chọn Hành Động}
    
    ChooseMode -->|Tìm món có sẵn| Search[3A. Nhập tên món vào ô tìm kiếm]
    Search --> FilterList[Danh sách lọc hiển thị realtime]
    FilterList --> PickFood[Chọn 1 món từ danh sách]
    PickFood --> AdjustPortion[Chỉnh thanh kéo khối lượng 50g - 1000g]
    AdjustPortion --> AutoCalc[Hệ thống tự động tính lại Calo & Macros]
    
    ChooseMode -->|Món không có sẵn| CustomBtn[3B. Nhấn 'Thêm món tùy chỉnh']
    CustomBtn --> CustomForm[Nhập Form: Tên món, Gram, Calo, Protein, Carbs, Fat]
    CustomForm --> Validate[Kiểm tra tính hợp lệ dữ liệu]
    
    AutoCalc --> SaveLog[4. Nhấn 'Lưu vào Nhật ký']
    Validate -->|Hợp lệ| SaveLog
    
    SaveLog --> Firestore[Lưu vào users/{uid}/foodLogs source: 'manual_entry']
    Firestore --> SyncDashboard[Cập nhật tức thì Calo còn lại & 4 Bữa ăn trên HomePage]
    SyncDashboard --> End([Thông báo thành công & Quay về Dashboard])
```

---

## 4. Danh Sách Yêu Cầu Chức Năng (Functional Requirements)

- **FR-01: Phân loại bữa ăn (Meal Type Pre-selection)**:
  - Hỗ trợ 4 bữa ăn: Bữa Sáng (`breakfast`), Bữa Trưa (`lunch`), Bữa Tối (`dinner`), Bữa Phụ (`snack`).
  - Khi người dùng bấm nút `+` từ thẻ Bữa Tối tại `HomePage`, màn hình Nhập tay tự động chọn sẵn `dinner`.
  - Nếu mở từ tab thanh điều hướng, tự động chọn bữa ăn mặc định theo thời gian thực (5h-11h: Sáng, 11h-16h: Trưa, 16h-21h: Tối, còn lại: Phụ).

- **FR-02: Tra cứu danh mục món ăn phổ biến (Quick Search & Autocomplete)**:
  - Tích hợp danh bạ món ăn Việt Nam nội bộ với đầy đủ thông số năng lượng cơ sở trên 100g (hoặc khẩu phần tiêu chuẩn): Calo, Đạm (Protein), Tinh bột (Carbs), Chất béo (Fat).
  - Thanh tìm kiếm lọc tức thì khi người dùng gõ ký tự, hỗ trợ tìm kiếm tiếng Việt không phân biệt hoa/thường.

- **FR-03: Điều chỉnh khẩu phần gram động (Dynamic Portion Scaling)**:
  - Khi chọn một món ăn, hiển thị thanh trượt (Slider) từ 50g đến 1000g (bước nhảy 5g hoặc 10g).
  - Công thức tính tỷ lệ:
    - $\text{Calo thực tế} = \text{round}(\text{Calo base} \times \frac{\text{Gram thực tế}}{\text{Gram base}})$
    - $\text{Carbs/Protein/Fat thực tế} = \text{round}(\text{Macro base} \times \frac{\text{Gram thực tế}}{\text{Gram base}})$
  - Hiển thị trực quan 3 chỉ số Macro với màu sắc chuẩn Celestial Dark: Carbs 🔵 `#1A73E8`, Protein 🟡 `#FFD700`, Fat 🩷 `#FF69B4`.

- **FR-04: Thêm món tùy chỉnh (Custom Food Entry)**:
  - Cung cấp nút "Tạo món mới" / "Thêm món tùy chỉnh".
  - Mở BottomSheet/Dialog với các trường:
    - Tên món (Bắt buộc, tối thiểu 2 ký tự).
    - Khối lượng (g) (Bắt buộc, > 0, mặc định 100g).
    - Lượng calo (kcal) (Bắt buộc, >= 0).
    - Đạm / Protein (g) (Tùy chọn, mặc định 0).
    - Tinh bột / Carbs (g) (Tùy chọn, mặc định 0).
    - Chất béo / Fat (g) (Tùy chọn, mặc định 0).
  - Xác thực form (Form validation) trước khi cho phép lưu.

- **FR-05: Lưu trữ và đồng bộ hóa tức thì (Real-time Persistence)**:
  - Lưu vào Firestore subcollection `users/{uid}/foodLogs` với `source: "manual_entry"`.
  - Khi lưu thành công: Hiển thị SnackBar thông báo, đồng bộ tức thì đến vòng cung calo và danh sách bữa ăn của ngày đang chọn trên Dashboard.

---

## 5. Yêu Cầu Phi Chức Năng (Non-Functional Requirements)

- **Thời gian phản hồi**: Thời gian tính toán lại macros khi kéo slider < 16ms (đảm bảo 60fps mượt mà).
- **Giao diện & Công thái học (Ergonomics)**:
  - Tuân thủ nghiêm ngặt bảng màu dinh dưỡng Celestial Dark.
  - Vùng bấm tương tác (Touch Target) tối thiểu 44x44pt.
  - Rung phản hồi nhẹ (Haptic Feedback) khi tương tác với slider hoặc lưu món thành công.
- **Tính khả dụng ngoại tuyến (Offline Availability)**: Danh bạ món ăn phổ biến lưu trữ cục bộ trong ứng dụng, có thể tìm kiếm và tính toán mà không cần kết nối Internet.
