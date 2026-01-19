#!/usr/bin/env bash

# ==============================
# TDOC — Repository Security JSON
# ==============================

# Load version (single source of truth)
source "$TDOC_ROOT/core/version.sh"
# Load repo security scanner
source "$TDOC_ROOT/core/repo_security.sh"

scan_repo_security
# Build JSON arrays safely
json_warn=$(printf '"%s",' "${WARNINGS[@]}" | sed 's/,$//')
json_danger=$(printf '"%s",' "${DANGERS[@]}" | sed 's/,$//')

cat <<EOF
{
  "tool": "$TDOC_NAME",
  "version": "$TDOC_VERSION",
  "codename": "$TDOC_CODENAME",
  "build_date": "$TDOC_BUILD_DATE",
  "mode": "security",
  "generated_at": "$(date -Iseconds)",
  "security": {
    "state": "$SECURITY_STATE",
    "warnings": [ $json_warn ],
    "dangers": [ $json_danger ]
  }
}
EOF
