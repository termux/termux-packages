#!/usr/bin/env bash
# ==============================
# TDOC — Status Report
# ==============================

set -euo pipefail

: "${TDOC_ROOT:?TDOC_ROOT is not set}"

source "$TDOC_ROOT/core/version.sh"
source "$TDOC_ROOT/core/ui.sh"

STATE_FILE="$PREFIX/var/lib/tdoc/state.env"

# -----------------------
# Header
# -----------------------
print_header "🧪 TDOC — Status Report"
echo

# -----------------------
# Tool Info
# -----------------------
echo "Tool:"
echo "  Name    : $TDOC_NAME"
echo "  Version : $TDOC_VERSION ($TDOC_CODENAME)"
echo "  Build   : $TDOC_BUILD_DATE"
echo

# -----------------------
# Environment Info
# -----------------------
echo "Environment:"
echo "  Android : $(getprop ro.build.version.release 2>/dev/null || echo unknown)"
echo "  Termux  : $(dpkg-query -W -f='${Version}' termux-tools 2>/dev/null || echo unknown)"
echo "  Checked : $(date '+%Y-%m-%d %H:%M:%S')"
echo

# -----------------------
# Load State (last value wins)
# -----------------------
if [[ ! -f "$STATE_FILE" ]]; then
  print_err "No scan state found"
  print_info "Run: tdoc scan"
  exit 1
fi

declare -A STATE

while IFS='=' read -r key value; do
  [[ -z "$key" ]] && continue
  STATE["$key"]="$value"
done < "$STATE_FILE"

ok=0
broken=0

echo "Status:"

for key in "${!STATE[@]}"; do
  case "$key" in
    repo.security) label="Repository Security" ;;
    sys.storage)   label="Storage Access" ;;
    bin.python)    label="Python Interpreter" ;;
    bin.node)      label="NodeJS Runtime" ;;
    bin.git)       label="Git Version Control" ;;
    termux.info)   label="Termux Environment" ;;
    *)             label="$key" ;;
  esac

  if [[ "${STATE[$key]}" == "OK" ]]; then
    print_ok "$label"
    ok=$((ok + 1))
  else
    print_err "$label"
    broken=$((broken + 1))
  fi
done

# -----------------------
# Summary
# -----------------------
echo
print_header "📝 TDOC Status Summary"
echo -e "${GREEN}OK     : $ok${RESET}"
echo -e "${RED}Broken : $broken${RESET}"
