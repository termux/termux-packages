TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libsecret
TERMUX_PKG_DESCRIPTION="A GObject-based library for accessing the Secret Service API"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
_MAJOR_VERSION=0.20
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.5
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libsecret/${_MAJOR_VERSION}/libsecret-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3fb3ce340fcd7db54d87c893e69bfc2b1f6e4d4b279065ffe66dac9f0fd12b4d
TERMUX_PKG_DEPENDS="gobject-introspection, libgcrypt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="-Dintrospection=false -Dgtk_doc=false"
