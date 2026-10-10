# Test Plan & Traceability Matrix (Gate 3) — Sprint 31: Đa Ngôn Ngữ i18n

- **Feature**: `FEAT-S31-I18N-FOUNDATION`
- **Tác giả**: Sub-Agent QA Tester (*The Paranoid Inquisitor*)
- **Duyệt bởi**: Sub-Agent Tech Lead & PO

---

## 1. Ma Trận Kịch Bản Kiểm Thử (Test Cases)

| Mã TC | Hạng mục | Kịch bản kiểm thử | Kỳ vọng |
|:---|:---|:---|:---|
| `TC-I18N-01` | Localization Unit | Khởi tạo `app_vi.arb` và `app_en.arb` | Cả 2 file có cùng số lượng keys, 0 key rỗng |
| `TC-I18N-02` | Provider State | Đọc và ghi `appLocaleProvider` | Thay đổi state cập nhật `Locale` chính xác |
| `TC-I18N-03` | SharedPreferences | Lưu và khôi phục ngôn ngữ sau khởi động lại | State lưu đúng chuỗi 'system', 'vi', 'en' |
| `TC-I18N-04` | Widget Rendering | Hiển thị màn hình chính với `Locale('vi')` | Nhãn "Hôm nay", "Bữa sáng" hiển thị đúng |
| `TC-I18N-05` | Widget Rendering | Hiển thị màn hình chính với `Locale('en')` | Nhãn "Today", "Breakfast" hiển thị đúng |
| `TC-I18N-06` | Regression | Chạy toàn bộ 322 test cases hiện có | 100% tests pass, 0 lỗi biên dịch |
