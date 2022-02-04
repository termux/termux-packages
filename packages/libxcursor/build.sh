# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X cursor management library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.0
TERMUX_PKG_REVISION=20
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXcursor-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3ad3e9f8251094af6fe8cb4afcf63e28df504d46bfa5a5529db74a505d628782
TERMUX_PKG_DEPENDS="libx11, libxfixes, libxrender"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
