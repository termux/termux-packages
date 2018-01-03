TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_VERSION=2.61.1
TERMUX_PKG_SHA256=2aa7556b16563279875a525b1dd37b94ac055e01fddf8e4c9695c57e829c6b67
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libsoup/${TERMUX_PKG_VERSION:0:4}/libsoup-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-vala --without-gssapi"
TERMUX_PKG_DEPENDS="glib, libsqlite, libxml2"
