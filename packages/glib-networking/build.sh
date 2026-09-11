TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/glib-networking
TERMUX_PKG_DESCRIPTION="Network-related giomodules for glib"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.90.0"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/gnome/sources/glib-networking/${TERMUX_PKG_VERSION%.*}/glib-networking-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=83a75e3d9c36b66ee86d3281c2fc997816101968a5126ba322b2acb9a74dd8c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denvironment_proxy=enabled
-Dgnome_proxy=disabled
-Dgnutls=disabled
-Dlibproxy=disabled
-Dopenssl=enabled
-Dtests=false
"
