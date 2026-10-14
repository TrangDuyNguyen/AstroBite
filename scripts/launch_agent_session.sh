#!/usr/bin/env bash
# ==============================================================================
# AstroBite Sub-Agent CLI Session Launcher
# Tự động mở các phiên làm việc (Terminal Tabs/Windows) cho từng Sub-Agent
# Ánh xạ chuẩn Ma trận Model Tiering & Rules trong AGENTS.md
# ==============================================================================

set -euo pipefail

WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_ROLE="${1:-help}"

# Bảng cấu hình Metadata cho từng Sub-Agent
get_agent_info() {
  local role="$1"
  case "$role" in
    tech-lead)
      echo "Tech Lead & System Architect|Tier S (Claude Opus 4.6 Thinking / Sonnet Thinking)|Gate 0 (Tech Spike/ADR) & Gate 1/2 Feasibility Sign-Off|.agents/skills/tech-lead/SKILL.md|\033[1;35m"
      ;;
    po|product-owner)
      echo "Product Owner (The Strategic Tyrant)|Tier S (Claude Opus 4.6 Thinking)|Gate 1 (PRD Sign-off) & Gate 7 (Supreme Release)|.agents/skills/product-owner/SKILL.md|\033[1;31m"
      ;;
    ba|business-analyst)
      echo "Business Analyst (The Pedantic Logician)|Tier 2 (Gemini 3.1 Pro / Sonnet)|Gate 1 (PRD & BDD Given-When-Then)|.agents/skills/business-analyst/SKILL.md|\033[1;36m"
      ;;
    design|ui-ux-designer)
      echo "UI/UX Designer (Celestial Aesthetic Purist)|Tier 2 (Gemini 3.1 Pro / Sonnet)|Gate 2 (4pt Grid, 5 UI States, Celestial Tokens)|.agents/skills/ui-ux-designer/SKILL.md|\033[1;34m"
      ;;
    dev|dev-fe|flutter-core-dev)
      echo "Senior Flutter Dev (Clean Craftsman)|Tier 1/2 (Claude Sonnet 4.6 / Gemini 3.1 Pro)|Gate 4 (Clean Architecture, Riverpod, Ponytail)|.agents/skills/flutter-core-dev/SKILL.md|\033[1;32m"
      ;;
    qa|qa-tester)
      echo "QA/QC Tester (The Paranoid Inquisitor)|Tier S (Claude Opus 4.6 Thinking)|Gate 3 (Test Design BDD) & Gate 6 (Zero-Tolerance Sign-off)|.agents/skills/qa-tester/SKILL.md|\033[1;33m"
      ;;
    reviewer|code-reviewer)
      echo "Code Reviewer (The Ruthless Bloat Assassin)|Tier 2 (Gemini 3.1 Pro / Sonnet)|Gate 5 (Ponytail Diff Review - One line per cut)|.agents/skills/code-reviewer/SKILL.md|\033[1;37m"
      ;;
    security|security-auditor)
      echo "Security Auditor (The Zero-Trust Sentinel)|Tier S (Claude Opus 4.6 Thinking)|Gate 6.5 (OWASP MASVS, Cloudflare 6-phase audit)|.agents/skills/security-auditor/SKILL.md|\033[1;31m"
      ;;
    pm|project-manager)
      echo "Project Manager (The Clockwork Disciplinarian)|Tier 3 (Gemini 3.8 Flash / 3.7 Flash)|Sprint Backlog, WBS Matrix & Risk Log|.agents/skills/project-manager/SKILL.md|\033[1;33m"
      ;;
    *)
      echo ""
      ;;
  esac
}

# Tạo shell script khởi động phiên tương tác cho một Agent
launch_terminal_session() {
  local role="$1"
  local raw_info
  raw_info=$(get_agent_info "$role")

  if [[ -z "$raw_info" ]]; then
    echo "❌ Role không hợp lệ: $role"
    exit 1
  fi

  IFS="|" read -r title tier gates skill_file color <<< "$raw_info"

  # Tạo file rc tạm cho phiên shell của agent
  local agent_env_file="${WORKSPACE_DIR}/.agents/.session_${role}.sh"
  cat << 'EOF' > "$agent_env_file"
# AstroBite Sub-Agent Session Init
export WORKSPACE_DIR="__WORKSPACE_DIR__"
export AGENT_ROLE="__ROLE__"
export AGENT_TITLE="__TITLE__"
export AGENT_TIER="__TIER__"
export AGENT_GATES="__GATES__"
export AGENT_SKILL="__SKILL_FILE__"

cd "$WORKSPACE_DIR"

# Banner hiển thị
clear
printf "\033[1;36m================================================================================\033[0m\n"
printf " ✨ \033[1mASTROBITE MULTI-AGENT WORKSPACE\033[0m — [\033[1;33m%s\033[0m]\n" "$AGENT_TITLE"
printf "\033[1;36m================================================================================\033[0m\n"
printf " 🤖 \033[1mAI Model Tier:\033[0m     %s\n" "$AGENT_TIER"
printf " 🚪 \033[1mGate Phụ Trách:\033[0m    %s\n" "$AGENT_GATES"
printf " 📜 \033[1mSkill Directive:\033[0m   %s\n" "$AGENT_SKILL"
printf "\033[1;36m--------------------------------------------------------------------------------\033[0m\n"
printf " 💡 \033[1;32mLệnh hỗ trợ trong phiên:\033[0m\n"
printf "    • \033[1mask \"<prompt>\"\033[0m    : Gửi yêu cầu tới agent (tự nạp Skill Directive & AGENTS.md)\n"
printf "    • \033[1mskill\033[0m              : Đọc toàn văn hướng dẫn & quy chuẩn của agent này\n"
printf "    • \033[1mgates\033[0m              : Xem tiêu chuẩn và điều kiện cấm du di của các Gate\n"
printf "    • \033[1mcheck-code\033[0m         : Chạy kiểm tra chuẩn Ponytail & độ dài file\n"
printf "\033[1;36m================================================================================\033[0m\n\n"

# Helper functions
ask() {
  if [[ $# -eq 0 ]]; then
    printf "\033[1;31m❌ Vui lòng nhập câu hỏi hoặc nhiệm vụ: ask \"<nhiệm vụ>\"\033[0m\n"
    return 1
  fi
  printf "\033[1;34m[AstroBite Agent] 🚀 Đang gửi yêu cầu tới %s...\033[0m\n" "$AGENT_TITLE"
  agy-ide chat -a "$WORKSPACE_DIR/$AGENT_SKILL" -a "$WORKSPACE_DIR/AGENTS.md" "$*"
}

skill() {
  if command -v bat &>/dev/null; then
    bat "$WORKSPACE_DIR/$AGENT_SKILL"
  else
    cat "$WORKSPACE_DIR/$AGENT_SKILL"
  fi
}

gates() {
  printf "\033[1;33m=== TRÍCH XUẤT TIÊU CHUẨN CỔNG TỪ AGENTS.md ===\033[0m\n"
  grep -A 10 -E "Chốt Chặn [0-7]" "$WORKSPACE_DIR/AGENTS.md" | head -n 35
}

check-code() {
  make check-files
}

# Đổi prompt terminal để nhận diện agent
export PS1="\[\033[1;35m\]astrobite\[\033[0m\]:\[\033[1;33m\]$AGENT_ROLE\[\033[0m\]$ "
EOF

  # Thay thế biến trong file env
  sed -i '' "s|__WORKSPACE_DIR__|$WORKSPACE_DIR|g" "$agent_env_file"
  sed -i '' "s|__ROLE__|$role|g" "$agent_env_file"
  sed -i '' "s|__TITLE__|$title|g" "$agent_env_file"
  sed -i '' "s|__TIER__|$tier|g" "$agent_env_file"
  sed -i '' "s|__GATES__|$gates|g" "$agent_env_file"
  sed -i '' "s|__SKILL_FILE__|$skill_file|g" "$agent_env_file"

  # Gọi AppleScript mở session trong Terminal.app
  osascript << EOA
tell application "Terminal"
    activate
    set newWin to do script "zsh --rcs <(cat ~/.zshrc \"$agent_env_file\")"
    set custom title of newWin to "AstroBite: $title"
end tell
EOA

  printf "✅ Đã mở phiên Terminal cho: \033[1;32m%s\033[0m (%s)\n" "$title" "$tier"
}

# Điều hướng
case "$TARGET_ROLE" in
  all)
    echo "🌟 Đang mở đồng loạt 4 Sub-Agent Sessions cốt lõi của AstroBite..."
    launch_terminal_session "tech-lead"
    sleep 0.4
    launch_terminal_session "design"
    sleep 0.4
    launch_terminal_session "dev"
    sleep 0.4
    launch_terminal_session "qa"
    echo "🎉 Đã mở đầy đủ 4 phiên Sub-Agent!"
    ;;
  tech-lead|po|ba|design|dev|qa|reviewer|security|pm)
    launch_terminal_session "$TARGET_ROLE"
    ;;
  help|*)
    echo "================================================================================"
    echo "🚀 AstroBite Sub-Agent CLI Session Launcher"
    echo "================================================================================"
    echo "Cú pháp: ./scripts/launch_agent_session.sh <role>"
    echo ""
    echo "Các vai trò khả dụng:"
    echo "  • all          : Mở đồng loạt 4 Agent cốt lõi (Tech Lead, Design, Dev, QA)"
    echo "  • tech-lead    : Gate 0 Spike/ADR & Feasibility Sign-off (Tier S Thinking)"
    echo "  • po           : Product Owner - Roadmap & Gate 1/7 Sign-off (Tier S Thinking)"
    echo "  • ba           : Business Analyst - PRD & BDD Stories (Tier 2 Pro)"
    echo "  • design       : UI/UX Designer - Celestial Dark UI & 4pt Grid (Tier 2 Pro)"
    echo "  • dev          : Flutter Clean Craftsman - Riverpod & Ponytail (Tier 1/2)"
    echo "  • qa           : QA/QC - Kịch bản BDD & Nghiệm thu Zero-Tolerance (Tier S)"
    echo "  • reviewer     : Ponytail Reviewer - Triệt tiêu code thừa (Tier 2 Pro)"
    echo "  • security     : Security Auditor - Kiểm toán 6 pha Cloudflare (Tier S)"
    echo "  • pm           : Project Manager - WBS & Kanban Velocity (Tier 3 Flash)"
    echo "================================================================================"
    ;;
esac
