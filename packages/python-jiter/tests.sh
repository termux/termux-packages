#!/bin/sh
set -e

python - <<'PY'
import importlib.metadata
import jiter
print(importlib.metadata.version("jiter"))
PY
