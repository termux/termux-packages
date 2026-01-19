#!/usr/bin/env bash
# ==============================
# TDOC — System Scan (Professional Core)
# ==============================

set -euo pipefail

: "${TDOC_ROOT:?TDOC_ROOT is not set}"

STATE_FILE="$PREFIX/var/lib/tdoc/state.env"
mkdir -p "$(dirname "$STATE_FILE")"
: > "$STATE_FILE"   # selalu reset state

# -----------------------
# Colors & Icons
# -----------------------
CYAN="\033[36m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

OK_ICON="✔"
BROKEN_ICON="✖"
BORDER="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# -----------------------
# Header
# -----------------------
echo -e "${CYAN}$BORDER${RESET}"
echo -e "${CYAN}🧪 TDOC — System Scan${RESET}"
echo -e "${CYAN}$BORDER${RESET}"
echo

# -----------------------
# Helper: check item
# -----------------------
check_item() {
    local key="$1"
    local label="$2"
    local cmd="$3"

    if eval "$cmd" >/dev/null 2>&1; then
        echo "$key=OK" >> "$STATE_FILE"
        echo -e " [${GREEN}$OK_ICON${RESET}] $label"
    else
        echo "$key=BROKEN" >> "$STATE_FILE"
        echo -e " [${RED}$BROKEN_ICON${RESET}] $label"
    fi
}

# -----------------------
# Repository Security
# -----------------------
source "$TDOC_ROOT/core/repo_security.sh"

if scan_repo_security; then
    echo "Repository=OK" >> "$STATE_FILE"
    echo -e " [${GREEN}$OK_ICON${RESET}] Repository Security"
else
    echo "Repository=BROKEN" >> "$STATE_FILE"
    echo -e " [${RED}$BROKEN_ICON${RESET}] Repository Security"
fi

# -----------------------
# Core Checks
# -----------------------
check_item "Storage" "Storage Write Access" "[[ -w \"$HOME\" ]]"
check_item "Python" "Python Interpreter" "python -c 'print(\"OK\")'"
check_item "NodeJS" "NodeJS Runtime" "node -e 'console.log(\"OK\")'"
check_item "Git" "Git Version Control" "git --version"
check_item "TermuxVersion" "Termux Environment" "termux-info"

# -----------------------
# Summary (safe, no subshell bug)
# -----------------------
ok=0
broken=0

while IFS='=' read -r _ value; do
    [[ "$value" == "OK" ]] && ok=$((ok+1)) || broken=$((broken+1))
done < "$STATE_FILE"

echo
echo -e "${CYAN}$BORDER${RESET}"
echo -e "${CYAN}📝 TDOC Scan Summary${RESET}"
echo -e "${CYAN}$BORDER${RESET}"
echo -e "${GREEN}OK     : $ok${RESET}"
echo -e "${RED}Broken : $broken${RESET}"
echo -e "${CYAN}$BORDER${RESET}"
echo
echo -e "✔ TDOC scan completed"
