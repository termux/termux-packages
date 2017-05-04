TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
_MAJOR_VERSION=3.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${_MAJOR_VERSION}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ce5d9161396e06501b00e52933783150a87c33080d4bdcef461b5b7fd24ac228
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, librhash"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON"

