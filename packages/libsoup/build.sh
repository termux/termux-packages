TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/action/show/Projects/libsoup
TERMUX_PKG_DESCRIPTION="HTTP client and server library"
TERMUX_PKG_VERSION=2.60.1
TERMUX_PKG_SHA256=023930032b20e6b14764feb847ea80d9e170622dee7370215d6feb9967b6aa9d
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libsoup/${TERMUX_PKG_VERSION:0:4}/libsoup-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-vala --without-gssapi"
TERMUX_PKG_DEPENDS="glib, libsqlite, libxml2"
