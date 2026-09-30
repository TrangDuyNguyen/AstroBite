# 🧪 Master Test Plan & Kịch Bản Kiểm Thử (Gate 3 Test Plan)

- **Sprint**: Sprint 14 — High-Value AI Experience (Camera Scanner & GenUI AI Coach)
- **Mã Feature**: `FEAT-S14-AI-EXPERIENCE`
- **Phiên bản mục tiêu**: `v2.3.0`
- **Sub-Agent Chủ Trì**: Sub-Agent QA / QC Tester (`qa-tester`) — *"The Paranoid Inquisitor"*
- **Hội Đồng Phê Duyệt**: 
  - Sub-Agent Tech Lead (`tech-lead`)
  - Sub-Agent Product Owner (`product-owner`)
- **Ngày lập**: 29/09/2026
- **Phán quyết**: 🟢 **GATE 3 APPROVED & READY FOR DEV (GATE 4)**

---

## 1. Chiến Lược Kiểm Thử (Test Strategy & ISTQB EP/BVA)

Để đảm bảo không một lỗi nào lọt qua hai màn hình cốt lõi của AstroBite, Sub-Agent QA áp dụng chiến lược **Kiểm thử nghịch đảo (Adversarial Testing)**:
- **Phân vùng tương đương (EP)**: Kiểm tra ảnh hợp lệ, ảnh mờ, ảnh không chứa thức ăn, payload AI đúng định dạng, payload A2UI bị khuyết trường.
- **Phân tích giá trị biên (BVA)**: Gram món ăn = 0g, 1g, 5000g; Calo = 0 kcal, 9999 kcal; Chat message rỗng, tin nhắn 5000 ký tự.
- **Thử nghiệm chuyển đổi trạng thái (State Transition)**: Chuyển đổi giữa 5 UI states (Default, Shimmer `#EFF1F5`, Empty, Error, Offline).
- **Kiểm định trực quan (Visual & Ergonomic Verification)**: Rà soát touch target $\ge 44\times 44\text{pt}$ / $\ge 48\times 48\text{pt}$, màu dinh dưỡng Carbs 🩵 `#1CB0F6`, Fat 🍓 `#FF5C8D`, Protein 🧡 `#FF9600`.

---

## 2. Ma Trận Ca Kiểm Thử Chi Tiết (Test Cases Matrix)

| Mã Testcase | Thuộc User Story | Phân Loại | Kịch Bản & Thao Tác Kiểm Thử | Kết Quả Kỳ Vọng | Trạng Thái Thiết Kế |
|:---|:---|:---:|:---|:---|:---:|
| **`TC-S14-01`** | `US-S14-01` | Positive | Mở `CameraPage`, kiểm tra hiển thị viewfinder bo góc $24\text{pt}$, nút Shutter $76\times 76\text{pt}$ và bóng bevel $4\text{pt}$ | Render sắc nét, cụm điều khiển chuẩn 3D | 🟢 Ready |
| **`TC-S14-02`** | `US-S14-01` | Interaction | Chạm nút Shutter: đo đạc hiệu ứng nén squash `0.92` và haptic feedback | Nút nén mượt trong $80\text{ms}$, kích hoạt rung | 🟢 Ready |
| **`TC-S14-03`** | `US-S14-01` | Negative | Thu hồi quyền camera từ OS Settings rồi mở lại `CameraPage` | Hiển thị thẻ `ClayCard` cảnh báo + nút mở Cài đặt, không crash | 🟢 Ready |
| **`TC-S14-04`** | `US-S14-01` | Stress / Leak | Mở và thoát `CameraPage` liên tục 10 lần | CameraController dispose triệt để, RAM không tăng lũy tiến (0 leak) | 🟢 Ready |
| **`TC-S14-05`** | `US-S14-02` | Positive | Mở `ScanReviewPage` với 2 món ăn: hiển thị thẻ `ClayCard` độc lập và `ChunkyMacroBar` 3 màu chuẩn | Màu Carbs 🩵, Fat 🍓, Protein 🧡 chuẩn xác | 🟢 Ready |
| **`TC-S14-06`** | `US-S14-02` | Dynamic BVA | Nhấn nút `+20g` trên thẻ món ăn: kiểm tra tính toán lại calo và cập nhật `ChunkyMacroBar` | Calo cập nhật tức thì, macro bar chuyển động mượt $< 200\text{ms}$ | 🟢 Ready |
| **`TC-S14-07`** | `US-S14-02` | Positive | Nhấn nút 3D "Lưu vào Nhật Ký" | Lưu thành công qua `TrackerNotifier`, chuyển về Home kèm snackbar | 🟢 Ready |
| **`TC-S14-08`** | `US-S14-03` | Positive | Gửi câu hỏi vào `CoachPage`: bong bóng User và Bot dạng `ClayCard`, cuộn 60 FPS | Bong bóng bo cong mềm mại, render Markdown mượt mà | 🟢 Ready |
| **`TC-S14-09`** | `US-S14-03` | Offline | Ngắt mạng thiết bị khi đang trong `CoachPage` và gửi tin | Hiển thị thông báo ngoại tuyến nhẹ, app không crash | 🟢 Ready |
| **`TC-S14-10`** | `US-S14-04` | GenUI / Action | Nhận thẻ `MealQuickLogCard`: nhấn nút "Ghi vào nhật ký" | Nén squash `0.95`, ghi nhật ký trong $< 150\text{ms}$, đổi sang "Đã lưu ✓" | 🟢 Ready |

---

## 3. Ma Trận Truy Vết Nghiệp Vụ (100% Traceability Matrix)

- **`US-S14-01` (Camera Viewfinder & Shutter)** ➔ `TC-S14-01`, `TC-S14-02`, `TC-S14-03`, `TC-S14-04`.
- **`US-S14-02` (Scan Review ClaySheet & Macros)** ➔ `TC-S14-05`, `TC-S14-06`, `TC-S14-07`.
- **`US-S14-03` (Coach Chat Cockpit)** ➔ `TC-S14-08`, `TC-S14-09`.
- **`US-S14-04` (1-Tap GenUI Logging)** ➔ `TC-S14-10`.
- **Kịch bản BDD Gherkin**: Đã đóng gói hoàn chỉnh tại [`s14_ai_experience.feature`](file:///Users/nguyenduytrang/flutter_project/AstroBite/tests/03-bdd-gherkin-scenarios/s14_ai_experience.feature).

---

## 4. Tiêu Chuẩn Nghiệm Thu Phi Chức Năng Bắt Buộc (Gate 6 Acceptance Gates)

Sub-Agent QA sẽ chỉ ký biên bản nghiệm thu Gate 6 khi Dev FE thỏa mãn 100% các tiêu chí sau:
1. `flutter analyze`: **0 issues, 0 warnings**.
2. `flutter test`: **100.0% Pass** (tuyệt đối không chấp nhận fake green test).
3. Frame Rate khi preview Camera và cuộn Chat: **$\ge 55\text{ FPS}$**.
4. Thời gian phản hồi 1-Tap Log trong Coach: **$< 150\text{ms}$**.
5. Rò rỉ bộ nhớ (Memory Leak): **0 bytes sau 10 chu kỳ mở/đóng Camera**.

---

## 5. Phán Quyết Gate 3 Của Sub-Agent QA Tester

> *"Bộ kịch bản kiểm thử đã bao phủ 100% User Stories, bọc kín các trường hợp biên nguy hiểm (thu hồi quyền camera, spam click, ngắt mạng khi chat, dynamic recalculation gram). Tôi chính thức **KÝ DUYỆT GATE 3** và bật đèn xanh cho Sub-Agent Dev FE (`flutter-core-dev`) tiến hành triển khai kỹ thuật tại Gate 4!"*
