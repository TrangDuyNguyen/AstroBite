# User Stories (BDD Given-When-Then) — Sprint 31: Đa Ngôn Ngữ i18n

- **Feature**: `FEAT-S31-I18N-FOUNDATION`
- **Tác giả**: Sub-Agent BA (*The Pedantic Logician*)
- **Duyệt bởi**: Sub-Agent PO & Tech Lead

---

### US-01: Tự Động Nhận Diện Ngôn Ngữ Thiết Bị Khi Khởi Động
**As a** người dùng mới mở ứng dụng lần đầu,  
**I want** ứng dụng tự động hiển thị theo ngôn ngữ của điện thoại,  
**So that** tôi không phải mất công cấu hình thủ công.

- **Scenario 1.1: Thiết bị dùng Tiếng Việt**
  - **Given** người dùng mới cài đặt app và chưa từng chọn ngôn ngữ thủ công
  - **And** ngôn ngữ thiết bị đang là `vi_VN`
  - **When** người dùng mở ứng dụng AstroBite
  - **Then** toàn bộ tiêu đề, nút bấm và nhãn dinh dưỡng hiển thị bằng Tiếng Việt (ví dụ: "Hôm nay", "Bữa sáng", "Calo").

- **Scenario 1.2: Thiết bị dùng Tiếng Anh**
  - **Given** người dùng mới cài đặt app và chưa từng chọn ngôn ngữ thủ công
  - **And** ngôn ngữ thiết bị đang là `en_US`
  - **When** người dùng mở ứng dụng AstroBite
  - **Then** toàn bộ tiêu đề, nút bấm và nhãn dinh dưỡng hiển thị bằng Tiếng Anh (ví dụ: "Today", "Breakfast", "Calories").

- **Scenario 1.3: Thiết bị dùng ngôn ngữ không hỗ trợ (ví dụ Pháp `fr_FR`)**
  - **Given** ngôn ngữ thiết bị đang là `fr_FR`
  - **When** người dùng mở ứng dụng AstroBite
  - **Then** ứng dụng fallback an toàn về Tiếng Việt (hoặc Tiếng Anh) mà không crash hay hiển thị chuỗi rỗng.

---

### US-02: Chuyển Đổi Ngôn Ngữ Thủ Công Trong Màn Hình Cá Nhân
**As a** người dùng AstroBite,  
**I want** có thể chủ động chuyển đổi giữa Tiếng Việt, Tiếng Anh hoặc Theo hệ thống trong màn hình Cá nhân,  
**So that** tôi có thể trải nghiệm ứng dụng bằng ngôn ngữ ưa thích bất kể cài đặt của máy.

- **Scenario 2.1: Chuyển đổi từ Tiếng Việt sang Tiếng Anh**
  - **Given** ứng dụng đang hiển thị Tiếng Việt
  - **When** người dùng vào mục "Cá nhân" -> chọn "Ngôn ngữ" -> chọn "English"
  - **Then** toàn bộ giao diện lập tức chuyển sang Tiếng Anh trong vòng < 100ms mà không bị giật lag
  - **And** lựa chọn "en" được lưu vào bộ nhớ cục bộ.

- **Scenario 2.2: Khởi động lại ứng dụng sau khi đã chọn ngôn ngữ thủ công**
  - **Given** người dùng đã chọn ngôn ngữ "English" thủ công
  - **When** người dùng tắt hoàn toàn ứng dụng (kill app) và mở lại
  - **Then** ứng dụng tiếp tục hiển thị Tiếng Anh thay vì bị reset về mặc định của hệ thống.
