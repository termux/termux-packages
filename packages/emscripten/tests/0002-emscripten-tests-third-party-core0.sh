#!/bin/sh
# Emscripten Test Suite
# https://emscripten.org/docs/getting_started/test-suite.html
# https://github.com/emscripten-core/emscripten/pull/13493
# https://github.com/emscripten-core/emscripten/issues/9098
set -e

echo "INFO: This is a long compile test. Skipping."
exit

#pkg install -y emscripten-tests-third-party
pkg install -y cmake libxml2 libxslt ndk-sysroot openjdk-25 python-cryptography python-lxml python-numpy python-pip python-psutil python-ruff rust

export PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
cd "${PREFIX}/opt/emscripten"

sed \
	-e "s|^psutil==|psutil>=|" \
	-e "s|^ruff==|ruff>=|" \
	-i requirements-dev.txt
export ANDROID_API_LEVEL=24
#export CARGO_BUILD_TARGET=$(rustc -Vv | grep "host" | awk '{print $2}')
export CFLAGS="-Wno-implicit-function-declaration"
export MATHLIB="m"
pip install -r requirements-dev.txt
npm install --omit=optional

export EMTEST_SKIP_V8=1
test/runner core0 skip:core0.test_bigswitch
