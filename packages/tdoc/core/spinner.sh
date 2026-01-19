#!/usr/bin/env bash

# ==============================
# TDOC Spinner Engine
# ==============================

SPINNER_PID=""
SPINNER_MSG=""
SPINNER_FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
SPINNER_DELAY=0.1

spinner_loop() {
  local i=0
  while true; do
    printf "\r\033[36m%s\033[0m %s" "${SPINNER_FRAMES[i]}" "$SPINNER_MSG"
    i=$(( (i + 1) % ${#SPINNER_FRAMES[@]} ))
    sleep "$SPINNER_DELAY"
  done
}

spinner_start() {
  SPINNER_MSG="$1"
  spinner_loop &
  SPINNER_PID=$!
  disown
}

spinner_update() {
  SPINNER_MSG="$1"
}

spinner_stop() {
  if [ -n "$SPINNER_PID" ]; then
    kill "$SPINNER_PID" >/dev/null 2>&1
    wait "$SPINNER_PID" 2>/dev/null
    SPINNER_PID=""
    printf "\r\033[K"
  fi
}
