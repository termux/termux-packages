TERMUX_PKG_HOMEPAGE=https://github.com/AyatanaIndicators/libayatana-appindicator
TERMUX_PKG_DESCRIPTION="Ayatana Application Indicators"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-2.1, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.92
TERMUX_PKG_SRCURL=https://github.com/AyatanaIndicators/libayatana-appindicator/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=adedcf160dae7547971d475b42062cab278d54ec075537e6958ffdbf2d996857
TERMUX_PKG_DEPENDS="glib, gtk3, libayatana-indicator, libdbusmenu, libdbusmenu-gtk3"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_BINDINGS_MONO=OFF
"

termux_step_pre_configure() {
	termux_setup_gir
}
