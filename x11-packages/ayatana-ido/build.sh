TERMUX_PKG_HOMEPAGE=https://github.com/AyatanaIndicators/ayatana-ido
TERMUX_PKG_DESCRIPTION="Ayatana Indicator Display Objects"
TERMUX_PKG_LICENSE="LGPL-2.1, LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.3
TERMUX_PKG_SRCURL=https://github.com/AyatanaIndicators/ayatana-ido/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4df0a21dde4f6e41d2738c7944d1169836d844e5b65364d1897e93766fa93d58
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_TESTS=OFF
"

termux_step_pre_configure() {
	termux_setup_gir
}
