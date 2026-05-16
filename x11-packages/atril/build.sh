TERMUX_PKG_HOMEPAGE=https://mate-desktop.org
TERMUX_PKG_DESCRIPTION="MATE document viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.4"
# https://pub.mate-desktop.org/releases/${TERMUX_PKG_VERSION%.*}/atril-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/atril/releases/download/v${TERMUX_PKG_VERSION}/atril-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a6f5fbf0ab4305c1b8162c5d5a1146a669784b00dec69242e04f148de1b79653
TERMUX_PKG_AUTO_UPDATE=true
# links with poppler-glib, not poppler
TERMUX_PKG_DEPENDS="atk, djvulibre, gdk-pixbuf, glib, gtk3, harfbuzz, libarchive, libc++, libcairo, libice, libsecret, libsm, libspectre, libsoup3, libtiff, libxml2, mate-desktop, pango, poppler, texlive-bin, webkit2gtk-4.1, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dcaja=disabled
-Ddjvu=enabled
-Ddvi=enabled
-Depub=enabled
-Dintrospection=true
-Dpixbuf=enabled
"

termux_step_pre_configure() {
	# Workaround strict compiler error
	CFLAGS+=" -Wno-format-security -Wno-format-nonliteral"

	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_gir
}
