#!/bin/sh
set -e

python - <<'PY'
import importlib.metadata
import rpds
print(importlib.metadata.version("rpds-py"))
PY
