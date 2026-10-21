# 🧪 Bảng Kịch Bản Kiểm Thử Thủ Công Từng Bước (Manual Step-by-Step Test Case)

- **Mã Test Case**: `TC-SCAN-01-VISUAL-FLOW`
- **Tên kịch bản**: Kiểm thử từng bước luồng UI Quét món ăn & Hiển thị thẻ dinh dưỡng đa thiết bị
- **Thuộc tính năng (Feature)**: Quét nhận diện thực phẩm (Food Scanner & Meal Card)
- **Quality Gate**: **Gate 3 (Test Design)**
- **Độ ưu tiên**: 🔴 **P0 (Critical Flow)**
- **Kỹ thuật áp dụng**: State Transition, Boundary Value Analysis (BVA), Multimodal Visual QA
- **Thiết bị kiểm thử**:
  - iPhone 15 Pro (iOS 17, Dynamic Island, màn hình 393x852)
  - Google Pixel 8 (Android 14, Punch-hole Camera, màn hình 412x915)
  - iPhone SE / Màn hình nhỏ (375x667, Text Scaling 1.5x)

---

## 🎯 Điều Kiện Tiên Quyết (Pre-conditions)
1. Ứng dụng đã được cấp quyền truy cập Camera.
2. Thiết bị có kết nối mạng Internet ổn định (hoặc giả lập mạng chập chờn ở bước 5).
3. Tài khoản người dùng đã đăng nhập thành công.

---

## 📋 Chi Tiết Kịch Bản Kiểm Thử Từng Bước (Step-by-Step Matrix)

| Bước | Hành Động Người Dùng (Action) | Dữ Liệu / Ngữ Cảnh (Input / Context) | Kết Quả Nghiệp Vụ Kỳ Vọng (Expected Functional Result) | Điểm Kiểm Định Thị Giác (Visual QA Checkpoint) | Trạng Thái |
|:---:|:---|:---|:---|:---|:---:|
| **1** | Mở tính năng Quét món ăn từ Bottom Nav | Chạm vào tab Camera Scanner ở chính giữa thanh điều hướng | Chuyển mượt sang màn hình Camera Live Preview. Nút chụp nổi bật ở đáy. | • Header & nút Close không bị tai thỏ/Dynamic Island lẹm vào (`SafeArea: top`).<br>• Không bị nút điều hướng đáy che khuất nút chụp. | ⏳ READY |
| **2** | Nhấn nút "Chụp & Phân Tích" | Ảnh chụp đĩa salad ức gà rõ nét | Hệ thống gửi ảnh tới AI và kích hoạt trạng thái phân tích. Thời gian phản hồi <= 2.5s. | • Hiển thị hiệu ứng **Loading Skeleton Shimmer** mờ ảo theo phong cách kính.<br>• Không xảy ra giật khung hình (0 layout shift). | ⏳ READY |
| **3** | Quan sát kết quả phân tích trả về | Dữ liệu mock: Tên món "Salad Ức Gà Sốt Mè Rang", Calo 520, Macro: C:45g, P:35g, F:12g | Hiển thị thẻ `MealCard` đầy đủ thông tin calo và 3 chỉ số Carbs, Protein, Fat. | • **Mã màu chuẩn token**: Carbs `#1CB0F6`, Fat `#FF5C8D`, Protein `#FF9600`.<br>• Bo góc thẻ card chuẩn `20px` (ClayCard), viền clay tương phản cao.<br>• Text phụ đạt độ tương phản WCAG AA >= 4.5:1. | ⏳ READY |
| **4** | **Edge-case**: Bật Large Text Scale 1.5x trên màn hình hẹp 375pt | Vào Settings đổi cỡ chữ hệ thống lên 150% (hoặc giả lập `textScaler: 1.5`) | Tên món ăn và các tag macro tự động bẻ dòng xuống dưới mượt mà. | • 🚫 **CẤM SỌC VÀNG ĐEN**: Tuyệt đối không xuất hiện cảnh báo `RenderFlex overflowed`.<br>• Tên món dài có `...` (TextOverflow.ellipsis) gọn gàng, không bị mất nét chữ. | ⏳ READY |
| **5** | **Negative**: Chụp ảnh trong lúc bật Airplane Mode (Mất mạng) | Bật chế độ máy bay trước khi bấm phân tích | Hệ thống không bị crash (0 Unhandled Exception). Hiển thị thông báo ngoại tuyến ấm áp. | • Màn hình chuyển sang **Offline State**: Có icon minh họa, thông điệp nhắc nhở và nút "Thử Lại" (Retry Action) rõ nét. | ⏳ READY |

---

## 🔍 Tiêu Chuẩn Nghiệm Thu Thị Giác (Visual Exit Criteria)
- [ ] 0 lỗi tràn viền (`0 RenderFlex overflow`).
- [ ] 100% các nút bấm đạt kích thước chạm công thái học tối thiểu `48x48dp`.
- [ ] Đủ bằng chứng ảnh chụp (Screenshots / Flutter Preview frames) cho cả 5 bước trên.
- [ ] Không có chữ bị lẹm hoặc không đọc được trên màn hình nhỏ.
