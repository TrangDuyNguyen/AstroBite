# Nhật Ký Rủi Ro & Điểm Nghẽn Kỹ Thuật (Risk & Blocker Log)

- **Quản lý bởi**: Sub-Agent Project Manager (PM)
- **Mục tiêu**: Giám sát và tháo gỡ điểm nghẽn kỹ thuật sớm nhất, đảm bảo dòng chảy liên tục qua 6 Gates
- **Cập nhật lần cuối**: 2026-09-18

---

## 🚨 Bảng Quản Trị Rủi Ro & Blockers Đang Hoạt Động

| Mã Rủi Ro | Ngày Phát Hiện | Phân Loại | Mô Tả Điểm Nghẽn Kỹ Thuật | Mức Độ | Phương Án Tháo Gỡ Đề Xuất | Sub-Agent Phụ Trách | Trạng Thái |
| :--- | :---: | :---: | :--- | :---: | :--- | :---: | :---: |
| **`RSK-001`** | 2026-09-18 | **Performance** | Thư viện FL Chart có thể gây sụt giảm FPS (< 55 FPS) khi vẽ biểu đồ đường xu hướng nhiều ngày trên máy cấu hình yếu. | **Trung bình** | Bọc Widget biểu đồ bằng `RepaintBoundary`, rút gọn số điểm render dữ liệu trục X xuống tối đa 7 điểm/tuần hoặc 30 điểm/tháng. | `flutter-expert` & `qa-tester` | 🟡 **Mitigating** |
| **`RSK-002`** | 2026-09-18 | **Data / Network** | Khi người dùng nhập món thủ công hoặc quét ảnh ở nơi mất mạng, kết nối Cloud Firestore có thể bị timeout. | **Trung bình** | Sử dụng bộ nhớ đệm `common_foods_dataset.dart` cục bộ khi offline; thêm cờ báo chưa đồng bộ và kích hoạt sync ngầm khi có mạng. | `flutter-expert` | 🟢 **Controlled** |
| **`RSK-003`** | 2026-09-18 | **AI Latency** | Gemini 2.0 Flash Vision đôi khi phản hồi chậm vào giờ cao điểm (> 2.5s). | **Thấp** | Nén ảnh JPEG xuống tối đa 512x512 trước khi gửi; hiển thị `SkeletonLoader` kèm thông điệp Celestial UI mượt mà để giữ chân người dùng. | `flutter-expert` & `qa-tester` | 🟢 **Controlled** |

---

## 🧭 Quy Trình Xử Lý Cờ Đỏ (Red Flag Escalation)
1. **Khi phát hiện Blocker nghiêm trọng (Mức độ Cao)**:
   - Sub-Agent PM lập tức gắn nhãn `[BLOCKER]` trên kênh trao đổi và tạm dừng task liên quan trong `sprint-backlog.md`.
   - Triệu tập Sub-Agent `product-owner` để đánh giá xem có cần điều chỉnh scope hay không.
2. **Quy tắc đóng rủi ro**:
   - Rủi ro chỉ được chuyển sang trạng thái `Resolved` khi đã có bài kiểm thử chứng minh giải pháp hiệu quả (ví dụ: Benchmark FPS >= 55 được Sub-Agent QA ghi nhận).
