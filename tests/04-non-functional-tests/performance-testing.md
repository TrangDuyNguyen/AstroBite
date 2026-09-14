# Kế Hoạch Kiểm Thử Hiệu Năng (Performance Testing)

## 1. Các Chỉ Số Hiệu Năng Mục Tiêu (SLOs / KPIs)
- **App Cold Start Time**: Thời gian khởi động nguội từ khi bấm icon app đến khi hiển thị Dashboard <= **1.8 giây** trên các thiết bị tầm trung.
- **Scroll Frame Rate**: Tốc độ khung hình khi cuộn danh sách lịch sử ăn uống đạt ổn định **55 - 60 FPS** (Không có jank/stutter).
- **AI Latency (Gemini 2.0 Flash)**: Tổng thời gian từ lúc bấm nút chụp -> nén ảnh -> gọi API -> trả về kết quả JSON <= **2.5 giây** (trên mạng 4G).
- **Bộ nhớ tiêu thụ (RAM Usage)**: Dưới **180 MB** trong quá trình mở Camera và xử lý ảnh; không bị rò rỉ bộ nhớ (Memory Leak) sau 20 lần chụp liên tiếp.
