TERMUX_PKG_HOMEPAGE=https://github.com/any1/neatvnc
TERMUX_PKG_DESCRIPTION="A liberally licensed VNC server library with a clean interface"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_SRCURL=https://github.com/any1/neatvnc/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=08951a8c026eda41c6b818447724b0cacf137a9b8cd27f79febe15b222b9f0fd
TERMUX_PKG_DEPENDS="libaml, libdrm, libgmp, libgnutls, libjpeg-turbo, libnettle, libpixman, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Djpeg=enabled
-Dtls=enabled
-Dnettle=enabled
-Dgbm=disabled
"
