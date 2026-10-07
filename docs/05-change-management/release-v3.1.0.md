# Thông Cáo Phát Hành Phiên Bản: AstroBite v3.1.0

> **Phiên bản**: `v3.1.0`  
> **Tên phát hành**: Social Guilds & Planetary Challenges (Bang Hội Vũ Trụ & Thử Thách Hành Tinh)  
> **Mã Sprint**: Sprint 21 (`EPIC-14` / `FEAT-S21-GUILDS`)  
> **Ngày phát hành**: 07/10/2026  
> **Ký duyệt bởi**: Hội Đồng PO, PM, Tech Lead & Security Auditor  

---

## 🌟 Điểm Nhấn Phiên Bản (Release Highlights)

1. **Bang Hội Vũ Trụ (Social Guilds)**:
   - Cho phép người dùng tự khởi tạo Bang hội mới hoặc gia nhập Bang hội của bạn bè/đồng nghiệp thông qua **Mã Mời 6 ký tự độc bản** (`Invite Code`).
   - Giới hạn quy mô vi mô tối đa 20 thành viên / Bang hội để đảm bảo sự gắn kết chặt chẽ và tương tác hiệu quả (Dunbar's Micro-Teams).
   - Avatar Hành Tinh đa dạng: Sao Hỏa, Sao Kim, Sao Mộc, Sao Thổ, Sao Hải Vương.

2. **Chiến Dịch Tuần Hành Tinh (Planetary Challenges)**:
   - Mục tiêu chung của cả đội (Ví dụ: 50,000 Kcal Lành Mạnh hoặc 100 bữa ăn đúng hạn / tuần).
   - Vòng cung tiến độ nhóm sinh động `GuildProgressArc` với màu Duolingo Lime Green (`#58CC02`).

3. **Cơ Chế Đóng Góp Tự Động (Auto-Contribution)**:
   - Mỗi bữa ăn hợp lệ được ghi nhận trong Food Diary tự động tích lũy **+50 Starlight XP** cho cá nhân và quỹ điểm chung của cả Bang hội.
   - Cơ chế atomic increment triệt tiêu hoàn toàn rủi ro race condition và thất thoát điểm.

4. **Bảng Xếp Hạng Đóng Góp Nội Bộ & Streak Nudge**:
   - Vinh danh thành viên đóng góp nhiều nhất trong tuần với danh hiệu **MVP** 👑.
   - Tính năng **Nudge 1-chạm** gửi tín hiệu nhắc nhở đồng đội giữ vững ngọn lửa Streak.

---

## 📊 Chỉ Số Kỹ Thuật Bản Build

- **Automated Test Suite**: **289 / 289 tests passed (100%)**.
- **Chất lượng mã nguồn**: `flutter analyze` 0 lỗi, 0 cảnh báo.
- **Hiệu năng giao diện**: Duy trì ổn định 60 FPS.
- **Rò rỉ bộ nhớ**: 0 Memory Leak.
- **Zero Doc-Code Drift**: 100% tài liệu 8 Cổng được cập nhật đồng bộ.
