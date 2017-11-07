TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
TERMUX_PKG_VERSION=3.9.5
TERMUX_PKG_SHA256=6220c1683b4e6bb8f38688fa3ffb17a7cf39f36317c2ddfdc3f12f09d086c166
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${TERMUX_PKG_VERSION:0:3}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, librhash, make, clang"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON"

