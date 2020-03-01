TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.68.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libsoup/${TERMUX_PKG_VERSION:0:4}/libsoup-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=2d50b12922cc516ab6a7c35844d42f9c8a331668bbdf139232743d82582b3294
TERMUX_PKG_DEPENDS="glib, libpsl, libsqlite, libxml2"
TERMUX_PKG_BREAKS="libsoup-dev"
TERMUX_PKG_REPLACES="libsoup-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=disabled
-Dvapi=disabled
-Dgssapi=disabled
-Dtls_check=false
"
