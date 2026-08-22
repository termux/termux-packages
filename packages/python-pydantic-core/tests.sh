#!/bin/sh
set -e

python - <<'PY'
import importlib.metadata
import pydantic_core
print(importlib.metadata.version("pydantic-core"))
PY
