# User Stories (BDD Given-When-Then) — Sprint 32: Barcode & Nutrition Label OCR

- **Feature**: `FEAT-S32-BARCODE-OCR`
- **Mã Epic**: `EPIC-SCAN-02`
- **Tác giả**: Sub-Agent BA (*The Pedantic Logician*)
- **Duyệt bởi**: Sub-Agent PO & Tech Lead

---

### US-01: Chuyển Đổi Chế Độ Quét Trên Giao Diện Camera (Mode Pill Switcher)
**As a** người dùng muốn ghi nhận đồ ăn đóng gói,  
**I want** có nút chuyển đổi rõ ràng giữa chế độ quét "Món ăn" và "Đóng gói / Mã vạch" ngay trên màn hình Camera,  
**So that** tôi định hướng ống kính quét đúng mục tiêu mà không bị bỡ ngỡ.

- **Scenario 1.1: Chuyển sang chế độ Đóng gói / Mã vạch**
  - **Given** người dùng đang ở màn hình Camera (mặc định là chế độ "Món ăn")
  - **When** người dùng chạm vào tab/pill "Đóng gói" trên thanh điều khiển
  - **Then** khung ngắm lập tức chuyển sang tỷ lệ Smart Bounding Box chữ nhật bo tròn trong < 50ms
  - **And** dòng chữ hướng dẫn hiển thị: *"Căn chỉnh bảng dinh dưỡng hoặc mã vạch vào khung"*.

- **Scenario 1.2: Chuyển ngược lại chế độ Món ăn**
  - **Given** người dùng đang ở chế độ "Đóng gói"
  - **When** người dùng chạm vào tab "Món ăn"
  - **Then** khung ngắm chuyển về tỷ lệ tròn/vuông truyền thống của đĩa thức ăn.

---

### US-02: Nhận Diện Bảng Thành Phần Dinh Dưỡng (Nutrition Facts OCR)
**As a** người dùng cầm một hộp sữa chua hoặc gói snack có bảng Nutrition Facts,  
**I want** chụp ảnh bảng số liệu dinh dưỡng và ứng dụng tự động bóc tách Calo, Carbs, Protein, Fat và Khẩu phần ăn,  
**So that** tôi không phải gõ tay từng con số vào nhật ký.

- **Scenario 2.1: Chụp ảnh bảng dinh dưỡng rõ nét**
  - **Given** camera đang ở chế độ "Đóng gói"
  - **And** bảng Nutrition Facts của hộp sữa nằm trọn trong khung ngắm
  - **When** người dùng bấm nút chụp ảnh
  - **Then** màn hình hiển thị Shimmer Scanner với hiệu ứng quét sóng
  - **And** trong vòng < 1.8 giây, hệ thống chuyển sang `ScanReviewPage`
  - **And** các trường Calo, Protein, Carbs, Fat được điền chính xác theo khẩu phần ghi trên nhãn (ví dụ: Calo 120 kcal, Protein 4g, Fat 3g, Carbs 18g).

- **Scenario 2.2: Bảng dinh dưỡng bị mờ hoặc thiếu sáng**
  - **Given** ảnh chụp bị nhòe hoặc quá tối khiến AI không thể trích xuất số liệu
  - **When** quá trình xử lý hoàn tất
  - **Then** hệ thống hiển thị thông báo thân thiện: *"Không nhận diện rõ bảng dinh dưỡng. Vui lòng chụp lại với đủ ánh sáng"* và cho phép người dùng thử lại hoặc nhập tay.

---

### US-03: Quét & Tra Cứu Sản Phẩm Qua Mã Vạch (Barcode Lookup)
**As a** người dùng quét mã vạch sản phẩm quen thuộc (EAN-13),  
**I want** ứng dụng nhận diện mã số và tự động tra cứu tên sản phẩm cùng thông tin dinh dưỡng từ cơ sở dữ liệu thực phẩm,  
**So that** tôi có ngay kết quả chính xác 100% trong nháy mắt.

- **Scenario 3.1: Quét mã vạch có sẵn trong cơ sở dữ liệu**
  - **Given** người dùng chụp ảnh mặt có mã vạch của sản phẩm (ví dụ: nước tăng lực hoặc sữa tươi)
  - **When** Vision AI nhận diện được chuỗi mã vạch `893...`
  - **Then** hệ thống tra cứu cơ sở dữ liệu Open Food Facts / Local cache
  - **And** nạp tên sản phẩm chuẩn và giá trị dinh dưỡng tương ứng vào `ScanReviewPage`.

- **Scenario 3.2: Mã vạch mới chưa có trong cơ sở dữ liệu**
  - **Given** mã vạch hợp lệ nhưng chưa tồn tại trong cơ sở dữ liệu
  - **When** kết quả tra cứu mã trả về rỗng
  - **Then** hệ thống fallback sang phân tích văn bản in trên nhãn sản phẩm bằng Gemini Vision AI mà không báo lỗi sập ứng dụng.
