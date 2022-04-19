TERMUX_PKG_HOMEPAGE=https://github.com/lanoxx/tilda
TERMUX_PKG_DESCRIPTION="A Gtk based drop down terminal for Linux and Unix."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@ELWAER-M"
TERMUX_PKG_VERSION="1.6-alpha"
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/lanoxx/tilda/archive/a8f70a8b9300992dc13185112a251b90850fd96e.tar.gz
TERMUX_PKG_SHA256=83c3bdccd9f41183cf656c11f925cf383f7cf0cbafbd56f51d8a1e2983bb7739
TERMUX_PKG_DEPENDS="glib, gtk3, libvte, libconfuse, libx11, gettext"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
