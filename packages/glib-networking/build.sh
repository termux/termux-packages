TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/glib-networking
TERMUX_PKG_DESCRIPTION="Network-related giomodules for glib"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.78.0"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib-networking/${TERMUX_PKG_VERSION%.*}/glib-networking-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=52fe4ce93f7dc51334b102894599858d23c8a65ac4a1110b30920565d68d3aba
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libgnutls"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denvironment_proxy=enabled
-Dlibproxy=disabled
-Dgnome_proxy=disabled
"
