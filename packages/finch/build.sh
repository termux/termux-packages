TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Text-based multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.14.12
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pidgin/pidgin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2b05246be208605edbb93ae9edc079583d449e2a9710db6d348d17f59020a4b7
TERMUX_PKG_DEPENDS="glib, libgnt, libgnutls, libidn, libsasl, libxml2, ncurses"
TERMUX_PKG_BREAKS="finch-dev"
TERMUX_PKG_REPLACES="finch-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gtkui
--disable-gstreamer
--disable-vv
--disable-idn
--disable-meanwhile
--disable-avahi
--disable-dbus
--disable-perl
--disable-tcl
--without-zephyr
--with-ncurses-headers=$TERMUX_PREFIX/include
--without-python3
"
TERMUX_PKG_RM_AFTER_INSTALL="share/sounds/purple lib/purple-2/libmsn.so"

termux_step_pre_configure() {
	# For arpa:
	CFLAGS+=" -isystem $TERMUX_PKG_BUILDER_DIR"
}

termux_step_post_configure() {
	# Hack to compile first version of libpurple-ciphers.la
	cp $TERMUX_PREFIX/lib/libxml2.so $TERMUX_PREFIX/lib/libpurple.so

	cd $TERMUX_PKG_BUILDDIR/libpurple/ciphers
	make libpurple-ciphers.la
	cd ..
	make libpurple.la

	# Put a more proper version in lib:
	cp .libs/libpurple.so $TERMUX_PREFIX/lib/

	make clean
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	for lib in jabber oscar; do
		ln -f -s purple-2/lib${lib}.so .
	done
}
