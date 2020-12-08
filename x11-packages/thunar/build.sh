TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/thunar/start
TERMUX_PKG_DESCRIPTION="Modern file manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/xfce/thunar/-/archive/thunar-${TERMUX_PKG_VERSION}/thunar-thunar-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=65f5ea5a689c2c5b57bf47c36028286e92159f7fed8da22c25c1a1c165075dc7
TERMUX_PKG_DEPENDS="desktop-file-utils, exo, hicolor-icon-theme, libexif, libnotify, libpng, libxfce4ui, libxfce4util"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-maintainer-mode"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
