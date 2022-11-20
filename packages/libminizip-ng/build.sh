TERMUX_PKG_HOMEPAGE=https://github.com/zlib-ng/minizip-ng
TERMUX_PKG_DESCRIPTION="A zip manipulation library written in C"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.7
TERMUX_PKG_SRCURL=https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=39981a0db1bb6da504909bce63d7493286c5e50825c056564544c990d15c55cf
TERMUX_PKG_DEPENDS="libbz2, libiconv, liblzma, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_INCLUDEDIR=include/minizip-ng
-DBUILD_SHARED_LIBS=ON
-DMZ_COMPAT=OFF
"
# ZSTD is disabled only because it breaks build of opencolorio when enabled.
# This may be resolved by building zstd with CMake, but that needs extra care
# such as SONAME change. I just cannot be bothered to do that for now.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DMZ_ZSTD=OFF"
