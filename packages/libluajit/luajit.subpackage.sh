TERMUX_SUBPKG_DESCRIPTION="Just-In-Time compiler for Lua - command line tool"
# shellcheck disable=SC2031 # We're getting the minor version out of the build.sh
TERMUX_SUBPKG_INCLUDE="
bin/luajit
share/man/man1
share/luajit-$(. "$TERMUX_SCRIPTDIR/packages/libluajit/build.sh"; echo "${TERMUX_PKG_VERSION:2:3}")/jit
"
