TERMUX_PKG_HOMEPAGE=https://google.github.io/draco/
TERMUX_PKG_DESCRIPTION="Library for compressing and decompressing 3D geometric meshes and point clouds"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.9"
TERMUX_PKG_SRCURL="https://github.com/google/draco/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=5b84e0e212ccc7b03ace681760a65a66fe2481a5f54df65154cfc8f0cbb87148
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
