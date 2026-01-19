#!/usr/bin/env bash

# ==============================
# TDOC UI ENGINE
# ==============================

# ===== Colors =====
RESET="\e[0m"
BOLD="\e[1m"
DIM="\e[2m"

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
GRAY="\e[90m"

# ===== Icons =====
ICON_OK="✔"
ICON_WARN="⚠"
ICON_SKIP="↪"
ICON_ERR="✖"
ICON_INFO="ℹ"

# ===== Spinner Engine =====
_SPINNER_PID=""
_SPINNER_MSG=""
_SPINNER_FRAMES=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
_SPINNER_DELAY=0.1

_spinner_loop() {
  local i=0
  while true; do
    printf "\r${CYAN}%s ${GRAY}%s${RESET}" "$_SPINNER_MSG" "${_SPINNER_FRAMES[i]}"
    i=$(( (i + 1) % ${#_SPINNER_FRAMES[@]} ))
    sleep "$_SPINNER_DELAY"
  done
}

spinner_start() {
  spinner_stop
  _SPINNER_MSG="$1"
  _spinner_loop &
  _SPINNER_PID=$!
  disown
}

spinner_update() {
  _SPINNER_MSG="$1"
}

spinner_stop() {
  if [ -n "$_SPINNER_PID" ] && kill -0 "$_SPINNER_PID" 2>/dev/null; then
    kill "$_SPINNER_PID" >/dev/null 2>&1
    wait "$_SPINNER_PID" 2>/dev/null
    _SPINNER_PID=""
    printf "\r\033[K"
  fi
}

# ===== Progress Bar =====
progress_bar() {
  local current=$1
  local total=$2
  local width=24

  [ "$total" -eq 0 ] && return

  local percent=$(( current * 100 / total ))
  local filled=$(( percent * width / 100 ))
  local empty=$(( width - filled ))

  printf "${BLUE}["
  printf "%0.s█" $(seq 1 "$filled")
  printf "%0.s░" $(seq 1 "$empty")
  printf "]${RESET} %3d%%\n" "$percent"
}

# ===== UI Printers =====
print_header() {
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${BOLD}${CYAN}$1${RESET}"
  echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

print_ok() {
  spinner_stop
  echo -e "${GREEN}${ICON_OK} $1${RESET}"
}

print_warn() {
  spinner_stop
  echo -e "${YELLOW}${ICON_WARN} $1${RESET}"
}

print_err() {
  spinner_stop
  echo -e "${RED}${ICON_ERR} $1${RESET}"
}

print_info() {
  echo -e "${DIM}${ICON_INFO} $1${RESET}"
}

print_skip() {
  echo -e "${GRAY}${ICON_SKIP} $1${RESET}"
}
