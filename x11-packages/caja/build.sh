TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="The file manager for the MATE desktop"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24.1
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/caja/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=652244206b4f67df9b70d008c499d7f38c60741452a80bcc7a9f2b49cbd51e52
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libexif, libice, libnotify, libsm, libx11, libxml2, mate-desktop, pango"
TERMUX_PKG_BUILD_DEPENDS="mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-xmp
--disable-packagekit
--disable-schemas-compile
--disable-introspection
--disable-update-mimedb
--disable-icon-update
"

termux_step_pre_configure() {
	NOCONFIGURE=1 ACLOCAL_FLAGS="-I $TERMUX_PREFIX/share/aclocal" \
		sh $TERMUX_PREFIX/bin/mate-autogen
}
