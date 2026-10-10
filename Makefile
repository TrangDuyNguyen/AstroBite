.PHONY: help setup update status pull test-fe check-files build-android build-ios release

help:
	@echo "======================================================="
	@echo "AstroBite Workspace Management Commands"
	@echo "======================================================="
	@echo "  make setup         : Khởi tạo và tải tất cả submodule (lần đầu)"
	@echo "  make update        : Cập nhật các submodule lên commit mới nhất từ remote"
	@echo "  make pull          : Pull code mới nhất của Root và các submodule"
	@echo "  make status        : Xem trạng thái git của Root và các submodule"
	@echo "  make test-fe       : Chạy unit/widget test của Frontend Flutter"
	@echo "  make check-files   : Kiểm tra độ dài & độ phức tạp file (Ponytail)"
	@echo "  make build-android : Build Android APK & AAB qua Fastlane"
	@echo "  make build-ios     : Build iOS IPA qua Fastlane"
	@echo "  make release       : Build toàn bộ Release artifacts (Android + iOS)"
	@echo "======================================================="

setup:
	@bash scripts/setup-workspace.sh

update:
	@bash scripts/sync-submodules.sh

status:
	@bash scripts/check-status.sh

pull:
	git pull --recurse-submodules

test-fe:
	@if [ -d "frontend" ]; then \
		cd frontend && flutter test; \
	else \
		flutter test; \
	fi

check-files:
	@bash scripts/check_file_length.sh

build-android:
	bundle exec fastlane android

build-ios:
	bundle exec fastlane ios

release:
	bundle exec fastlane release
