#!/usr/bin/env bash

source "$TDOC_ROOT/core/ui.sh"
source "$TDOC_ROOT/core/report.sh"
source "$TDOC_ROOT/core/ai_explain.sh"

print_header "👀 TDOC Fix Preview (Dry-Run)"
echo -e "${GRAY}No action will be executed${RESET}"
echo

report_init

planned=()
skipped=()

while IFS='=' read -r key value; do
  case "$key:$value" in

    Storage:PARTIAL)
      echo -e "${CYAN}[PREVIEW] Storage${RESET}"
      echo -e "${GRAY}→ termux-setup-storage${RESET}"
      ai_explain_item "Storage"
      planned+=("\"Storage\"")
      ;;

    Repository:BROKEN)
      echo -e "${CYAN}[PREVIEW] Repository${RESET}"
      echo -e "${GRAY}→ termux-change-repo${RESET}"
      ai_explain_item "Repository"
      planned+=("\"Repository\"")
      ;;

    NodeJS:BROKEN)
      echo -e "${CYAN}[PREVIEW] NodeJS${RESET}"
      echo -e "${GRAY}→ pkg install nodejs${RESET}"
      ai_explain_item "NodeJS"
      planned+=("\"NodeJS\"")
      ;;

    Python:BROKEN)
      print_warn "Python broken — no auto-fix"
      ai_explain_item "Python"
      skipped+=("\"Python\"")
      ;;
  esac
  echo
done < "$STATE_FILE"

report_append "preview" "$(IFS=,; echo "${planned[*]}")" "$(IFS=,; echo "${skipped[*]}")"

print_header "Summary"
print_ok "Planned : ${#planned[@]}"
print_skip "Skipped : ${#skipped[@]}"
echo
echo -e "${CYAN}Next:${RESET} run ${BOLD}tdoc fix --auto${RESET}"
