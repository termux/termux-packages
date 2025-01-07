TERMUX_PKG_HOMEPAGE=https://github.com/KeithDHedger/Xfce-Theme-Manager
TERMUX_PKG_DESCRIPTION="Integrated theme manager for xfce4"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:0.3.9"
TERMUX_PKG_SRCURL=https://github.com/KeithDHedger/Xfce-Theme-Manager/archive/refs/tags/v${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=3637984378e7b2a40232809dd0cd116ba8b7090dc47f411cbed3c6ef2b271d44
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk2, libcairo, libxcursor, xfconf"
TERMUX_PKG_BUILD_DEPENDS="libxfce4ui"
TERMUX_PKG_RECOMMENDS="unzip"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# https://github.com/KeithDHedger/Xfce-Theme-Manager/blob/master/autogen.sh
	autoupdate
	aclocal
	autoheader
	automake --add-missing --copy
	autoconf
}
