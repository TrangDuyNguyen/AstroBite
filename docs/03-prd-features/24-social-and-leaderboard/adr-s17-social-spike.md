# ADR: S17 Social Accountability & Leaderboard Spike

- **Status**: Accepted
- **Author**: Sub-Agent Tech Lead
- **Date**: 2026-10-04
- **Sprint**: 17

## 1. Bối cảnh (Context)
Sprint 17 yêu cầu xây dựng tính năng Social Sharing (xuất thẻ thành tích Meal/Day) và bảng xếp hạng (Astro Leaderboard) để gia tăng tương tác cộng đồng. Chúng ta cần tìm giải pháp kỹ thuật tối ưu nhất để xuất file ảnh từ UI Flutter và cấu trúc cơ sở dữ liệu cho Leaderboard sao cho tối ưu chi phí Firebase.

## 2. Quyết định Kiến trúc (Decisions)

### A. Xuất ảnh Widget và Share (Social Sharing)
**Vấn đề**: Không thể chia sẻ trực tiếp 1 Flutter Widget qua các mạng xã hội. Phải chuyển nó thành file ảnh thật sự.
**Giải pháp khả thi (Được chọn)**:
1. Bao bọc (Wrap) `ClayCard` cần share bằng `RepaintBoundary` kèm theo một `GlobalKey`.
2. Gọi `key.currentContext.findRenderObject() as RenderRepaintBoundary`.
3. Sử dụng `.toImage(pixelRatio: 3.0)` để render giao diện thành `ui.Image` (chất lượng cao).
4. Chuyển thành `.toByteData(format: ui.ImageByteFormat.png)` và ghi ra bộ nhớ đệm (Cache) dùng `path_provider` (`getTemporaryDirectory()`).
5. Gọi `Share.shareXFiles([XFile(path)])` từ package `share_plus` để kích hoạt giao diện Native Share của iOS/Android.

**Chi phí & Hiệu năng**: Quá trình render diễn ra dưới 300ms. Rất an toàn và không cần cài thêm thư viện nặng nào ngoài `share_plus` và `path_provider`.

### B. Kiến trúc Astro Leaderboard
**Vấn đề**: Việc sắp xếp hạng (Rank) cho hàng ngàn User theo điểm "Cosmic Streak" realtime bằng thao tác `.orderBy('streak').get()` mỗi khi có ai mở Leaderboard sẽ gây bùng nổ số lượt đọc (Reads) trên Firestore ➔ Vượt ngân sách ngay lập tức.
**Giải pháp khả thi (Được chọn)**:
1. **Cron Job (Cloud Functions)**: Viết một hàm Firebase Cloud Functions chạy `onSchedule` mỗi 1 giờ (hoặc ngày 1 lần).
2. Hàm này đọc tập hợp Users, sắp xếp và tính toán Rank.
3. Ghi kết quả vào một Document tĩnh duy nhất (VD: `leaderboard/weekly_top_100`).
4. Khi App mở Bảng xếp hạng, thiết bị CHỈ ĐỌC đúng 1 Document duy nhất này. Cực kỳ tối ưu chi phí.

## 3. Hệ quả (Consequences)
- **Tích cực**: Giải pháp cực kỳ tiết kiệm chi phí, dễ mở rộng (Scalable), tuân thủ triết lý Ponytail.
- **Tiêu cực**: Leaderboard không phải realtime đến từng giây, mà có độ trễ 1 giờ (Near-Realtime). Chấp nhận được trong UX thiết kế.

> 🟢 **Tech Lead Sign-off**: Kỹ thuật hoàn toàn khả thi. Đủ điều kiện bàn giao cho BA tại Gate 1 để viết PRD.
