TERMUX_PKG_HOMEPAGE=https://github.com/AyatanaIndicators/ayatana-ido
TERMUX_PKG_DESCRIPTION="Ayatana Indicator Display Objects"
TERMUX_PKG_LICENSE="LGPL-2.1, LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.3"
TERMUX_PKG_SRCURL=https://github.com/AyatanaIndicators/ayatana-ido/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45580033e9b52185c41ce500c68281ae724e7e5a553425685c0b89ffcd9cda66
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_TESTS=OFF
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
}
