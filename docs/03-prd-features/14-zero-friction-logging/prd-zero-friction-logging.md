# PRD: Tối Ưu Hoá Ghi Chép Dinh Dưỡng Công Thái Học & Tốc Độ Cao (Zero-Friction Ergonomic Logging)

- **Mã tính năng**: `FEAT-14`
- **Mã Epic liên kết**: `EPIC-16` (Zero-Friction Ergonomic Food Logging: Scanner & Manual Entry)
- **Bộ phận phụ trách**: Sub-Agent Business Analyst (BA) — *"The Pedantic Logician"*
- **Trạng thái**: 🟡 **Pending PO & Tech Lead Review (Trình Gate 1 Sign-Off)**
- **Mục tiêu phiên bản**: `v1.6.0` (Sprint 07)
- **Tham chiếu thiết kế**: `docs/03-prd-features/14-zero-friction-logging/ui-ux-design-spec.md` (Gate 2)
- **Đối chiếu QA**: `test/features/tracker/presentation/zero_friction_manual_entry_test.dart` (Gate 3 & Gate 6)
- **Đối chiếu FE**: 
  - `lib/features/tracker/presentation/pages/manual_entry_page.dart` (Gate 4)
  - `lib/features/scanner/presentation/pages/camera_page.dart` (Gate 4)
  - `lib/features/scanner/presentation/pages/scan_review_page.dart` (Gate 4)

---

## 1. Bối Cảnh & Mục Tiêu Nghiệp Vụ (Context & Business Objectives)

### 1.1. Vấn Đề Cần Giải Quyết (Problem Statement)
Nhật ký dinh dưỡng là tính năng giữ chân cốt lõi (Retention Hook), nhưng hiện tại người dùng đang gặp phải các rào cản ma sát nghiêm trọng:
1. **Màn hình Nhập tay (`ManualEntryPage`)**:
   - **Vị trí nút vi phạm công thái học**: 4 chip bữa ăn (`Bữa sáng`, `Bữa trưa`, `Bữa tối`, `Bữa phụ`) nằm trên đỉnh màn hình, buộc người dùng phải với ngón tay hoặc dùng cả hai tay.
   - **Thiếu lịch sử ăn uống nhanh**: Người dùng thường ăn lại các món quen thuộc hàng ngày (cơm trắng, trứng chiên, ức gà, phở...), nhưng luôn phải gõ tìm kiếm từ đầu.
   - **Thanh trượt Gram khó căn chỉnh**: Slider từ `50g - 1000g` quá nhạy, người dùng mất nhiều thao tác để kéo trúng con số mong muốn và thiếu các nút gán khẩu phần thông dụng (1 chén cơm, 1 quả trứng, 1 đĩa).
   - **Nút Lưu bị đẩy xuống đáy**: Khi danh sách kết quả tìm kiếm dài, nút Lưu bị trôi hoặc thiếu sự chú ý trong tầm ngón cái.
2. **Màn hình Quét món ăn AI (`CameraPage` & `ScanReviewPage`)**:
   - **Trạng thái chờ phân tích khô khan**: Trong 1.5s - 2.5s Gemini AI nhận diện, màn hình chỉ hiện một thanh `LinearProgressIndicator` cứng nhắc, làm tăng cảm giác chờ đợi sốt ruột.
   - **Màn Review dài hơn 800 dòng code**: Dữ liệu dinh dưỡng, danh sách món, thanh vi chất và nút lưu phân mảnh trên một trang cuộn dài, người dùng phải cuộn qua nhiều khối mới bấm được nút "Lưu vào nhật ký".

### 1.2. Mục Tiêu Lượng Hóa Cụ Thể (KPIs & Metrics)
- **Time-to-Log (Món quen thuộc)**: Giảm từ **12.5 giây xuống < 3.5 giây** thông qua khay 1-Tap Recent Foods và Quick Weight Presets.
- **Thao tác sau Quét AI**: Giảm từ **4 thao tác xuống <= 2 chạm** để lưu món ăn vào nhật ký (Glanceable Sticky Bottom Sheet).
- **Log Completion Rate**: Tăng tỷ lệ hoàn tất ghi nhận nhật ký từ **76% lên >= 92%**.
- **Ergonomic Compliance**: 100% các nút tương tác chính nằm trong **Thumb Zone** (bán kính 120pt từ đáy màn hình) với kích thước chạm chuẩn `>= 44 × 44pt`.
- **Hiệu năng & SLA**: Tốc độ phản hồi UI `< 100ms`, khung hình ổn định `>= 55 FPS`, tuyệt đối `0 RenderFlex overflow`.

---

## 2. Đối Tượng Người Dùng (Target Personas)

1. **Minh - Nhân viên văn phòng bận rộn (Speed-Logger)**:
   - Ăn trưa nhanh tại văn phòng với các món quen thuộc (cơm tấm, bún chả).
   - Mong muốn: Chỉ cần mở app, bấm 1 chạm vào món thường ăn, chọn "1 đĩa" và lưu ngay trong 3 giây.
2. **Lan - Gymer kiểm soát macro gắt gao (Macro-Perfectionist)**:
   - Thường xuyên cân đo thực phẩm theo gram (150g ức gà, 200g cơm).
   - Mong muốn: Các nút bấm tăng/giảm nhanh `+50g`, `-50g` thay vì phải nắn nót kéo slider cảm ứng trượt qua trượt lại.
3. **Tuấn - Người dùng mới thích chụp ảnh AI (Visual AI Seeker)**:
   - Dùng tính năng quét ảnh món ăn mỗi ngày.
   - Mong muốn: Hiệu ứng quét công nghệ đẹp mắt (Celestial Radar), kết quả hiển thị súc tích không phải cuộn trang.

---

## 3. Đặc Tả Yêu Cầu Chức Năng (Functional Requirements)

### 3.1. US-01: Khay Món Ăn Gần Đây & Yêu Thích 1 Chạm (Recent & Favorite Foods Tray)
- **Vị trí**: Nằm ngay dưới thanh tìm kiếm `FoodSearchBar` trên `ManualEntryPage`.
- **Hành vi**:
  - Tự động hiển thị 5–8 món ăn mà người dùng đã lưu gần nhất (lấy từ cache cục bộ `RecentFoodsCache`).
  - Dạng danh sách cuộn ngang (Horizontal Chips), mỗi chip hiển thị: Biểu tượng đĩa ăn 🍽️ + Tên món + Calo cơ bản.
  - Khi người dùng chạm vào một chip: Lập tức chọn món đó, điền tự động vào bảng tính dinh dưỡng và kích hoạt haptic feedback nhẹ (`HapticFeedback.selectionClick()`).

### 3.2. US-02: Bộ Nút Preset Trọng Lượng Nhanh (Quick Weight Stepper Chips)
- **Vị trí**: Nằm song song phía trên hoặc dưới thanh Slider trên cả `ManualEntryPage` và `ScanReviewPage`.
- **Các nút Preset chuẩn**:
  - Nút cộng trừ bước nhảy: `[-50g]` và `[+50g]`.
  - Nút định mức khẩu phần phổ thông: `[1 Bát / Chén ~150g]`, `[1 Đĩa ~300g]`, `[1 Phần tiêu chuẩn ~100g]`.
- **Hành vi**: Khi bấm, giá trị gram được cập nhật tức thì, tự động tính lại tổng Calo, Carbs, Protein, Fat mà không bị giật lag.

### 3.3. US-03: Bố Cục Công Thái Học Nửa Dưới Màn Hình (One-Thumb Action Bar)
- **Vị trí**: Ghim cố định ở chân màn hình (Bottom Fixed Bar), không bị che khuất khi cuộn nội dung.
- **Thành phần**:
  - Hàng chọn bữa ăn dạng Pill Selector thu gọn: `Sáng` • `Trưa` • `Tối` • `Phụ` nằm ngay trên nút Lưu.
  - Nút CTA chính to bản (chiều cao 52pt, bo tròn `radius12`): `"Lưu vào nhật ký ăn uống"` kèm tóm tắt tổng calo hiện tại.
  - Nằm hoàn toàn trong vùng điều khiển của ngón tay cái (Thumb Zone).

### 3.4. US-04: Hiệu Ứng Quét Radar Vũ Trụ (Celestial Radar Viewfinder)
- **Vị trí**: Trên `CameraPage` khi máy ảnh đang hoạt động và lúc đang chờ Gemini AI xử lý.
- **Hành vi**:
  - Khi người dùng bấm chụp, một dải sóng quét bán nguyệt ánh xanh Electric Blue (`#1A73E8`) chạy quét tuần hoàn từ trên xuống dưới khung ngắm.
  - Vòng bo góc viewfinder tỏa sáng xung điện (Pulse Glow Animation), đi kèm thông điệp trạng thái sinh động: *"AI đang giải mã cấu trúc món ăn..."*.
  - Giảm cảm giác chờ đợi của người dùng từ trạng thái thụ động sang trải nghiệm công nghệ vũ trụ.

### 3.5. US-05: Thẻ Review Kết Quả Tinh Gọn (Glanceable Sticky Review Sheet)
- **Vị trí**: Màn hình `ScanReviewPage`.
- **Hành vi**:
  - Gom toàn bộ thông tin quan trọng nhất (Tên món ăn, Ảnh chụp thu nhỏ, Tổng calo, 3 thanh Macro C-P-F) vào một khối Compact Card trực quan trong tầm mắt đầu tiên (Above the fold).
  - Ghim nút CTA `"Xác nhận & Lưu vào Bữa ăn"` cố định ở đáy màn hình. Người dùng có thể lưu ngay chỉ với 1 chạm mà không cần phải cuộn dọc qua các mục vi chất chi tiết.
  - Phần chỉnh sửa thành phần món (Multi-item breakdown) được mở qua Modal Bottom Sheet mượt mà khi người dùng chạm vào nút "Chỉnh sửa món".

---

## 4. Kịch Bản Nghiệm Thu BDD (Given - When - Then)

### Scenario 1: Ghi món ăn quen thuộc 1 chạm từ khay Recent Foods (Happy Path)
- **Given**: Người dùng đã từng lưu món "Phở bò tái" và "Cơm tấm sườn" trong nhật ký các ngày trước.
- **When**: Người dùng mở màn hình `ManualEntryPage`.
- **Then**: Khay "Món gần đây" hiển thị ngay dưới ô tìm kiếm với các chip "Phở bò tái", "Cơm tấm sườn".
- **When**: Người dùng chạm vào chip "Phở bò tái".
- **Then**: Thẻ chi tiết dinh dưỡng lập tức hiển thị thông số Phở bò tái (Carbs, Protein, Fat) với giá trị mặc định, thời gian phản hồi < 100ms.
- **When**: Người dùng chạm nút "Lưu vào nhật ký" ở thanh đáy.
- **Then**: Món ăn được lưu thành công vào Firestore và người dùng được đưa về trang chủ trong thời gian < 3.5 giây tính từ lúc mở màn hình.

### Scenario 2: Căn chỉnh trọng lượng nhanh bằng Stepper Chips
- **Given**: Người dùng đang chọn món "Ức gà luộc" với trọng lượng ban đầu là 100g.
- **When**: Người dùng chạm vào nút `[+50g]`.
- **Then**: Trọng lượng tăng lên 150g, Slider tự nhảy đến mốc 150g, con số Calo và Protein cập nhật tức thì tương ứng với 150g.
- **When**: Người dùng chạm vào nút `[-50g]`.
- **Then**: Trọng lượng giảm về 100g. Nếu chạm tiếp khi đạt 50g (mốc tối thiểu), nút `[-50g]` bị disable hoặc giữ nguyên ở 50g, không cho phép nhập số âm.

### Scenario 3: Quét AI và lưu 1 chạm không cần cuộn trang (Scan Review Flow)
- **Given**: Gemini AI vừa phân tích xong ảnh đĩa cơm sườn và trả về kết quả.
- **When**: Ứng dụng điều hướng sang `ScanReviewPage`.
- **Then**: 
  - Khối tóm tắt hiển thị tên "Cơm tấm sườn", Calo to bản và 3 thanh Macro (Carbs xanh `#1A73E8`, Fat hồng `#FF69B4`, Protein vàng `#FFD700`).
  - Thanh chọn bữa ăn và nút CTA "Lưu vào Bữa trưa" được ghim cố định ở đáy màn hình (Sticky Bottom).
  - Không xuất hiện thanh cuộn dài, người dùng không cần vuốt màn hình.
- **When**: Người dùng bấm nút "Lưu vào Bữa trưa".
- **Then**: Món ăn được lưu vào nhật ký, màn hình đóng lại và cập nhật ngay lập tức vào Today Cockpit.

### Scenario 4: Chế độ Ngoại Tuyến (Offline Resilience)
- **Given**: Thiết bị mất kết nối Internet hoàn toàn (Airplane Mode).
- **When**: Người dùng vào `ManualEntryPage`, chọn món từ Recent Foods và bấm "Lưu".
- **Then**: Hệ thống lưu vào Local Cache ngay tức thì, hiển thị thông báo "Đã lưu ngoại tuyến, sẽ đồng bộ khi có mạng" và không bị treo UI.

---

## 5. Từ Điển Dữ Liệu & Quy Chuẩn Giao Diện (Data Dictionary & Design Tokens)

### 5.1. Dữ Liệu Cục Bộ (Local Storage / Cache)
| Trường / Cấu trúc | Kiểu | Mô tả & Quy tắc |
| :--- | :--- | :--- |
| `recentFoodsList` | `List<CommonFoodItem>` | Danh sách tối đa 10 món ăn gần nhất được lưu trong SharedPreferences / Local Cache, sắp xếp theo thời gian sử dụng giảm dần. |
| `quickWeightPresets` | `List<int>` | Danh sách trọng lượng mẫu: `[50, 100, 150, 200, 300]` gram. |

### 5.2. Bảng Màu Dinh Dưỡng Bất Biến (Celestial Dark Tokens)
- 🔵 **Carbohydrates**: `AppColors.primary` (`#1A73E8`)
- 🩷 **Fat**: `AppColors.secondary` (`#FF69B4`)
- 🟡 **Protein**: `AppColors.tertiary` (`#FFD700`)
- 🌌 **Nền bề mặt chính**: `AppColors.surface` (`#0A192F`)
- 🌌 **Nền card kính mờ**: `AppColors.surfaceContainer` (`#112240`)
- 📏 **Lưới khoảng cách**: Hệ số 4pt (`AppValues.spacing4`, `spacing8`, `spacing12`, `spacing16`, `spacing24`).
- 👆 **Vùng chạm tối thiểu**: `44 × 44pt` cho toàn bộ chip và nút hành động.

---

## 6. Phân Rã Công Việc & Ký Duyệt Gate 1 (Sign-Off Request)

Tài liệu PRD này được chuyển giao cho **Sub-Agent PO** và **Tech Lead** xem xét và ký duyệt theo đúng quy định kiểm soát chéo (Four-Eyes Principle). Sau khi ký duyệt Gate 1, hồ sơ sẽ được bàn giao ngay cho **Sub-Agent UI/UX Designer** để thiết kế chi tiết tại Gate 2.
