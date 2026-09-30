# 📄 PRD: First Impression & Identity — Auth, Onboarding & Profile UI Overhaul (`FEAT-S15-FTUX`)

- **Feature Code**: `FEAT-S15-FTUX`
- **Epic**: `EPIC-UI-REFRESH` (Solar Fresh × Duolingo 2D/3D Claymorphic)
- **Sprint**: Sprint 15 (`v2.5.2`)
- **Author**: Sub-Agent Business Analyst (`business-analyst`) — *"The Pedantic Logician"*
- **Reviewer**: Sub-Agent Product Owner (`product-owner`) & Sub-Agent Tech Lead (`tech-lead`)
- **Status**: 🟡 **Gate 1 SUBMITTED FOR PO SIGN-OFF**
- **Target Screens**:
  1. `AuthPage` / `LoginPage`: Đăng nhập & Đăng ký
  2. `OnboardingFlow`: Thiết lập BMR/TDEE và `GoalSummaryPage`
  3. `ProfilePage` & `HealthConnectionPage`: Quản lý hồ sơ cá nhân và kết nối HealthKit/HealthConnect

---

## 1. Bối Cảnh Nghiệp Vụ & Chỉ Số Đo Lường (Context & Measurable KPIs)

### 1.1 Bối Cảnh Nghiệp Vụ
Ấn tượng đầu tiên (First Impression) là yếu tố quyết định tới 60% tỷ lệ giữ chân người dùng mới. Hiện tại, luồng Đăng nhập (Auth), Chào mừng (Onboarding) và Hồ sơ cá nhân (Profile) đang sử dụng thiết kế Material 3 cơ bản, thiếu tính nhất quán với ngôn ngữ thiết kế Celestial Dark UI và Claymorphic (Solar Fresh) mà AstroBite đã định hình ở các phiên bản trước. 

Sprint 15 sẽ tái cấu trúc hoàn toàn các điểm chạm đầu tiên này. Từ các thẻ đăng nhập đến màn hình tổng kết mục tiêu sức khỏe (Goal Summary) đều sẽ được nâng cấp giao diện nổi 3D, mang đến trải nghiệm trực quan, thân thiện như trò chơi (Gamified FTUX), giúp người dùng không cảm thấy nhàm chán khi nhập các chỉ số cá nhân.

### 1.2 Mục Tiêu Đo Lường Cụ Thể (Measurable SLAs & Success Metrics)

| Chỉ Số Đo Lường | Hiện Tại (Baseline) | Mục Tiêu Sprint 15 | Phương Pháp Đo Lường |
|:---|:---:|:---:|:---|
| **Tỷ lệ hoàn thành Onboarding** | 65% | **≥ 85%** | Tỷ lệ user đi từ màn hình 1 đến màn hình cuối của luồng thiết lập. |
| **Thời gian thiết lập hồ sơ (Time-to-Setup)** | 85 giây | **< 45 giây** | Thời gian trung bình hoàn tất form Onboarding. |
| **Tỷ lệ kết nối Health thành công** | 70% | **≥ 90%** | Tỷ lệ bật HealthConnect/HealthKit thành công không gặp lỗi UI. |
| **Vùng chạm công thái học (Touch Target)** | 40x40pt | **≥ 44x44pt** | Các trường nhập liệu, nút bấm chọn giới tính/mục tiêu. |
| **Rò rỉ bộ nhớ (Memory Leak)** | An toàn | **0 Memory Leak** | Khảo sát qua các trang tĩnh và form nhập liệu. |

---

## 2. Phạm Vi Thực Thi (In-Scope & Out-of-Scope)

### ✅ In-Scope (Bắt Buộc Thực Hiện)
1. **Luồng Đăng Nhập & Đăng Ký (`AuthPage`)**:
   - Giao diện `ClayCard` nền Warm Milk `#FAF8F5`.
   - Nút đăng nhập Google / Apple và Email dạng Duolingo 3D (Tactile squash).
   - Form nhập Email/Mật khẩu dùng `ClayTextField` viền nổi bo góc $20\text{pt}$.
2. **Luồng Khảo Sát BMR & Onboarding (`OnboardingFlow`)**:
   - Sử dụng thẻ vuốt ngang hoặc form cuộn dọc mềm mại. Các option chọn (Giới tính, Mức độ vận động, Mục tiêu giảm/tăng cân) sử dụng `QuickChoiceChips` 3D.
   - Thêm màn hình `GoalSummaryPage` với biểu đồ `CalorieProgressArc` tổng kết số calo tiêu chuẩn mỗi ngày ngay trước khi vào màn hình chính.
3. **Trang Cá Nhân & Tích hợp thiết bị (`ProfilePage` & `HealthConnectionPage`)**:
   - Tái cấu trúc Profile hiển thị chỉ số cơ thể dạng thẻ `ClayCard`.
   - Trang đồng bộ Apple Health / Health Connect thiết kế dạng nút gạt (Toggle) 3D rõ ràng trạng thái Connected/Disconnected.

### ❌ Out-of-Scope (Kiên Quyết Cấm Phạm Vi Phình To)
1. **CẤM** thay đổi logic Firebase Authentication cốt lõi, không thêm phương thức đăng nhập mới (chỉ giữ nguyên Google, Apple, Email).
2. **CẤM** thay đổi công thức toán học tính BMR/TDEE ở tầng core.
3. **CẤM** đụng chạm tới tính năng Subscription (Premium/Thanh toán) trong màn hình Profile.

---

## 3. Đặc Tả 5 Trạng Thái Giao Diện Bắt Buộc

| Màn Hình | 1. Default (Bình Thường) | 2. Loading / Shimmer | 3. Empty (Rỗng) | 4. Error (Lỗi) | 5. Offline (Mất Mạng) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`AuthPage`** | Form nhập tĩnh, rõ nét, các nút 3D nổi bật. | Nút xoay Loading khi đang gọi Firebase Auth. | Các trường nhập bị bỏ trống chặn nút Đăng nhập (vô hiệu hóa nút). | Thông báo Toast viền đỏ báo sai pass hoặc email. | Thông báo lỗi không có mạng, chặn gửi request. |
| **`Onboarding`** | Các thẻ câu hỏi hiển thị rõ, lựa chọn sẵn sàng bấm. | (Rất nhanh, ít khi thấy) Loading khi lưu profile vào Firestore. | Không được phép bỏ qua câu hỏi bắt buộc (Giới tính, Tuổi...). | Báo lỗi nếu nhập sai định dạng tuổi/chiều cao. | Cho phép lưu đệm Local, hiển thị thông báo offline. |
| **`Profile`** | Hiển thị đầy đủ Avatar, Tên, và Danh sách thẻ thông tin. | Skeleton loading nếu đang kéo dữ liệu Profile chậm. | Rỗng khi chưa cập nhật một số thông tin phụ (chiều cao, cân nặng mục tiêu). | Báo lỗi kết nối HealthKit (nếu từ chối quyền). | Hiển thị dữ liệu Cache, nút gạt Health bị vô hiệu hóa. |

---

## 4. Kế Hoạch Bàn Giao & Thẩm Định (Gate Handoff)

1. Tài liệu này được gửi trực tiếp đến **PO** để thẩm định mức độ ưu tiên (MoSCoW) theo KPI (D30 Retention).
2. Khi PO ký duyệt, tài liệu sẽ kích hoạt **Gate 2 (UI/UX Design)** để đổ khuôn giao diện lưới 4pt và trạng thái Claymorphic.
