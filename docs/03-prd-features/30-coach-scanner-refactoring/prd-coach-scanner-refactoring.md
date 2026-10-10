# PRD: AI Coach & Scanner Review Decomposition (Sprint 23)

- **Mã PRD**: `PRD-S23-COACH-SCANNER`
- **Mã Epic**: `EPIC-REF-02`
- **Tác giả**: Sub-Agent Business Analyst (`business-analyst`)
- **Phê duyệt**: Sub-Agent Product Owner (`product-owner`)
- **Trạng thái**: 🟢 **Gate 1 Approved**

---

## 1. Mục Tiêu Nghiệp Vụ & Bối Cảnh

Hệ thống AI Coach và Food Scanner Review là 2 tính năng trung tâm tạo nên giá trị khác biệt cốt lõi (Core USP) của AstroBite:
- **AI Coach**: Trợ lý dinh dưỡng cá nhân hóa thời gian thực, hiểu rõ thâm hụt calo trong ngày và gợi ý món ăn chuẩn phong cách Việt Nam kèm 1-Tap Log.
- **Scan Review**: Màn hình xem xét kết quả quét đa món Gemini Vision, cho phép người dùng vi chỉnh khối lượng món, nước dùng, topping và lưu tức thì vào nhật ký.

Do quá trình phát triển nhanh, hai màn hình này đã tích lũy nợ kỹ thuật nặng nề, trở thành các "God Files" gây khó khăn cho việc bảo trì và kiểm thử.
PRD này quy định việc bóc tách toàn diện giao diện và logic thành các sub-components độc lập, tuân thủ Clean Architecture và Ponytail Clean Code mà không làm thay đổi bất kỳ hành vi nghiệp vụ nào đối với người dùng.

---

## 2. Yêu Cầu Chức Năng (Functional Requirements)

### FR-01: Phân Hệ AI Coach
1. **Context Header**: Hiển thị chính xác lượng Calo còn lại trong ngày, thanh tiến độ 3 macros (Carb, Fat, Protein).
2. **Chat Timeline**: Hiển thị bong bóng trò chuyện người dùng và AI theo thời gian thực, hỗ trợ hiển thị Markdown và nút sao chép tin nhắn.
3. **Smart 1-Tap Meal Card**: Nhận diện thẻ gợi ý món ăn từ AI Coach, hiển thị dinh dưỡng và nút 1-Tap Log lưu thẳng vào nhật ký trong `< 150ms`.
4. **Input & Voice**: Hỗ trợ nhập liệu bằng văn bản và ghi âm giọng nói tiếng Việt bằng on-device STT (`speech_to_text`).
5. **Typing Feedback**: Hiển thị trạng thái AI đang suy nghĩ bằng hiệu ứng 3 chấm nảy.

### FR-02: Phân Hệ Scan Review
1. **Hero & Confidence**: Hiển thị ảnh chụp món ăn, tên món chính, độ tin cậy AI và nút mở Sheet chỉnh sửa món ăn tùy biến.
2. **Multi-dish List**: Với bữa ăn nhiều món (mâm cơm gia đình), hiển thị danh sách từng món (`DishItemCard`) với thanh trượt trọng lượng và nút xóa món.
3. **Macro Indicators & Calorie Radial**: Hiển thị đồng hồ tròn tiến độ calo so với ngân sách bữa ăn và 3 thanh macro.
4. **Quick Weight Steppers**: Các chip bước nhảy nhanh (`+50g`, `-50g`, `1 Bát`, `1 Đĩa`).
5. **Lưu Nhật Ký**: Nút 3D Duolingo lưu toàn bộ các món vào Firestore repository theo bữa ăn đã chọn.

---

## 3. Tiêu Chí Nghiệm Thu (Acceptance Criteria)
- 100% các tính năng hiện có hoạt động nguyên vẹn (0 regression).
- File `coach_page.dart` và `scan_review_page.dart` giảm xuống dưới **350 dòng**.
- Các sub-widgets bóc tách đều có độ dài dưới **250 dòng**.
- 100% test suite hiện có pass thành công.
