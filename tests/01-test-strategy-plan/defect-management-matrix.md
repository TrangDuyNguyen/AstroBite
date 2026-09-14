# Quy Chuẩn Phân Loại Lỗi & Vòng Đời Bug (Defect Management Matrix)

## 1. Mức Độ Nghiêm Trọng Của Lỗi (Severity Matrix)

| Mức độ | Tên gọi | Định nghĩa & Ví dụ trong AstroBite | SLA phản hồi |
| :---: | :--- | :--- | :---: |
| **S1** | **Blocker** | Ứng dụng bị Crash ngay khi khởi động, không thể đăng nhập, không thể lưu dữ liệu, bảo mật bị vi phạm. Không thể tiếp tục test. | Ngay lập tức (< 2h) |
| **S2** | **Critical** | Chức năng chính bị hỏng hoàn toàn (VD: Chụp ảnh AI không trả về kết quả; tính sai calo lệch hơn 50%). Không có giải pháp thay thế. | < 8h |
| **S3** | **Major** | Tính năng quan trọng gặp lỗi nhưng có cách khắc phục tạm thời (VD: Biểu đồ tuần không hiển thị nhưng số liệu trong ngày vẫn xem được). | < 24h |
| **S4** | **Minor** | Lỗi nhỏ về giao diện, căn chỉnh font chữ, màu sắc sai lệch nhẹ so với token `AppColors`, không ảnh hưởng chức năng. | Theo sprint |
| **S5** | **Trivial** | Lỗi chính tả, lỗi gợi ý văn bản hiển thị chưa tối ưu. | Theo backlog |

---

## 2. Vòng Đời Của Lỗi (Bug Lifecycle)

```
[New] -> [Assigned] -> [In Progress] -> [Fixed] -> [Ready for QA] -> [Re-tested] -> [Closed]
                                                        |
                                                        v (Nếu test lại vẫn lỗi)
                                                    [Re-opened]
```
