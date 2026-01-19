#!/usr/bin/env bash

# ==============================
# TDOC Repository Handler
# ==============================

detect_repository() {
  local LOG
  LOG="$(apt update 2>&1)"

  if echo "$LOG" | grep -qiE "404|Release file|NO_PUBKEY|failed|temporary failure"; then
    echo "BROKEN"
    return
  fi

  if ! grep -q "packages.termux.dev" "$PREFIX/etc/apt/sources.list" 2>/dev/null; then
    echo "PARTIAL"
    return
  fi

  echo "OK"
}

fix_repository() {
  echo -e "\033[33m🔧 Fixing Termux repository...\033[0m"
  termux-change-repo
}
