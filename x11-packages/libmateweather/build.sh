TERMUX_PKG_HOMEPAGE=https://libmateweather.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="libmateweather is a libgnomeweather fork."
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.2"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/libmateweather/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d81e65e2bddd22edffe42a2c8748321d6f7ad2da1bce2f9c275d88c567ec29eb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libsoup, libxml2, pango, zlib"

termux_step_pre_configure() {
	autoreconf -fiv
}
