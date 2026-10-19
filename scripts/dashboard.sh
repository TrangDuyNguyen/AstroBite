#!/usr/bin/env bash
# ==============================================================================
# Launcher for Antigravity Neobrutalism Agent Mission Control
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SERVER_PY="${SCRIPT_DIR}/dashboard_server.py"

if ! command -v python3 &> /dev/null; then
    echo "❌ Lỗi: Cần có Python 3 để chạy Mission Control Dashboard."
    exit 1
fi

PORT=4321
URL="http://127.0.0.1:${PORT}"

echo "🚀 Đang khởi động Neobrutalism Mission Control tại ${URL}..."

# Mở trình duyệt sau 1 giây
(
  sleep 1
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open "${URL}" 2>/dev/null || true
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "${URL}" 2>/dev/null || true
  fi
) &

# Khởi chạy python local server
exec python3 "${SERVER_PY}" "${WORKSPACE_DIR}"
