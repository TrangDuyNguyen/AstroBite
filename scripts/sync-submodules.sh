#!/usr/bin/env bash
set -euo pipefail

echo "======================================================="
echo "  [AstroBite] Đồng bộ cập nhật mới nhất cho Submodules"
echo "======================================================="

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ ! -f ".gitmodules" ]; then
    echo "!! Không tìm thấy .gitmodules"
    exit 1
fi

echo ">> Đang kéo commit mới nhất từ nhánh mặc định của từng submodule..."
git submodule update --remote --merge

echo ">> Trạng thái các submodule sau khi đồng bộ:"
git submodule status

echo "======================================================="
echo ">> Nhắc nhở: Nếu các submodule có commit mới, đừng quên commit cập nhật pointer tại Root repo:"
echo "   git add . && git commit -m 'chore(root): sync submodules to latest' && git push"
echo "======================================================="
