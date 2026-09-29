# x11-packages
TERMUX_PKG_HOMEPAGE=https://github.com/midori-browser/core
TERMUX_PKG_DESCRIPTION="A lightweight, fast and free web browser using WebKit and GTK+"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=9.0
TERMUX_PKG_SRCURL=https://github.com/midori-browser/core/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=913a7cba95ddcc3dc5f6b12d861e765d6fa990fe7d4efc3768d3a3567ea460db
TERMUX_PKG_DEPENDS="gcr, gdk-pixbuf, glib, gtk3, json-glib, libarchive, libcairo, libpeas, libsoup, libsqlite, webkit2gtk"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"

termux_step_pre_configure() {
	termux_setup_gir
}
