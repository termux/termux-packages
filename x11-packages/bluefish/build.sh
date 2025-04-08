TERMUX_PKG_HOMEPAGE=https://bluefish.openoffice.nl/
TERMUX_PKG_DESCRIPTION="A powerful editor targeted towards programmers and webdevelopers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.17"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.bennewitz.com/bluefish/stable/source/bluefish-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=3a79f6425e14939ea134f96c1424e3aac05bee95904be434581883078a7b7253
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
