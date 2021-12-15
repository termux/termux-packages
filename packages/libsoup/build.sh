TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.70.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libsoup/${TERMUX_PKG_VERSION:0:4}/libsoup-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=54b020f74aefa438918d8e53cff62e2b1e59efe2de53e06b19a4b07b1f4d5342
TERMUX_PKG_DEPENDS="glib, libpsl, libsqlite, libxml2, brotli"
TERMUX_PKG_BREAKS="libsoup-dev"
TERMUX_PKG_REPLACES="libsoup-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=disabled
-Dvapi=disabled
-Dgssapi=disabled
-Dtls_check=false
"
