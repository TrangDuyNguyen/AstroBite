#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "======================================================="
echo "  [AstroBite] Báo Cáo Trạng Thái Git & Submodules"
echo "======================================================="

echo "--- [1] Trạng thái Root Repository ---"
git status -s
echo ""

echo "--- [2] Trạng thái Git Submodules (Con trỏ commit) ---"
if [ -f ".gitmodules" ]; then
    git submodule status || true
else
    echo "Chưa có .gitmodules"
fi
echo ""

for dir in docs tests frontend; do
    if [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; then
        echo "--- [$dir] Submodule Git Status ---"
        (cd "$dir" && git status -s && git branch -v)
        echo ""
    fi
done

echo "======================================================="
