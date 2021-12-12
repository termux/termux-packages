TERMUX_PKG_HOMEPAGE=https://gnome.org
TERMUX_PKG_DESCRIPTION="Library for writing single instance applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.6
TERMUX_PKG_REVISION=19
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/libunique/1.1/libunique-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2cb918dde3554228a211925ba6165a661fd782394bd74dfe15e3853dc9c573ea
TERMUX_PKG_DEPENDS="glib, gtk2"

termux_step_pre_configure() {
	export CFLAGS="$CFLAGS -DG_CONST_RETURN=const"
}
