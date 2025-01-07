TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Inter-Client Exchange library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.2"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libICE-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=974e4ed414225eb3c716985df9709f4da8d22a67a2890066bc6dfc89ad298625
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros, xtrans"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"
