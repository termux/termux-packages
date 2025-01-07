TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Text-based multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# please sync version and patches with x11-packages/pidgin
TERMUX_PKG_VERSION="2.14.13"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pidgin/pidgin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=120049dc8e17e09a2a7d256aff2191ff8491abb840c8c7eb319a161e2df16ba8
TERMUX_PKG_DEPENDS="glib, libgnt, libgnutls, libidn, libsasl, libxml2, ncurses"
TERMUX_PKG_BREAKS="finch-dev"
TERMUX_PKG_REPLACES="finch-dev"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-avahi
--disable-dbus
--disable-gstreamer
--disable-gtkui
--disable-idn
--disable-meanwhile
--disable-perl
--disable-tcl
--disable-vv
--with-ncurses-headers=$TERMUX_PREFIX/include
--without-python3
--without-zephyr
"
TERMUX_PKG_RM_AFTER_INSTALL="
share/sounds/purple
"

termux_step_pre_configure() {
	# link-with-libpurple.patch resolves "dlopen failed: cannot locate symbol"
	# issues but this error is present on other distro so unlikely a problem:
	# lib/purple-2/libjabber.so is not usable because the 'purple_init_plugin' symbol could not be found. Does the plugin call the PURPLE_INIT_PLUGIN() macro?
	autoreconf -vfi
}

termux_step_post_make_install() {
	# plugins: usr/lib/purple-2/libxmpp.so is not loadable: dlopen failed: library "libjabber.so" not found
	cd $TERMUX_PREFIX/lib
	for lib in jabber; do
		[[ ! -f purple-2/lib${lib}.so ]] && continue
		ln -fsv purple-2/lib${lib}.so .
	done
}
