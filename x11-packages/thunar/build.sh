TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/thunar/start
TERMUX_PKG_DESCRIPTION="Modern file manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.16.6
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/xfce/thunar/-/archive/thunar-${TERMUX_PKG_VERSION}/thunar-thunar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b28c465e3d91b1a2909beb3928de84d40bd05698ac74056fad0e7ddd47856780
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, libexif, libnotify, libpng, libxfce4ui, libxfce4util"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-maintainer-mode"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
