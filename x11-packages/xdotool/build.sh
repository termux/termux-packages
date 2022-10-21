TERMUX_PKG_HOMEPAGE=https://github.com/jordansissel/xdotool
TERMUX_PKG_DESCRIPTION="simulate (generate) X11 keyboard/mouse input events"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.20211022.1
TERMUX_PKG_SRCURL=https://github.com/jordansissel/xdotool/releases/download/v${TERMUX_PKG_VERSION}/xdotool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=96f0facfde6d78eacad35b91b0f46fecd0b35e474c03e00e30da3fdd345f9ada
TERMUX_PKG_DEPENDS="libx11, libxtst, libxinerama, libxkbcommon"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
INSTALLMAN=$TERMUX_PREFIX/share/man
"
