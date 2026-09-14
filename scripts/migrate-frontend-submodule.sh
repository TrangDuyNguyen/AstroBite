#!/usr/bin/env bash
set -euo pipefail

echo "======================================================="
echo "  [AstroBite] Hỗ Trợ Tách & Di Chuyển Code Flutter FE"
echo "======================================================="

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

TARGET_DIR="frontend"
REMOTE_FE_URL="${1:-}"

if [ -z "$REMOTE_FE_URL" ]; then
    echo "Cách sử dụng:"
    echo "  ./scripts/migrate-frontend-submodule.sh <GIT_REMOTE_URL_CHO_FRONTEND>"
    echo "Ví dụ:"
    echo "  ./scripts/migrate-frontend-submodule.sh https://github.com/TrangDuyNguyen/astrobite-frontend.git"
    echo ""
    echo "Lưu ý: Hãy đảm bảo bạn đã tạo repo rỗng trên GitHub/GitLab trước khi chạy."
    exit 1
fi

echo ">> Đích đến submodule: $TARGET_DIR"
echo ">> URL Git Remote: $REMOTE_FE_URL"

# Kiểm tra nếu thư mục frontend chưa tồn tại và code Flutter đang ở root
if [ ! -d "$TARGET_DIR" ] && [ -d "lib" ]; then
    echo ">> Tạo thư mục tạm và sao chép mã nguồn Flutter..."
    mkdir -p "$TARGET_DIR"
    cp -R lib android ios assets test integration_test pubspec.yaml pubspec.lock analysis_options.yaml "$TARGET_DIR/" 2>/dev/null || true
    
    echo ">> Khởi tạo git repo bên trong $TARGET_DIR..."
    (
        cd "$TARGET_DIR"
        git init -b main
        git add .
        git commit -m "feat: initial commit of AstroBite Flutter frontend"
        git remote add origin "$REMOTE_FE_URL"
        echo ">> Bạn có thể đẩy code frontend lên remote bằng lệnh: (cd $TARGET_DIR && git push -u origin main)"
    )
    echo ">> Đã chuẩn bị xong thư mục $TARGET_DIR!"
else
    echo "!! Thư mục $TARGET_DIR đã tồn tại hoặc không tìm thấy thư mục lib/ ở root."
fi
