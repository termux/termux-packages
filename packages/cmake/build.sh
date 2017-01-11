TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
_MAJOR_VERSION=3.7
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${_MAJOR_VERSION}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DZLIB_INCLUDE_DIR=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DZLIB_LIBRARY=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/lib/libz.so -DKWSYS_LFS_WORKS=ON"

