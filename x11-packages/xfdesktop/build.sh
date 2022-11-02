TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="A desktop manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.1
TERMUX_PKG_SRCURL=https://gitlab.xfce.org/xfce/xfdesktop/-/archive/xfdesktop-${TERMUX_PKG_VERSION}/xfdesktop-xfdesktop-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d5a70c23ca599a69cd15d4a353d5195b1bde2386a754f7f11a0c7dd058022908
TERMUX_PKG_DEPENDS="exo, garcon, gdk-pixbuf, glib, gtk3, libcairo, libnotify, libwnck, libx11, libxfce4ui, libxfce4util, pango, thunar, xfconf"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-notifications --enable-maintainer-mode"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
