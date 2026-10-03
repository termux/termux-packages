TERMUX_PKG_HOMEPAGE=https://github.com/any1/neatvnc
TERMUX_PKG_DESCRIPTION="A liberally licensed VNC server library with a clean interface"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.3"
TERMUX_PKG_SRCURL=https://github.com/any1/neatvnc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7a54d1b950f8898ea4be0f9b0e0d3ab4065812a8f6517707a8e02a384fe9af4a
TERMUX_PKG_DEPENDS="libaml, libdrm, libgmp, libgnutls, libjpeg-turbo, libnettle, libpixman, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Djpeg=enabled
-Dtls=enabled
-Dnettle=enabled
-Dgbm=disabled
"
