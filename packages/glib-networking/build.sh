TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/glib-networking
TERMUX_PKG_DESCRIPTION="Network-related giomodules for glib"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.76
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib-networking/${_MAJOR_VERSION}/glib-networking-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c698a9994dde51efdfb1026a56698a221d6250e89dc50ebcddda7b81480a42b
TERMUX_PKG_DEPENDS="glib, libgnutls"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denvironment_proxy=enabled
-Dlibproxy=disabled
-Dgnome_proxy=disabled
"
