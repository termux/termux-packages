TERMUX_PKG_HOMEPAGE=https://github.com/lanoxx/tilda
TERMUX_PKG_DESCRIPTION="A Gtk based drop down terminal for Linux and Unix."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL=https://github.com/lanoxx/tilda/archive/refs/tags/tilda-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ff9364244c58507cd4073ac22e580a4cded048d416c682496c1b1788ee8a30df
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libconfuse, libvte, libx11, pango"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
