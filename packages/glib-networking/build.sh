TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/glib-networking
TERMUX_PKG_DESCRIPTION="Network-related giomodules for glib"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.80.0"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib-networking/${TERMUX_PKG_VERSION%.*}/glib-networking-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d8f4f1aab213179ae3351617b59dab5de6bcc9e785021eee178998ebd4bb3acf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libgnutls"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denvironment_proxy=enabled
-Dlibproxy=disabled
-Dgnome_proxy=disabled
"
