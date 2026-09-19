# Nhật Ký Rủi Ro & Điểm Nghẽn Kỹ Thuật (Risk & Blocker Log)

- **Quản lý bởi**: Sub-Agent Project Manager (PM)
- **Mục tiêu**: Giám sát và tháo gỡ điểm nghẽn kỹ thuật sớm nhất, đảm bảo dòng chảy liên tục qua 6 Gates
- **Cập nhật lần cuối**: 2026-09-19

---

## 🚨 Bảng Quản Trị Rủi Ro & Blockers Đang Hoạt Động

| Mã Rủi Ro | Ngày Phát Hiện | Phân Loại | Mô Tả Điểm Nghẽn Kỹ Thuật | Mức Độ | Phương Án Tháo Gỡ Đề Xuất | Sub-Agent Phụ Trách | Trạng Thái |
| :--- | :---: | :---: | :--- | :---: | :--- | :---: | :---: |
| **`RSK-006`** | 2026-09-19 | **AI Context** | Chat session dài (`EPIC-07`) có thể vượt token limit của Gemini 2.0 Flash, gây mất ngữ cảnh hội thoại giữa chừng. | **Trung bình** | Giới hạn lịch sử chat gửi kèm mỗi request (sliding window 10 tin nhắn gần nhất); thông báo người dùng khi session reset. | `flutter-expert` & `qa-tester` | 🟡 **Active** |
| **`RSK-007`** | 2026-09-19 | **Platform Permissions** | Apple HealthKit và Health Connect (`EPIC-10`) yêu cầu quyền truy cập phức tạp, có thể bị từ chối bởi người dùng hoặc bị thay đổi policy giữa các phiên bản OS. | **Trung bình** | Thiết kế graceful degradation: app vẫn hoạt động đầy đủ khi không có Health data; hiển thị UI hướng dẫn cấp quyền với trạng thái Empty State rõ ràng. | `ui-ux-designer` & `flutter-expert` | 🟡 **Active** |
| **`RSK-008`** | 2026-09-19 | **Dependency** | Plugin `health` (pub.dev) có thể có breaking changes hoặc compatibility issues với Flutter 3.x và các phiên bản iOS/Android mới. | **Thấp** | Bọc plugin bằng abstract repository layer (`HealthRepository`); dễ dàng swap implementation nếu cần thay đổi package. | `flutter-expert` | 🟡 **Active** |

---

## 🏛️ Lịch Sử Rủi Ro Đã Xử Lý (Sprint 01 & 02)

| Mã Rủi Ro | Ngày Phát Hiện | Phân Loại | Mô Tả Điểm Nghẽn Kỹ Thuật | Mức Độ | Phương Án Tháo Gỡ Đề Xuất | Sub-Agent Phụ Trách | Trạng Thái |
| :--- | :---: | :---: | :--- | :---: | :--- | :---: | :---: |
| **`RSK-001`** | 2026-09-18 | **Performance** | Thư viện FL Chart có thể gây sụt giảm FPS (< 55 FPS) khi vẽ biểu đồ đường xu hướng nhiều ngày trên máy cấu hình yếu. | **Trung bình** | Bọc Widget biểu đồ bằng `RepaintBoundary` trên cả CalorieTrendChart và WeightTrendChart; giới hạn điểm dữ liệu render. Đã kiểm thử đạt. | `flutter-expert` & `qa-tester` | 🟢 **Resolved** |
| **`RSK-002`** | 2026-09-18 | **Data / Network** | Khi người dùng nhập món thủ công hoặc quét ảnh ở nơi mất mạng, kết nối Cloud Firestore có thể bị timeout. | **Trung bình** | Sử dụng bộ nhớ đệm `common_foods_dataset.dart` cục bộ khi offline; thêm cờ báo chưa đồng bộ và kích hoạt sync ngầm khi có mạng. | `flutter-expert` | 🟢 **Controlled** |
| **`RSK-003`** | 2026-09-18 | **AI Latency** | Gemini 2.0 Flash Vision đôi khi phản hồi chậm vào giờ cao điểm (> 2.5s). | **Thấp** | Nén ảnh JPEG xuống tối đa 512x512 trước khi gửi; hiển thị `SkeletonLoader` kèm thông điệp Celestial UI mượt mà để giữ chân người dùng. | `flutter-expert` & `qa-tester` | 🟢 **Controlled** |
| **`RSK-004`** | 2026-09-18 | **AI Complexity** | Đĩa cơm đa món (`FEAT-06`) với bố cục phức tạp có thể làm tăng độ trễ AI (> 2.5s) hoặc sinh JSON thiếu cấu trúc. | **Trung bình** | Sử dụng System Prompt có JSON schema nghiêm ngặt, bóc tách `dishes` array độc lập; đã tích hợp và vượt qua unit/widget test. | `ui-ux-designer` & `flutter-expert` | 🟢 **Controlled** |
| **`RSK-005`** | 2026-09-18 | **Offline Sync** | Khối lượng bản ghi chờ đồng bộ (`FEAT-07`) tích tụ lâu ngày có thể gây nghẽn mạng khi vừa online trở lại. | **Thấp** | Cơ chế đệm SharedPreferences + Pending Queue kết hợp nút bấm chủ động và sync ngầm; đã kiểm thử đạt 100%. | `ui-ux-designer` & `flutter-expert` | 🟢 **Controlled** |

---

## 🧭 Quy Trình Xử Lý Cờ Đỏ (Red Flag Escalation)
1. **Khi phát hiện Blocker nghiêm trọng (Mức độ Cao)**:
   - Sub-Agent PM lập tức gắn nhãn `[BLOCKER]` trên kênh trao đổi và tạm dừng task liên quan trong `sprint-backlog.md`.
   - Triệu tập Sub-Agent `product-owner` để đánh giá xem có cần điều chỉnh scope hay không.
2. **Quy tắc đóng rủi ro**:
   - Rủi ro chỉ được chuyển sang trạng thái `Resolved` khi đã có bài kiểm thử chứng minh giải pháp hiệu quả (ví dụ: Benchmark FPS >= 55 được Sub-Agent QA ghi nhận).
