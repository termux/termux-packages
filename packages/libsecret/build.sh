TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/libsecret/
TERMUX_PKG_DESCRIPTION="A GObject-based library for accessing the Secret Service API"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION=0.20.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/libsecret/-/archive/$TERMUX_PKG_VERSION/libsecret-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ca34e69b210df221ae5da6692c2cb15ef169bb4daf42e204442f24fdb0520d4b
TERMUX_PKG_DEPENDS="gobject-introspection, libgcrypt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Dintrospection=false -Dgtk_doc=false"
