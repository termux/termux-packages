TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="The file manager for the MATE desktop"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.26
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://pub.mate-desktop.org/releases/${_MAJOR_VERSION}/caja-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=30fd6e6f00a38200f6e2e898ad7fa797876bb060f1d0341dd2f7393279e14c07
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libexif, libice, libnotify, libsm, libx11, libxml2, mate-desktop, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-xmp
--disable-packagekit
--disable-schemas-compile
--enable-introspection
--disable-update-mimedb
--disable-icon-update
"

termux_step_pre_configure() {
	termux_setup_gir
}
