#!/bin/sh
set -e

# Emscripten Test Suite
# https://emscripten.org/docs/getting_started/test-suite.html
# https://github.com/emscripten-core/emscripten/pull/13493
# https://github.com/emscripten-core/emscripten/issues/9098

pkg install -y emscripten-tests-third-party
pkg install -y cmake libxml2 libxslt ndk-sysroot openjdk-17 python-lxml python-numpy python-pip
cd ${PREFIX}/opt/emscripten
sed -e "s|^lxml.*|lxml|g" -i requirements-dev.txt
CFLAGS="-Wno-implicit-function-declaration" MATHLIB="m" pip install -r requirements-dev.txt
npm install --omit=optional
export EMTEST_SKIP_V8=1
test/runner core0 skip:core0.test_bigswitch
