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

### B. Kiến trúc Astro Leaderboard & Lộ trình Triển khai (Staging)
**Vấn đề**: Việc sắp xếp hạng (Rank) cho hàng ngàn User theo điểm "Cosmic Streak" realtime bằng thao tác `.orderBy('streak').get()` mỗi khi có ai mở Leaderboard sẽ gây bùng nổ số lượt đọc (Reads) trên Firestore ➔ Vượt ngân sách ngay lập tức.

**Quyết định phân kỳ kỹ thuật (Technical Phasing)**:
1. **Phase 1 (v2.7.0 — Hiện tại)**:
   - Triển khai **In-Memory Client State** tại `LeaderboardPage` kèm mock bạn bè và cơ chế thêm bạn tức thì (local sort).
   - Mục đích: Thẩm định nhanh phản ứng của người dùng đối với trải nghiệm cạnh tranh xã hội và UI Claymorphic trước khi tốn tài nguyên hạ tầng backend.
2. **Phase 2 (v2.8.0 — Triển khai tiếp theo)**:
   - **Cron Job (Cloud Functions)**: Viết hàm Firebase Cloud Functions chạy `onSchedule` định kỳ 1 giờ / lần để tính toán và lưu snapshot vào `leaderboard/weekly_top_100`.
   - **Client Data Layer**: Tạo `LeaderboardRepository` và `StreamProvider` trong Riverpod để đọc snapshot tĩnh từ Firestore, đảm bảo chi phí 1 Read / lần mở app.

## 3. Hệ quả (Consequences)
- **Tích cực**: Giải pháp cực kỳ tiết kiệm chi phí, dễ mở rộng (Scalable), tuân thủ triết lý Ponytail (làm rõ UX trước khi over-engineer backend).
- **Tiêu cực**: Phase 1 v2.7.0 chưa đồng bộ được bạn bè giữa 2 thiết bị khác nhau; Phase 2 giải quyết triệt để vấn đề này với độ trễ tối đa 1 giờ (Near-Realtime).

> 🟢 **Tech Lead Sign-off**: Kỹ thuật hoàn toàn khả thi. Thống nhất phân kỳ Phase 1 (Client Mock) cho v2.7.0 và Phase 2 (Cloud Functions) cho v2.8.0.

