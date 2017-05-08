TERMUX_PKG_HOMEPAGE="https://wiki.gnome.org/action/show/Projects/libsoup"
TERMUX_PKG_DESCRIPTION="libsoup is an HTTP client/server library for GNOME"
TERMUX_PKG_VERSION=2.58.0
TERMUX_PKG_SRCURL=http://ftp.gnome.org/pub/GNOME/sources/libsoup/2.58/libsoup-2.58.0.tar.xz
TERMUX_PKG_SHA256=b61567e25ed61f4b89bb23a36713c807df6b76a8451beb786d8cc362e8f097f5
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-vala"
TERMUX_PKG_DEPENDS="glib, krb5, libffi, libsqlite"
