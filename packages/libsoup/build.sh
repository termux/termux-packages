TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_VERSION=2.62.0
TERMUX_PKG_SHA256=ab7c7ae8d19d0a27ab3b6ae21599cec8c7f7b773b3f2b1090c5daf178373aaac
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libsoup/${TERMUX_PKG_VERSION:0:4}/libsoup-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-vala --without-gssapi"
TERMUX_PKG_DEPENDS="glib, libsqlite, libxml2"
