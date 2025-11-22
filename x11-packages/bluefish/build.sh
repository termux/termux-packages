TERMUX_PKG_HOMEPAGE=https://bluefish.openoffice.nl/
TERMUX_PKG_DESCRIPTION="A powerful editor targeted towards programmers and webdevelopers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.19"
TERMUX_PKG_SRCURL=https://www.bennewitz.com/bluefish/stable/source/bluefish-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b574c7c12897ddcef73f199fafa1f98bfc366ac76f0abe7f97a7a62c807f92ae
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
