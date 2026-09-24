# Kế Hoạch & Kịch Bản Kiểm Thử Toàn Diện Gate 3 (Master Test Plan)
## FEAT-14: Zero-Friction Ergonomic Food Logging (Scanner & Manual Entry)

- **Mã tính năng**: `FEAT-14`
- **Mã Epic**: `EPIC-16`
- **Bộ phận phụ trách**: Sub-Agent QA / QC Tester — *"The Paranoid Inquisitor"*
- **Trạng thái**: 🟢 **Approved Gate 3 — Sẵn sàng cho Dev FE (Gate 4)**
- **Ngày lập**: 2026-09-24

---

## 🎯 1. Chiến Lược & Ma Trận Kiểm Thử Phản Biện (Adversarial Test Matrix)

QC tiếp cận tính năng này với tôn chỉ: **"Không tin vào bất kỳ lời hứa nào của Dev, kiểm tra tận cùng các góc biên và phá hoại."**

### 1.1. Ma Trận Kỹ Thuật (ISTQB Techniques)
1. **Phân tích giá trị biên (Boundary Value Analysis - BVA)**:
   - Trọng lượng gram: Min 50g, Max 1000g.
   - Thử nghiệm: Bấm `-50g` khi đang ở 50g -> Không được giảm xuống 0g hoặc số âm.
   - Bấm `+50g` khi đang ở 1000g -> Không được vượt quá 1000g.
2. **Kiểm thử chuyển trạng thái & Concurrency**:
   - Spam click nút "Lưu vào nhật ký": Không được gửi nhiều request trùng lặp (Debounce/Disabled while saving).
   - Chọn nhanh giữa các món Recent Foods và Search Results: Không bị Race Condition giật state.
3. **Kiểm thử công thái học & Giao diện (Visual & Ergonomics)**:
   - Toàn bộ các nút Quick Steppers và Recent Food Chips phải có kích thước tối thiểu `44 × 44pt`.
   - Nút Sticky CTA ở đáy màn hình phải ghim cố định, không bị che bởi bàn phím ảo hoặc thanh cuộn.
   - Màu Carbs `#1A73E8`, Fat `#FF69B4`, Protein `#FFD700`.

---

## 📝 2. Kịch Bản Kiểm Thử BDD Chi Tiết (Gherkin Scenarios)

```gherkin
Feature: Zero-Friction Ergonomic Food Logging

  Background:
    Given người dùng đã đăng nhập với tài khoản hợp lệ
    And đang mở màn hình "Ghi chép món ăn" (ManualEntryPage)

  @happy_path @critical
  Scenario: 1 Chạm điền món ăn quen thuộc từ khay Recent Foods
    Given khay Recent Foods có món "Phở bò tái" (450 kcal)
    When người dùng chạm vào chip "Phở bò tái"
    Then thẻ dinh dưỡng lập tức cập nhật tên món "Phở bò tái"
    And số Calo hiển thị chính xác tương ứng với 450 kcal
    And 3 thanh Macro hiển thị đúng tỷ lệ Carbs, Protein, Fat
    And thời gian phản hồi chuyển đổi < 100ms

  @bva @steppers
  Scenario: Tăng giảm trọng lượng nhanh bằng nút Steppers
    Given món ăn đang được chọn có trọng lượng là 100g
    When người dùng bấm nút "+50g"
    Then trọng lượng tăng lên 150g
    And thanh Slider tự động nhảy đến vị trí 150g
    And lượng Calo và Macro tự động tính lại theo tỷ lệ 150g
    When người dùng bấm nút "-50g" hai lần
    Then trọng lượng dừng lại ở mức tối thiểu 50g và không giảm tiếp

  @presets
  Scenario: Chọn định mức khẩu phần 1 Bát hoặc 1 Đĩa
    Given người dùng đang chọn món "Cơm trắng"
    When người dùng chạm vào nút preset "1 Bát (~150g)"
    Then trọng lượng lập tức đổi thành 150g
    When người dùng chạm vào nút preset "1 Đĩa (~300g)"
    Then trọng lượng lập tức đổi thành 300g

  @ergonomics @sticky_cta
  Scenario: Lưu món ăn từ Sticky Bottom Action Bar
    Given người dùng đã chọn xong món và khẩu phần
    When người dùng cuộn danh sách kết quả tìm kiếm xuống sâu
    Then thanh Bottom Bar gồm bộ chọn Bữa ăn và nút "Lưu vào nhật ký" vẫn cố định ở đáy
    When người dùng nhấn "Lưu vào nhật ký ăn uống"
    Then hệ thống thực hiện lưu vào FoodLogRepository
    And hiển thị SnackBar xác nhận thành công
    And tự động đóng màn hình trở về trang chủ

  @scanner @radar_wave
  Scenario: Quét ảnh món ăn hiển thị hiệu ứng Radar Pulse và Sticky Review Sheet
    Given người dùng đang ở CameraPage
    When người dùng bấm chụp ảnh đĩa thức ăn
    Then Viewfinder hiển thị hiệu ứng sóng quét Radar ánh xanh Electric Blue
    When Gemini AI trả kết quả món ăn
    Then màn hình ScanReviewPage hiển thị thẻ tóm tắt Compact
    And nút "Xác nhận & Lưu" được ghim cố định ở đáy mà không cần cuộn trang
```

---

## 🚦 3. Tiêu Chí Nghiệm Thu Gate 3
- [x] Kịch bản BDD bao phủ 100% User Stories Gate 1 và Screen Layout Blueprint Gate 2.
- [x] Đầy đủ ca kiểm thử BVA (50g - 1000g), Spam click, và Sticky CTA.
- [x] Chuyển giao hợp lệ sang **Gate 4 (Dev FE — `flutter-core-dev`)** để bắt đầu lập trình.
