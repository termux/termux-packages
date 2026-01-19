#!/usr/bin/env bash
#
# TDOC — Initialization (Bootstrap)
#

set -o errexit
set -o pipefail

# Prevent multiple sourcing
[[ -n "${TDOC_INIT_DONE:-}" ]] && return 0
export TDOC_INIT_DONE=1

# Root
export TDOC_ROOT="${TDOC_ROOT:-$PREFIX/lib/tdoc}"

# Sanity check
if [[ ! -d "$TDOC_ROOT/core" ]]; then
  echo "TDOC error: core directory not found" >&2
  return 127
fi

# Load metadata (single source of truth)
# shellcheck source=/dev/null
source "$TDOC_ROOT/core/version.sh"

# ------------------------------
# Version output function
# ------------------------------
tdoc_version_string() {
  echo "${TDOC_NAME:-tdoc} v${TDOC_VERSION}"
  [ -n "${TDOC_CODENAME:-}" ] && echo "Codename  : $TDOC_CODENAME"
  [ -n "${TDOC_BUILD_DATE:-}" ] && echo "Build date: $TDOC_BUILD_DATE"
}

# Load UI helpers (no output!)
# shellcheck source=/dev/null
source "$TDOC_ROOT/core/ui.sh"

# Load explain engine (lazy usage)
# shellcheck source=/dev/null
source "$TDOC_ROOT/core/ai_explain.sh"

return 0
