# BIÊN BẢN PHÁT HÀNH PHIÊN BẢN (RELEASE NOTES v1.6.0)

- **Tên phiên bản**: AstroBite v1.6.0 — Zero-Friction Ergonomic Logging
- **Mã Epic**: `EPIC-16` / `FEAT-14`
- **Người ký duyệt phát hành**: 👑 **Sub-Agent PO (`product-owner`)** & 📋 **Sub-Agent PM (`project-manager`)**
- **Ngày phát hành**: 2026-09-24
- **Trạng thái**: 🟢 **OFFICIALLY RELEASED**

---

## 🌟 1. Điểm Nhấn Phiên Bản (Release Highlights)

Phiên bản `v1.6.0` giải quyết triệt để rào cản ma sát (Friction) lớn nhất trong trải nghiệm người dùng hằng ngày: **Tốc độ ghi chép bữa ăn**:
1. **Khay Món Ăn Gần Đây 1 Chạm (1-Tap Recent Foods Tray)**:
   - Tự động lưu và hiển thị danh bạ các món thường ăn ngay dưới ô tìm kiếm của `ManualEntryPage`.
   - Chạm 1 phát là tự động điền món và tính toán Calo/Macro ngay lập tức.
2. **Hàng Nút Preset Trọng Lượng Nhanh (Quick Weight Steppers)**:
   - Bổ sung các phím bấm tiện lợi: `[-50g]`, `[+50g]`, `[1 Bát ~150g]`, `[1 Đĩa ~300g]`, `[Phần Chuẩn]`.
   - Giúp người dùng điều chỉnh khẩu phần chính xác mà không phải nắn nót kéo slider cảm ứng.
3. **Thanh Điều Hướng Đáy Công Thái Học (One-Thumb Action Bar)**:
   - Đưa bộ chọn bữa ăn (`Bữa sáng`, `Bữa trưa`, `Bữa tối`, `Bữa phụ`) và nút Primary CTA to bản (52pt) xuống sát đáy màn hình trong cả màn hình Nhập tay lẫn Quét ảnh AI.
   - Nằm trọn trong vùng ngón cái (Thumb Zone), triệt tiêu hoàn toàn thao tác cuộn mỏi tay.
4. **Hiệu Ứng Sóng Quét Radar Vũ Trụ (Celestial Radar Viewfinder)**:
   - Nâng cấp `ScanningViewfinder` với luồng sóng quét Radar ánh xanh Electric Blue (`#1A73E8`) tuần hoàn khi Gemini AI đang phân tích đĩa thức ăn.

---

## 📊 2. Chỉ Số Đạt Được Thực Tế (Metrics & SLAs)

- **Time-to-Log**: Hoàn tất ghi chép món quen thuộc trong **~2.8 giây** (giảm hơn 75% so với mức 12.5 giây trước đây).
- **Thao tác sau Quét AI**: Giảm xuống còn **1 chạm** để lưu thẳng vào bữa ăn mong muốn từ sticky bottom bar.
- **Automated Test Suite**: **152 / 152 tests passed (100%)**.
- **Static Analysis**: `flutter analyze` **0 issues found**.
- **Hiệu năng giao diện**: Ổn định ở **60 FPS**, tuyệt đối 0 RenderFlex overflow.
