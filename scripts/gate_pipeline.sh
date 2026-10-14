#!/usr/bin/env bash
# ==============================================================================
# AstroBite End-to-End Gate Pipeline Orchestrator (Relay Race Multi-Agent)
# Tự động hóa luồng chuyển tiếp (Hand-off) giữa 8+ Quality Gates
# Lưu trữ Artifacts trên đĩa & nạp Context tuần tự cho từng Sub-Agent
# ==============================================================================

set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_FILE="${WORKSPACE_DIR}/.agents/pipeline_state.json"
GATES_DOC_DIR="${WORKSPACE_DIR}/docs/gates"

# Tạo thư mục docs/gates nếu chưa có
mkdir -p "$GATES_DOC_DIR"

# Danh sách 9 Gates chuẩn mực theo AGENTS.md
# Index: 0=Gate 0, 1=Gate 1, 2=Gate 2, 3=Gate 3, 4=Gate 4, 5=Gate 5, 6=Gate 6, 7=Gate 6.5, 8=Gate 7
GATES_COUNT=9
GATES_KEYS=("0" "1" "2" "3" "4" "5" "6" "6.5" "7")
GATES_NAMES=(
  "Gate 0: Tech Lead (Brainstorming, Tech Spike & ADR)"
  "Gate 1: Business Analyst & PO (PRD & BDD Given-When-Then)"
  "Gate 2: UI/UX Designer (Celestial Dark UI Spec & 4pt Grid)"
  "Gate 3: QA/QC Tester (Master Test Plan & Gherkin .feature)"
  "Gate 4: Dev FE (Flutter Clean Architecture & Ponytail)"
  "Gate 5: Code Reviewer (Ponytail AST & Bloat Cutting)"
  "Gate 6: QA/QC Verification (Automated 100% Pass & FPS)"
  "Gate 6.5: Security Auditor (Zero-Trust & Cloudflare 6-Phase)"
  "Gate 7: Supreme Release Gate (PO & Tech Lead Clearance)"
)
GATES_ROLES=("tech-lead" "ba" "design" "qa" "dev" "reviewer" "qa" "security" "po")
GATES_TIERS=(
  "Tier S (Claude Opus 4.6 Thinking / Sonnet Thinking)"
  "Tier 2 (Gemini 3.1 Pro / Sonnet)"
  "Tier 2 (Gemini 3.1 Pro / Sonnet)"
  "Tier S / Tier 1"
  "Tier 1/2 (Claude Sonnet 4.6 / Gemini 3.1 Pro)"
  "Tier 2 (Gemini 3.1 Pro / Sonnet)"
  "Tier S (Claude Opus 4.6 Thinking)"
  "Tier S (Claude Opus 4.6 Thinking)"
  "Tier S (Supreme Release Board)"
)
GATES_ARTIFACTS=(
  "gate0-tech-spike-adr.md"
  "gate1-prd.md"
  "gate2-ui-ux-spec.md"
  "gate3-test-plan.feature"
  "lib/"
  "gate5-ponytail-review.md"
  "gate6-qa-signoff.md"
  "gate6.5-security-signoff.md"
  "release-tag.txt"
)

# Khởi tạo hoặc đọc State File
init_state() {
  local feature="$1"
  local feature_dir="${GATES_DOC_DIR}/${feature}"
  mkdir -p "$feature_dir"

  cat << EOF > "$STATE_FILE"
{
  "feature": "$feature",
  "feature_dir": "$feature_dir",
  "current_gate_index": 0,
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "updated_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "gates": {
    "0": {"status": "IN_PROGRESS", "artifact": "$feature_dir/gate0-tech-spike-adr.md"},
    "1": {"status": "PENDING", "artifact": "$feature_dir/gate1-prd.md"},
    "2": {"status": "PENDING", "artifact": "$feature_dir/gate2-ui-ux-spec.md"},
    "3": {"status": "PENDING", "artifact": "$feature_dir/gate3-test-plan.feature"},
    "4": {"status": "PENDING", "artifact": "lib/"},
    "5": {"status": "PENDING", "artifact": "$feature_dir/gate5-ponytail-review.md"},
    "6": {"status": "PENDING", "artifact": "$feature_dir/gate6-qa-signoff.md"},
    "6.5": {"status": "PENDING", "artifact": "$feature_dir/gate6.5-security-signoff.md"},
    "7": {"status": "PENDING", "artifact": "$feature_dir/release-tag.txt"}
  }
}
EOF
}

get_current_feature() {
  if [[ -f "$STATE_FILE" ]]; then
    grep -o '"feature": "[^"]*' "$STATE_FILE" | cut -d'"' -f4
  else
    echo ""
  fi
}

get_current_gate_idx() {
  if [[ -f "$STATE_FILE" ]]; then
    grep -o '"current_gate_index": [0-9]*' "$STATE_FILE" | awk '{print $2}'
  else
    echo "0"
  fi
}

# Hiển thị bảng Dashboard trạng thái của Pipeline
show_status() {
  if [[ ! -f "$STATE_FILE" ]]; then
    printf "\033[1;33m⚠️ Chưa có Pipeline nào đang chạy. Khởi tạo bằng: ./scripts/gate_pipeline.sh start <feature_name>\033[0m\n"
    return 0
  fi

  local feature
  feature=$(get_current_feature)
  local cur_idx
  cur_idx=$(get_current_gate_idx)

  printf "\n\033[1;36m========================================================================================\033[0m\n"
  printf " 🚀 \033[1mASTROBITE FEATURE DELIVERY PIPELINE\033[0m — Feature: [\033[1;33m%s\033[0m]\n" "$feature"
  printf "\033[1;36m========================================================================================\033[0m\n"
  printf " %-10s | %-42s | %-20s | %-12s\n" "GATE" "TÊN CHỐT CHẶN & VAI TRÒ" "MODEL TIER" "TRẠNG THÁI"
  printf "\033[1;36m----------------------------------------------------------------------------------------\033[0m\n"

  for i in "${!GATES_KEYS[@]}"; do
    local key="${GATES_KEYS[$i]}"
    local name="${GATES_NAMES[$i]}"
    local tier="${GATES_TIERS[$i]}"
    local status_str
    
    if (( i < cur_idx )); then
      status_str="\033[1;32m[ PASSED ]\033[0m"
    elif (( i == cur_idx )); then
      status_str="\033[1;33m[ ACTIVE ]\033[0m"
    else
      status_str="\033[1;30m[ PENDING]\033[0m"
    fi

    printf " %-10s | %-42s | %-20s | %b\n" "Gate $key" "$name" "$tier" "$status_str"
  done
  printf "\033[1;36m========================================================================================\033[0m\n\n"
}

# Kích hoạt phiên Terminal cho Gate hiện tại kèm Context từ Gate trước
launch_gate_session() {
  local gate_idx="$1"
  local feature
  feature=$(get_current_feature)
  local feature_dir="${GATES_DOC_DIR}/${feature}"

  local gate_key="${GATES_KEYS[$gate_idx]}"
  local gate_name="${GATES_NAMES[$gate_idx]}"
  local gate_role="${GATES_ROLES[$gate_idx]}"
  local gate_tier="${GATES_TIERS[$gate_idx]}"
  local current_artifact="${feature_dir}/${GATES_ARTIFACTS[$gate_idx]}"

  # Xác định input artifact từ gate trước (nếu có)
  local prev_artifact=""
  local prev_gate_name=""
  if (( gate_idx > 0 )); then
    local prev_idx=$(( gate_idx - 1 ))
    prev_artifact="${feature_dir}/${GATES_ARTIFACTS[$prev_idx]}"
    prev_gate_name="${GATES_NAMES[$prev_idx]}"
  fi

  # Tạo script khởi tạo cho phiên terminal của Gate
  local session_env="${WORKSPACE_DIR}/.agents/.pipeline_gate_${gate_key}.sh"
  cat << 'EOF' > "$session_env"
export WORKSPACE_DIR="__WORKSPACE_DIR__"
export FEATURE="__FEATURE__"
export GATE_KEY="__GATE_KEY__"
export GATE_NAME="__GATE_NAME__"
export GATE_ROLE="__GATE_ROLE__"
export GATE_TIER="__GATE_TIER__"
export CURRENT_ARTIFACT="__CURRENT_ARTIFACT__"
export PREV_ARTIFACT="__PREV_ARTIFACT__"
export PREV_GATE_NAME="__PREV_GATE_NAME__"
export AGENT_SKILL=".agents/skills/__GATE_ROLE__/SKILL.md"

cd "$WORKSPACE_DIR"

clear
printf "\033[1;35m========================================================================================\033[0m\n"
printf " 🚀 \033[1mASTROBITE QUALITY GATE PIPELINE\033[0m — [\033[1;33mGate %s\033[0m]\n" "$GATE_KEY"
printf "\033[1;35m========================================================================================\033[0m\n"
printf " 🎯 \033[1mNhiệm vụ:\033[0m        %s\n" "$GATE_NAME"
printf " 🤖 \033[1mKhuyến nghị Model:\033[0m %s\n" "$GATE_TIER"
printf " 📁 \033[1mTính năng:\033[0m       %s\n" "$FEATURE"
printf " 📝 \033[1mSản phẩm đầu ra:\033[0m  %s\n" "$CURRENT_ARTIFACT"

if [[ -n "$PREV_ARTIFACT" && -f "$PREV_ARTIFACT" ]]; then
  printf " 📥 \033[1;32mNhận bàn giao từ:\033[0m %s\n" "$PREV_GATE_NAME"
  printf "    ↳ File đầu vào:   \033[1m%s\033[0m\n" "$PREV_ARTIFACT"
fi

printf "\033[1;35m----------------------------------------------------------------------------------------\033[0m\n"
printf " ⚡ \033[1;32mLệnh hỗ trợ trong phiên:\033[0m\n"
printf "    • \033[1mask \"<prompt>\"\033[0m   : Gửi task tới agent (tự đính kèm Skill Directive & File bàn giao trước)\n"
printf "    • \033[1mhand-off\033[0m         : Kiểm tra Artifacts đầu ra & TỰ ĐỘNG MỞ GATE TIẾP THEO!\n"
printf "    • \033[1mprev-context\033[0m     : Xem toàn văn file bàn giao của Gate trước\n"
printf "    • \033[1mpipeline-status\033[0m  : Xem dashboard tiến độ toàn bộ 8+ Gates\n"
printf "\033[1;35m========================================================================================\033[0m\n\n"

# Helper: Gửi task có kèm context tự động
ask() {
  if [[ $# -eq 0 ]]; then
    printf "\033[1;31m❌ Vui lòng nhập nội dung: ask \"<yêu cầu>\"\033[0m\n"
    return 1
  fi

  local extra_args=()
  if [[ -n "$PREV_ARTIFACT" && -f "$PREV_ARTIFACT" ]]; then
    extra_args+=("-a" "$PREV_ARTIFACT")
  fi

  printf "\033[1;34m[Gate %s] 🚀 Đang gửi yêu cầu kèm Context bàn giao tới Sub-Agent...\033[0m\n" "$GATE_KEY"
  agy-ide chat -a "$WORKSPACE_DIR/$AGENT_SKILL" -a "$WORKSPACE_DIR/AGENTS.md" "${extra_args[@]}" "$*"
}

# Helper: Xem context từ gate trước
prev-context() {
  if [[ -n "$PREV_ARTIFACT" && -f "$PREV_ARTIFACT" ]]; then
    cat "$PREV_ARTIFACT"
  else
    printf "\033[1;33m⚠️ Đây là Gate khởi đầu hoặc chưa có Artifact từ Gate trước.\033[0m\n"
  fi
}

# Helper: Chuyển tiếp Gate (Bàn giao tiếp sức)
hand-off() {
  "$WORKSPACE_DIR/scripts/gate_pipeline.sh" next
}

pipeline-status() {
  "$WORKSPACE_DIR/scripts/gate_pipeline.sh" status
}

export PS1="\[\033[1;35m\]astrobite\[\033[0m\]:\[\033[1;33m\]gate$GATE_KEY-$GATE_ROLE\[\033[0m\]$ "
EOF

  # Thay thế biến
  sed -i '' "s|__WORKSPACE_DIR__|$WORKSPACE_DIR|g" "$session_env"
  sed -i '' "s|__FEATURE__|$feature|g" "$session_env"
  sed -i '' "s|__GATE_KEY__|$gate_key|g" "$session_env"
  sed -i '' "s|__GATE_NAME__|$gate_name|g" "$session_env"
  sed -i '' "s|__GATE_ROLE__|$gate_role|g" "$session_env"
  sed -i '' "s|__GATE_TIER__|$gate_tier|g" "$session_env"
  sed -i '' "s|__CURRENT_ARTIFACT__|$current_artifact|g" "$session_env"
  sed -i '' "s|__PREV_ARTIFACT__|$prev_artifact|g" "$session_env"
  sed -i '' "s|__PREV_GATE_NAME__|$prev_gate_name|g" "$session_env"

  # Khởi chạy Terminal window
  osascript << EOA
tell application "Terminal"
    activate
    set newWin to do script "zsh --rcs <(cat ~/.zshrc \"$session_env\")"
    set custom title of newWin to "Gate $gate_key: $gate_name"
end tell
EOA

  printf "\n✅ \033[1;32mĐã kích hoạt Gate %s: %s\033[0m\n" "$gate_key" "$gate_name"
  printf "   ↳ Cửa sổ Terminal chuyên dụng đã mở. Gõ \033[1mhand-off\033[0m khi hoàn tất!\n\n"
}

# Bắt đầu một pipeline mới
start_pipeline() {
  local feature="${1:-}"
  if [[ -z "$feature" ]]; then
    printf "\033[1;31m❌ Vui lòng nhập tên tính năng: ./scripts/gate_pipeline.sh start <feature_name>\033[0m\n"
    printf "   Ví dụ: ./scripts/gate_pipeline.sh start food-scanner-offline\n"
    exit 1
  fi

  init_state "$feature"
  printf "🌟 \033[1;32mĐã khởi tạo Pipeline cho tính năng: %s\033[0m\n" "$feature"
  show_status
  launch_gate_session 0
}

# Chuyển tiếp sang Gate tiếp theo (Hand-off)
next_gate() {
  if [[ ! -f "$STATE_FILE" ]]; then
    printf "\033[1;31m❌ Không tìm thấy Pipeline đang chạy!\033[0m\n"
    exit 1
  fi

  local cur_idx
  cur_idx=$(get_current_gate_idx)
  local feature
  feature=$(get_current_feature)
  local feature_dir="${GATES_DOC_DIR}/${feature}"
  local cur_artifact="${feature_dir}/${GATES_ARTIFACTS[$cur_idx]}"

  # Kiểm tra Artifacts đầu ra trước khi cho phép chuyển gate (ngoại trừ Gate 4 là code trong lib/)
  if [[ "$cur_artifact" != "lib/" && ! -f "$cur_artifact" ]]; then
    printf "\n\033[1;31m⛔ CHỐT CHẶN BỊ CHẶN (ZERO-TOLERANCE):\033[0m\n"
    printf "Chưa tìm thấy Artifact bàn giao đầu ra tại: \033[1m%s\033[0m\n" "$cur_artifact"
    printf "Vui lòng xuất file tài liệu hoặc nghiệm thu trước khi chuyển tiếp sang Gate kế tiếp!\n\n"
    return 1
  fi

  local next_idx=$(( cur_idx + 1 ))
  if (( next_idx >= GATES_COUNT )); then
    printf "\n🎉 \033[1;32mCHÚC MỪNG! ĐÃ HOÀN TẤT TOÀN BỘ 8+ GATES CHO TÍNH NĂNG [%s]!\033[0m\n" "$feature"
    printf "Bản phát hành đã sẵn sàng đưa lên Production & Firebase App Distribution.\n\n"
    sed -i '' "s|\"current_gate_index\": [0-9]*|\"current_gate_index\": $GATES_COUNT|g" "$STATE_FILE"
    show_status
    return 0
  fi

  # Cập nhật state
  sed -i '' "s|\"current_gate_index\": [0-9]*|\"current_gate_index\": $next_idx|g" "$STATE_FILE"
  sed -i '' "s|\"updated_at\": \"[^\"]*\"|\"updated_at\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"|g" "$STATE_FILE"

  printf "\n🔄 \033[1;36mĐang bàn giao Artifact từ Gate %s ➔ Gate %s...\033[0m\n" "${GATES_KEYS[$cur_idx]}" "${GATES_KEYS[$next_idx]}"
  show_status
  launch_gate_session "$next_idx"
}

# Lệnh điều hướng
CMD="${1:-help}"
case "$CMD" in
  start)
    shift
    start_pipeline "${1:-}"
    ;;
  next|hand-off)
    next_gate
    ;;
  status)
    show_status
    ;;
  current)
    cur_idx=$(get_current_gate_idx)
    launch_gate_session "$cur_idx"
    ;;
  reset)
    rm -f "$STATE_FILE" "${WORKSPACE_DIR}/.agents/.pipeline_gate_"*.sh
    printf "🧹 \033[1;32mĐã dọn dẹp sạch Pipeline State!\033[0m\n"
    ;;
  help|*)
    echo "================================================================================"
    echo "🚀 AstroBite End-to-End Gate Pipeline Orchestrator"
    echo "================================================================================"
    echo "Cú pháp:"
    echo "  • ./scripts/gate_pipeline.sh start <feature_name> : Khởi động Pipeline từ Gate 0"
    echo "  • ./scripts/gate_pipeline.sh status               : Xem bảng tiến độ 8+ Gates"
    echo "  • ./scripts/gate_pipeline.sh next                 : Bàn giao context & mở Gate tiếp theo"
    echo "  • ./scripts/gate_pipeline.sh current              : Mở lại Terminal của Gate hiện tại"
    echo "  • ./scripts/gate_pipeline.sh reset                : Xóa trạng thái để bắt đầu mới"
    echo "================================================================================"
    ;;
esac
