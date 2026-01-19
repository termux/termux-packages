#!/usr/bin/env bash
# ==============================
# TDOC — Fix Mode (Manual, Compliant)
# ==============================

: "${TDOC_ROOT:?TDOC_ROOT is not set}"

source "$TDOC_ROOT/core/ui.sh"
source "$TDOC_ROOT/core/report.sh"

STATE_FILE="$PREFIX/var/lib/tdoc/state.env"

print_header "🛠 TDOC Fix Mode (Manual)"
echo

# ---------- PRECHECK ----------
if [[ ! -f "$STATE_FILE" ]]; then
  print_err "No state file found"
  print_info "Run: tdoc scan"
  exit 1
fi

# ---------- INIT REPORT ----------
report_init

fixed_items=()
skipped_items=()

# ---------- FIX HANDLERS ----------

fix_Storage() {
  read -rp "Run 'termux-setup-storage'? [y/N]: " ans
  [[ "$ans" =~ ^[Yy]$ ]] || {
    print_skip "Storage skipped"
    skipped_items+=("Storage")
    return
  }

  if termux-setup-storage; then
    print_ok "Storage access granted"
    fixed_items+=("Storage")
  else
    print_err "Storage setup failed"
    skipped_items+=("Storage")
  fi
}

fix_Repository() {
  print_warn "Repository cannot be auto-fixed"
  print_info "Suggested command: termux-change-repo"
  skipped_items+=("Repository")
}

fix_NodeJS() {
  read -rp "Install NodeJS now? [y/N]: " ans
  [[ "$ans" =~ ^[Yy]$ ]] || {
    print_skip "NodeJS skipped"
    skipped_items+=("NodeJS")
    return
  }

  if pkg install -y nodejs; then
    print_ok "NodeJS installed"
    fixed_items+=("NodeJS")
  else
    print_err "NodeJS installation failed"
    skipped_items+=("NodeJS")
  fi
}

fix_Python() {
  print_warn "Python requires manual review"
  print_info "Suggested command: pkg reinstall python"
  skipped_items+=("Python")
}

fix_Git() {
  print_warn "Git requires manual review"
  print_info "Suggested command: pkg install git"
  skipped_items+=("Git")
}

fix_TermuxVersion() {
  print_info "Termux version cannot be fixed by TDOC"
  skipped_items+=("TermuxVersion")
}

# ---------- DISPATCH ----------
while IFS='=' read -r key value; do
  [[ -z "$key" || "$value" == "OK" ]] && continue

  handler="fix_$key"

  echo
  print_info "Issue detected: $key"

  if declare -f "$handler" >/dev/null; then
    "$handler"
  else
    print_skip "No fix handler for $key"
    skipped_items+=("$key")
  fi
done < "$STATE_FILE"

# ---------- REPORT ----------
report_append_manual "${fixed_items[@]}" --skipped "${skipped_items[@]}"

echo
print_ok "Fix process completed"
print_info "Run: tdoc status"
