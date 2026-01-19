#!/usr/bin/env bash
# ==============================
# TDOC — Doctor JSON Output (Final)
# ==============================

STATE_FILE="$TDOC_ROOT/data/state.env"

# Load version info
source "$TDOC_ROOT/core/version.sh"

# Function: escape JSON special chars
escape_json() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\n/\\n/g'
}

# Function: get Termux version
get_termux_version() {
    if command -v termux-info >/dev/null 2>&1; then
        termux-info | grep -i "Version" | awk '{print $2}' || echo "unknown"
    else
        echo "unknown"
    fi
}

# Function: get Git branch & commit
get_git_info() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        commit=$(git rev-parse HEAD 2>/dev/null)
        echo "{\"branch\":\"$branch\",\"commit\":\"$commit\"}"
    else
        echo "{}"
    fi
}

# --- Check STATE_FILE exists ---
if [ ! -f "$STATE_FILE" ]; then
    cat <<EOF
{
  "tool": "$TDOC_NAME",
  "version": "$TDOC_VERSION",
  "codename": "$TDOC_CODENAME",
  "build_date": "$TDOC_BUILD_DATE",
  "mode": "doctor",
  "error": "state_not_found",
  "hint": "run tdoc status"
}
EOF
    exit 1
fi

# --- Build JSON ---
ok=0
broken=0
json_system=""

while IFS='=' read -r key value; do
    [ -z "$key" ] && continue
    key_lc=$(echo "$key" | tr 'A-Z' 'a-z')
    json_system+="\"$key_lc\":\"$(escape_json "$value")\","

    if [ "$value" = "OK" ]; then
        ok=$((ok + 1))
    else
        broken=$((broken + 1))
    fi
done < "$STATE_FILE"

# Remove trailing comma
json_system="${json_system%,}"

TERMUX_VERSION=$(get_termux_version)
GIT_INFO=$(get_git_info)

cat <<EOF
{
  "tool": "$TDOC_NAME",
  "version": "$TDOC_VERSION",
  "codename": "$TDOC_CODENAME",
  "build_date": "$TDOC_BUILD_DATE",
  "mode": "doctor",
  "termux_version": "$TERMUX_VERSION",
  "git": $GIT_INFO,
  "generated_at": "$(date -Iseconds)",
  "system": {
    $json_system
  },
  "summary": {
    "ok": $ok,
    "broken": $broken
  }
}
EOF
