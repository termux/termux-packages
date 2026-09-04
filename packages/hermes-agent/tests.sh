#!/bin/sh
set -eu

hermes --version | grep -F '0.20.2'
python - <<'PY'
import cryptography
import importlib.metadata
import hermes_cli
import PIL
import psutil
import pydantic
import yaml
assert importlib.metadata.version("hermes-agent") == "0.20.2"
print("Hermes Python imports OK")
PY

test -f "$PREFIX/share/hermes-agent/hermes_cli/web_dist/index.html"
test -f "$PREFIX/share/hermes-agent/ui-tui/dist/entry.js"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT INT TERM
set +e
output="$(HERMES_HOME="$tmp" timeout 30s hermes update --check 2>&1)"
status=$?
set -e
[ "$status" -ne 0 ]
printf '%s\n' "$output" | grep -F 'pkg upgrade hermes-agent'
