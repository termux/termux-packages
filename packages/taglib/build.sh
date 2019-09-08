TERMUX_PKG_HOMEPAGE=http://taglib.github.io/
TERMUX_PKG_DESCRIPTION="A Library for reading and editing the meta-data of several popular audio formats."
TERMUX_PKG_LICENSE="LGPL-2.0, MPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.11.1
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=http://taglib.github.io/releases/taglib-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b6d1a5a610aae6ff39d93de5efd0fdc787aa9e9dc1e7026fa4c961b26563526b
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_DEPENDS="boost"
TERMUX_PKG_BREAKS="taglib-dev"
TERMUX_PKG_REPLACES="taglib-dev"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/taglib-config"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DWITH_MP4=ON
-DWITH_ASF=ON"
