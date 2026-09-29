TERMUX_PKG_HOMEPAGE=https://github.com/jordansissel/xdotool
TERMUX_PKG_DESCRIPTION="simulate (generate) X11 keyboard/mouse input events"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20260303.1"
TERMUX_PKG_SRCURL=https://github.com/jordansissel/xdotool/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c1f971a384da588eb99ca0755fc4300316d49c1e612537e3f1de52215e104fa3
TERMUX_PKG_DEPENDS="libx11, libxtst, libxinerama, libxkbcommon"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
INSTALLMAN=$TERMUX_PREFIX/share/man
"
