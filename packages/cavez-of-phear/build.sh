TERMUX_PKG_HOMEPAGE=https://github.com/AMDmi3/cavezofphear
TERMUX_PKG_DESCRIPTION="A Boulder Dash like game for consoles/terminals"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Dmitry Marakasov <amdmi3@amdmi3.ru>"
TERMUX_PKG_VERSION=0.5.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/AMDmi3/cavezofphear/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=428ba84db4e43d4f258e912882fdb3ca6c8844447099b60cde8199e76169f439
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DSYSTEMWIDE=ON"
