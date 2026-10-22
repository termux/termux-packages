TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="The file manager for the MATE desktop"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.1"
TERMUX_PKG_REVISION=1
# https://pub.mate-desktop.org/releases/${TERMUX_PKG_VERSION%.*}/caja-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/caja/releases/download/v${TERMUX_PKG_VERSION}/caja-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=ff2e1cbc7cf0d3e2762b9c156f4e7039e8c0f3cdcb2a1794375b590597b6fb8b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libexif, libexempi, libice, libnotify, libsm, libx11, libxml2, mate-desktop, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-packagekit
--disable-schemas-compile
--enable-introspection
--disable-update-mimedb
--disable-icon-update
"

termux_step_pre_configure() {
	termux_setup_gir
}
