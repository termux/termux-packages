TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Session Management library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libSM-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=be7c0abdb15cbfd29ac62573c1c82e877f9d4047ad15321e7ea97d1e43d835be
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libice, libuuid"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xtrans"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"
