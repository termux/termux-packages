TERMUX_PKG_HOMEPAGE=https://bluefish.openoffice.nl/
TERMUX_PKG_DESCRIPTION="A powerful editor targeted towards programmers and webdevelopers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.18"
TERMUX_PKG_SRCURL=https://www.bennewitz.com/bluefish/stable/source/bluefish-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c5bc69e5154c0bfe2ead5adb8dd9abb8a67185d4f9b1ae2fce7b2094dd8b27bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, enchant, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxml2, pango, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-xml-catalog-update
--disable-update-databases
--disable-python
--disable-gettext
"

termux_step_pre_configure() {
	CFLAGS+=" -fPIC -Dgettext\(a\)=a"
}
