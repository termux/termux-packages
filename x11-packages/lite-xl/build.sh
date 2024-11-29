TERMUX_PKG_HOMEPAGE=https://github.com/lite-xl/lite-xl
TERMUX_PKG_DESCRIPTION="A lightweight text editor written in Lua"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.6"
TERMUX_PKG_SRCURL="https://github.com/lite-xl/lite-xl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=4eee4e4a0480066e85052321408bc624bb83e5efec0cd1b895c51fd4511cb6a1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, liblua54, pcre2, sdl2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Duse_system_lua=true
"
