TERMUX_PKG_HOMEPAGE=https://bluefish.openoffice.nl/
TERMUX_PKG_DESCRIPTION="A powerful editor targeted towards programmers and webdevelopers"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.12
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://www.bennewitz.com/bluefish/stable/source/bluefish-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=0df9905ba2c601cd767fa53e147969e9c90bc0cc4c005c4011c150b248979e6a
TERMUX_PKG_DEPENDS="atk, enchant, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libxml2, pango, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-xml-catalog-update
--disable-update-databases
--disable-python
"
