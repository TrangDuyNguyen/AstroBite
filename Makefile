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

# =======================================================
# Sub-Agent Session Management (CLI Multi-Agent Workspace)
# =======================================================
agents:
	@bash scripts/launch_agent_session.sh all

agent-techlead:
	@bash scripts/launch_agent_session.sh tech-lead

agent-dev:
	@bash scripts/launch_agent_session.sh dev

agent-qa:
	@bash scripts/launch_agent_session.sh qa

agent-design:
	@bash scripts/launch_agent_session.sh design

agent-security:
	@bash scripts/launch_agent_session.sh security

# =======================================================
# End-to-End Quality Gate Pipeline (Relay Race Hand-off)
# =======================================================
pipeline:
	@if [ -z "$(FEATURE)" ]; then \
		echo "❌ Vui lòng cung cấp tên tính năng: make pipeline FEATURE=ten-tinh-nang"; \
	else \
		bash scripts/gate_pipeline.sh start "$(FEATURE)"; \
	fi

pipeline-status:
	@bash scripts/gate_pipeline.sh status

pipeline-next:
	@bash scripts/gate_pipeline.sh next

pipeline-reset:
	@bash scripts/gate_pipeline.sh reset
