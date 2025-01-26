TERMUX_PKG_HOMEPAGE=https://github.com/lite-xl/lite-xl
TERMUX_PKG_DESCRIPTION="A lightweight text editor written in Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.7"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/lite-xl/lite-xl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=69d1ce4c1d148d382ccb06f45feca2565c5c8fe9d0b1b9bc1cbe014f6826ce6b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, liblua54, pcre2, sdl2 | sdl2-compat"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Duse_system_lua=true
"
