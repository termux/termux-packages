TERMUX_PKG_HOMEPAGE=https://pidgin.im/
TERMUX_PKG_DESCRIPTION="Multi-protocol instant messaging client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# please sync version and patches with packages/finch
TERMUX_PKG_VERSION="2.14.14"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/pidgin/pidgin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0ffc9994def10260f98a55cd132deefa8dc4a9835451cc0e982747bd458e2356
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, dbus, dbus-glib, fontconfig, freetype, gdk-pixbuf, glib, gst-plugins-base, gstreamer, gtk2, harfbuzz, libcairo, libgnt, libgnutls, libice, libidn, libsasl, libsm, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxml2, libxrandr, libxrender, libxss, ncurses, pango, tcl, tk"
TERMUX_PKG_CONFLICTS="finch"
TERMUX_PKG_REPLACES="finch"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-avahi
--disable-gevolution
--disable-gtkspell
--disable-meanwhile
--disable-perl
--disable-nm
--disable-vv
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
