TERMUX_PKG_HOMEPAGE=https://github.com/AMDmi3/cavezofphear
TERMUX_PKG_DESCRIPTION="A Boulder Dash like game for consoles/terminals"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Dmitry Marakasov <amdmi3@amdmi3.ru>"
TERMUX_PKG_VERSION=0.6.1
TERMUX_PKG_SRCURL=https://github.com/AMDmi3/cavezofphear/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=29ea76dd1a0f38904cd09e36b7205d4a4c01324d2ba28d03f15d9ae53881aa10
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DSYSTEMWIDE=ON -DWITH_MANPAGE=OFF"
