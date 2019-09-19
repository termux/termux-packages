TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.68.1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libsoup/${TERMUX_PKG_VERSION:0:4}/libsoup-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=7f0323e53b8e797baa972dfe25adf3cc6ceff06f0a26235b6c5c7b91403fbf8d
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dvapi=disabled -Dgssapi=disabled -Dtls_check=false"
TERMUX_PKG_DEPENDS="glib, libpsl, libsqlite, libxml2"
TERMUX_PKG_BREAKS="libsoup-dev"
TERMUX_PKG_REPLACES="libsoup-dev"
