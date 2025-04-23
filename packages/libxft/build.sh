# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="FreeType-based font drawing library for X"
TERMUX_PKG_LICENSE="HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.9"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXft-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=60a25b78945ed6932635b3bb1899a517d31df7456e69867ffba27f89ff3976f5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, libx11, libxrender"
