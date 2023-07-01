TERMUX_PKG_HOMEPAGE=http://taglib.github.io/
TERMUX_PKG_DESCRIPTION="A Library for reading and editing the meta-data of several popular audio formats."
# License: LGPL-2.1, MPL-1.1
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING.LGPL, COPYING.MPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.13.1
TERMUX_PKG_SRCURL=https://github.com/taglib/taglib/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c8da2b10f1bfec2cd7dbfcd33f4a2338db0765d851a50583d410bacf055cfd0b
TERMUX_PKG_DEPENDS="libc++, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_BREAKS="taglib-dev"
TERMUX_PKG_REPLACES="taglib-dev"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/taglib-config"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DWITH_MP4=ON
-DWITH_ASF=ON"
