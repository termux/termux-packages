#!/bin/sh
set -e

# Emscripten Test Suite
# https://emscripten.org/docs/getting_started/test-suite.html
# https://github.com/emscripten-core/emscripten/pull/13493
# https://github.com/emscripten-core/emscripten/issues/9098

[ $([ "${TERMUX_APP_PACKAGE_MANAGER-}" = "apt" ] && echo "debian" || echo "${TERMUX_APP_PACKAGE_MANAGER-}") == "pacman" ] && (
     pacman -Syy emscripten-tests-third-party --noconfirm
     pacman -Syy cmake libxml2 libxslt ndk-sysroot openjdk-22 python-lxml python-numpy python-ensurepip --noconfirm
) || ([ $([ "${TERMUX_APP_PACKAGE_MANAGER-}" = "apt" ] && echo "debian" || echo "${TERMUX_APP_PACKAGE_MANAGER-}") == "apt" ] && (
     apt --fix-missing --fix-broken install emscripten-tests-third-party --yes
     apt --fix-missing --fix-broken install cmake libxml2 libxslt ndk-sysroot openjdk-22 python-lxml python-numpy python-ensurepip --yes
) || return ) || ([ $([ "${TERMUX_APP_PACKAGE_MANAGER-}" = "apt" ] && echo "debian" || echo "${TERMUX_APP_PACKAGE_MANAGER-}") != "pacman" || $([ "${TERMUX_APP_PACKAGE_MANAGER-}" = "apt" ] && echo "debian" || echo "${TERMUX_APP_PACKAGE_MANAGER-}") != "apt" ] && (
     trap "printf '%s\n' (
         'Unsupported package format \"${TERMUX_PACKAGE_FORMAT-}\". Only \"debian\" and \"pacman\" formats are supported.'; exit 1
     )" TERM ERR
) || return) || shift

env EMTEST_SKIP_V8=1 bash -c '(cd ${PREFIX}/opt/emscripten
sed -e "s|^lxml.*|lxml|g" -i requirements-dev.txt
CFLAGS="-Wno-implicit-function-declaration" MATHLIB="m" pip install -r requirements-dev.txt
npm install --omit=optional
test/runner core0 skip:core0.test_bigswitch)'

