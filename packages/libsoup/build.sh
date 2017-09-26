TERMUX_PKG_HOMEPAGE="https://wiki.gnome.org/action/show/Projects/libsoup"
TERMUX_PKG_DESCRIPTION="libsoup is an HTTP client/server library for GNOME"
TERMUX_PKG_VERSION=2.58.2
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/libsoup/${TERMUX_PKG_VERSION:0:4}/libsoup-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=442300ca1b1bf8a3bbf2f788203287ff862542d4fc048f19a92a068a27d17b72
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-vala --without-gssapi"
TERMUX_PKG_DEPENDS="glib, libsqlite, libxml2"
