TERMUX_PKG_HOMEPAGE=https://github.com/any1/neatvnc
TERMUX_PKG_DESCRIPTION="A liberally licensed VNC server library with a clean interface"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.5"
TERMUX_PKG_SRCURL=https://github.com/any1/neatvnc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8150a30bfbd350b046680650b52afcce5ae44d328cb396fb571c6f9b99811357
TERMUX_PKG_DEPENDS="libaml, libdrm, libgmp, libgnutls, libjpeg-turbo, libnettle, libpixman, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Djpeg=enabled
-Dtls=enabled
-Dnettle=enabled
-Dgbm=disabled
"
