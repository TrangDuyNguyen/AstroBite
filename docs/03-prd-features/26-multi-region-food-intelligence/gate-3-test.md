# Gate 3: Master Test Plan — Sprint 19 Multi-Region Food Culture Intelligence

- **Người thực hiện**: Sub-Agent QA Tester (*The Paranoid Inquisitor*)
- **Chuẩn kiểm thử**: ISTQB EP (Equivalence Partitioning) & BVA (Boundary Value Analysis) + BDD Gherkin
- **Feature Code**: `FEAT-S19-GLOBAL-CUISINE` / `EPIC-GLOBAL`
- **Phiên bản mục tiêu**: `v2.9.0`
- **Trạng thái**: 🟢 Gate 3 Test Design Approved (Ready for Gate 4 Dev)

---

## 1. Ma Trận Kịch Bản Kiểm Thử Chức Năng (Functional Test Cases — EP/BVA)

| TC ID | Kịch Bản Kiểm Thử | Phân Vùng Tương Đương / Biên | Kết Quả Kỳ Vọng | Trọng Yếu |
| :--- | :--- | :--- | :--- | :---: |
| `TC-S19-01` | Gạt toggle "Chỉ ăn cái" trên món Phở Bò Tái Nạm (has_broth = true) | Happy Path (Món nước tiêu chuẩn) | Calo giảm chính xác `520 - 190 = 330 kcal`, Natri giảm `1850 - 1350 = 500 mg`, MacroBar cập nhật tức thời < 16ms | **P0** |
| `TC-S19-02` | Gạt toggle qua lại 10 lần liên tục giữa "Ăn cả nước" và "Chỉ ăn cái" | Kiểm thử lặp / Đảo trạng thái (Rapid toggle state) | Calo và Macro quay về đúng giá trị gốc sau mỗi chu kỳ, không bị cộng dồn lệch số, không rò rỉ RAM | **P0** |
| `TC-S19-03` | Bỏ chọn topping "Mỡ hành" trên đĩa Cơm Tấm Sườn Bì Chả | Phân rã món combo (Sub-items decomposition) | Calo giảm đúng `680 - 60 = 620 kcal`, lượng Fat giảm tương ứng, chip hiển thị gạch ngang | **P0** |
| `TC-S19-04` | Bỏ chọn toàn bộ topping phụ trên đĩa Cơm Tấm (chỉ giữ cơm) | Biên cực hạn topping (All sub-items unchecked except base) | Calo hiển thị đúng 210 kcal, không bị âm số, hệ thống vẫn cho phép bấm lưu bình thường | **P0** |
| `TC-S19-05` | Quét món khô thuần túy (Bánh cuốn, Gỏi cuốn) với `has_broth = false` | Phân vùng ngoại trừ (Non-broth dish) | Khối Broth Toggle ẩn hoàn toàn (`SizedBox.shrink()`), không để lại khoảng trắng layout | **P1** |
| `TC-S19-06` | Phản hồi JSON lỗi từ AI: `broth_calories > total_calories` | Biên dị thường dữ liệu (Corrupted AI output) | Clamp an toàn `effectiveCalories = max(0, total - broth)`, không bao giờ sinh ra calo âm | **P0** |
| `TC-S19-07` | Đọc bản ghi lịch sử cũ từ `v2.8.0` thiếu trường `has_broth` và `sub_items` | Tương thích ngược (Backward compatibility) | Deserialization thành công với giá trị mặc định (`false` và `[]`), 0 crash, 0 NPE | **P0** |
| `TC-S19-08` | Lưu bữa ăn đã gạt toggle trong chế độ Airplane Mode (Offline) | Ngoại lệ kết nối (Offline persistence) | Ghi nhận bản ghi chính xác vào Local Hive box trong < 50ms, xếp vào `sync_queue` | **P0** |
| `TC-S19-09` | Render màn hình `ScanReviewPage` trên thiết bị hẹp (iPhone SE 320pt) | Kiểm thử hiển thị biên (Extreme viewport) | Các chip Broth Toggle và Topping Wrap tự động xuống dòng mượt mà, **0 RenderFlex overflow** | **P0** |

---

## 2. Tiêu Chí Nghiệm Thu Phi Chức Năng (Non-Functional SLAs)

1. **AI Latency SLA**: Thời gian từ lúc gửi ảnh đến khi nhận phản hồi bóc tách món Việt từ Gemini 2.0 Flash **≤ 2.2s** trên mạng 4G/WiFi tiêu chuẩn (Ngân sách tối đa 2.5s).
2. **UI Frame Rate (FPS)**: Thao tác bấm công tắc Toggle và tick/bỏ tick Topping đạt **60 FPS** ổn định, độ trễ phản hồi UI `< 16ms`.
3. **Quản lý bộ nhớ (Memory Profiling)**: Thực hiện chuỗi 10 lần chụp ảnh món nước và chuyển đổi trạng thái toggle liên tục, mức sử dụng RAM tăng không quá 15MB và thu hồi hoàn toàn khi đóng màn hình (0 Memory Leak).
4. **Cấm Du Di Tuyệt Đối (No Fake Green Test)**: Tất cả unit test và widget test mới phải assert chính xác giá trị nghiệp vụ (calo, natri, macro, trạng thái visual chip). Không chấp nhận bất kỳ `expect(true, isTrue)` hay assert hình thức nào.

---

> 🟢 **Gate 3 Sign-Off**: Kịch bản kiểm thử bao phủ **100% User Stories và Acceptance Criteria** của BA, sẵn sàng làm kim chỉ nam thực thi cho Gate 4 Dev Team.
