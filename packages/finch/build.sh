TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Text-based multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.13.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=2747150c6f711146bddd333c496870bfd55058bab22ffb7e4eb784018ec46d8f
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/pidgin/Pidgin/${TERMUX_PKG_VERSION}/pidgin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="libiconv, libgnutls, libxml2, ncurses-ui-libs, glib"
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
--without-python
"
TERMUX_PKG_RM_AFTER_INSTALL="share/sounds/purple lib/purple-2/libmsn.so"

termux_step_pre_configure() {
	# For arpa:
	CFLAGS+=" -isystem $TERMUX_PKG_BUILDER_DIR"
	export LIBS="-ltinfow"
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
