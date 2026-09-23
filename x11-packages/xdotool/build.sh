TERMUX_PKG_HOMEPAGE=https://github.com/jordansissel/xdotool
TERMUX_PKG_DESCRIPTION="simulate (generate) X11 keyboard/mouse input events"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.20251130.1
TERMUX_PKG_SRCURL=https://github.com/jordansissel/xdotool/releases/download/v${TERMUX_PKG_VERSION}/xdotool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eee789b00d6a13d47b31bbc139727e6408c21b5f6ba5e804fdf6ecfb8c781356
TERMUX_PKG_DEPENDS="libx11, libxtst, libxinerama, libxkbcommon"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
INSTALLMAN=$TERMUX_PREFIX/share/man
"
