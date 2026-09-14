#!/usr/bin/env bash
set -euo pipefail

echo "======================================================="
echo "  [AstroBite] Khởi tạo Workspace & Git Submodules"
echo "======================================================="

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -f ".gitmodules" ]; then
    echo ">> Đang khởi tạo và cập nhật các submodule..."
    git submodule update --init --recursive
    echo ">> Hoàn tất tải submodules!"
else
    echo "!! Không tìm thấy file .gitmodules trong thư mục gốc."
    exit 1
fi

echo "======================================================="
echo "  Workspace đã sẵn sàng để phát triển!"
echo "======================================================="
