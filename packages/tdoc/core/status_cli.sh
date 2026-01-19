#!/usr/bin/env bash
# ==============================
# TDOC — CLI Friendly Status & Explanation
# ==============================

STATE_FILE="$TDOC_ROOT/data/state.env"

# Load version & explanations
source "$TDOC_ROOT/core/version.sh"
source "$TDOC_ROOT/core/ai_explain.sh"

# Colors & icons
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"
OK_ICON="✅"
BROKEN_ICON="❌"

# Termux version
get_termux_version() {
    if command -v termux-info >/dev/null 2>&1; then
        termux-info | grep -i "Version" | awk '{print $2}' || echo "unknown"
    else
        echo "unknown"
    fi
}

# Git info
get_git_info() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        commit=$(git rev-parse HEAD 2>/dev/null)
        echo "$branch ($commit)"
    else
        echo "N/A"
    fi
}

# Header
echo -e "${CYAN}🧪 TDOC — Status Report${RESET}"
echo -e "Tool: $TDOC_NAME"
echo -e "Version: $TDOC_VERSION ($TDOC_CODENAME)"
echo -e "Build Date: $TDOC_BUILD_DATE"
echo -e "Termux Version: $(get_termux_version)"
echo -e "Git: $(get_git_info)"
echo

# Check state file
if [ ! -f "$STATE_FILE" ]; then
    echo -e "${RED}❌ State file not found!${RESET}"
    echo "Run: tdoc scan"
    exit 1
fi

ok=0
broken=0

while IFS='=' read -r key value; do
    [[ -z "$key" ]] && continue

    if [ "$value" = "OK" ]; then
        echo -e "${GREEN}$OK_ICON $key: $value${RESET}"
        ok=$((ok + 1))
    else
        echo -e "${RED}$BROKEN_ICON $key: $value${RESET}"
        # Explanation
        ai_explain "$key" | while IFS= read -r line; do
            echo -e "  ${YELLOW}$line${RESET}"
        done
        broken=$((broken + 1))
    fi
done < "$STATE_FILE"

# Summary
echo
echo -e "${CYAN}📝 Summary:${RESET} $ok OK, $broken Broken"
echo
