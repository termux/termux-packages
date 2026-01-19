#!/usr/bin/env bash
# ==============================
# TDOC — Fix Mode (AUTO)
# ==============================

set -euo pipefail

: "${TDOC_ROOT:?TDOC_ROOT is not set}"

source "$TDOC_ROOT/core/ui.sh"
source "$TDOC_ROOT/core/report.sh"

STATE_FILE="$PREFIX/var/lib/tdoc/state.env"

print_header "🤖 TDOC Fix Mode (AUTO)"
echo

# ---------- INIT ----------
report_init

fixed=()
skipped=()

# ---------- AUTO FIX HANDLERS ----------

auto_fix_Storage() {
  termux-setup-storage
  print_ok "Storage access granted"
  fixed+=("Storage")
}

auto_fix_Repository() {
  print_warn "Repository cannot be auto-fixed"
  print_info "Suggested: termux-change-repo"
  skipped+=("Repository")
}

auto_fix_NodeJS() {
  pkg install -y nodejs
  print_ok "NodeJS installed"
  fixed+=("NodeJS")
}

auto_fix_Python() {
  print_warn "Python requires manual review"
  print_info "Suggested: pkg reinstall python"
  skipped+=("Python")
}

auto_fix_Git() {
  print_warn "Git requires manual review"
  print_info "Suggested: pkg install git"
  skipped+=("Git")
}

auto_fix_TermuxVersion() {
  print_info "Termux version cannot be fixed automatically"
  skipped+=("TermuxVersion")
}

# ---------- MAIN LOOP ----------
while IFS='=' read -r key value; do
  [[ -z "$key" || "$value" == "OK" ]] && continue

  func="auto_fix_$key"

  echo
  echo -e "${CYAN}AUTO handling:${RESET} $key"

  if declare -f "$func" >/dev/null; then
    "$func"
  else
    print_skip "$key has no auto-fix handler"
    skipped+=("$key")
  fi
done < "$STATE_FILE"

# ---------- REPORT ----------
if [[ ${#skipped[@]} -gt 0 ]]; then
  report_append_manual "${fixed[@]}" --skipped "${skipped[@]}"
else
  report_append_auto "${fixed[@]}"
fi

echo
print_ok "Auto-fix completed"
print_info "Report saved: ~/.tdoc/report.json"
print_info "Run: tdoc status"
