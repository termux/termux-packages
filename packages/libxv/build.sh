TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Library for the X Video (Xv) extension to the X Window System"
TERMUX_PKG_LICENSE="HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.13"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7d34910958e1c1f8d193d828fea1b7da192297280a35437af0692f003ba03755
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--enable-malloc0returnsnull
"
