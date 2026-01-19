#!/usr/bin/env bash
# ==============================
# TDOC — Report Engine (Shell Only)
# ==============================

REPORT_DIR="$HOME/.tdoc"
REPORT_FILE="$REPORT_DIR/report.json"

mkdir -p "$REPORT_DIR"

# ------------------------------
# Init report file
# ------------------------------
report_init() {
  if [[ ! -f "$REPORT_FILE" ]]; then
    echo "[]" > "$REPORT_FILE"
  fi
}

# ------------------------------
# Internal: escape JSON string
# ------------------------------
_json_escape() {
  echo "$1" | sed \
    -e 's/\\/\\\\/g' \
    -e 's/"/\\"/g'
}

# ------------------------------
# Internal: build JSON array
# ------------------------------
_json_array() {
  local out=""
  for item in "$@"; do
    item=$(_json_escape "$item")
    out+="\"$item\","
  done
  echo "[${out%,}]"
}

# ------------------------------
# Append manual fix report
# Usage:
# report_append_manual fixed1 fixed2 --skipped skip1 skip2
# ------------------------------
report_append_manual() {
  local fixed=()
  local skipped=()
  local mode="manual"
  local target="fixed"

  for arg in "$@"; do
    if [[ "$arg" == "--skipped" ]]; then
      target="skipped"
      continue
    fi

    if [[ "$target" == "fixed" ]]; then
      fixed+=("$arg")
    else
      skipped+=("$arg")
    fi
  done

  _report_write "$mode" fixed skipped
}

# ------------------------------
# Append auto fix report
# ------------------------------
report_append_auto() {
  local fixed=("$@")
  local skipped=()
  _report_write "auto" fixed skipped
}

# ------------------------------
# Core writer (atomic)
# ------------------------------
_report_write() {
  local mode="$1"
  local fixed_var="$2"
  local skipped_var="$3"

  local now
  now="$(date '+%Y-%m-%d %H:%M:%S')"

  local fixed_json
  local skipped_json

  fixed_json=$(_json_array "${!fixed_var[@]}")
  skipped_json=$(_json_array "${!skipped_var[@]}")

  local entry
  entry=$(cat <<EOF
{
  "time": "$now",
  "mode": "$mode",
  "fixed": $fixed_json,
  "skipped": $skipped_json
}
EOF
)

  local tmp
  tmp="$(mktemp)"

  # Remove closing ]
  sed '$d' "$REPORT_FILE" > "$tmp"

  # Add comma if not first entry
  if [[ $(wc -l < "$tmp") -gt 1 ]]; then
    echo "," >> "$tmp"
  fi

  echo "$entry" >> "$tmp"
  echo "]" >> "$tmp"

  mv "$tmp" "$REPORT_FILE"
}
