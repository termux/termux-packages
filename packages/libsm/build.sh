TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Session Management library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.5"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libSM-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2af9e12da5ef670dc3a7bce1895c9c0f1bfb0cb9e64e8db40fcc33f883bd20bc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libice, libuuid"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xtrans"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"
