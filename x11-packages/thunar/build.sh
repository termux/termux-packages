TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/thunar/start
TERMUX_PKG_DESCRIPTION="Modern file manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.2
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/xfce/thunar/-/archive/thunar-${TERMUX_PKG_VERSION}/thunar-thunar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0c816a16d62fa3d6325543e05df42e022a1620d9a5152264abe50498fc9ed86c
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, libexif, libnotify, libpng, libxfce4ui, libxfce4util"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-maintainer-mode"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
