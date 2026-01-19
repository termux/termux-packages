#!/usr/bin/env bash
# ==============================
# TDOC — Fix Handlers (Compliant)
# ==============================

source "$TDOC_ROOT/core/ui.sh"

auto_fix_storage() {
  read -rp "Run auto-fix for Storage? [y/N]: " CONFIRM
  [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]] && { print_skip "Storage skipped"; return; }
  spinner_start "Fixing Storage access"
  termux-setup-storage
  spinner_stop
  print_ok "Storage access ensured"
}

auto_fix_repository() {
  read -rp "Run auto-fix for Repository? [y/N]: " CONFIRM
  [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]] && { print_skip "Repository skipped"; return; }
  spinner_start "Repairing repository"
  termux-change-repo
  spinner_stop
  print_ok "Repository updated"
}

auto_fix_nodejs() {
  read -rp "Run auto-fix for NodeJS? [y/N]: " CONFIRM
  [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]] && { print_skip "NodeJS skipped"; return; }
  spinner_start "Installing NodeJS"
  pkg install nodejs
  spinner_stop
  print_ok "NodeJS installed"
}

auto_fix_python() {
  print_warn "Python requires manual fix"
  print_info "Suggested: pkg reinstall python"
}

auto_fix_git() {
  print_warn "Git requires manual fix"
  print_info "Suggested: pkg install git && git pull"
}

auto_fix_termux_version() {
  print_warn "TermuxVersion requires manual inspection"
}
