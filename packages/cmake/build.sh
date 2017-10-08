TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
TERMUX_PKG_VERSION=3.9.4
TERMUX_PKG_SHA256=b5d86f12ae0072db520fdbdad67405f799eb728b610ed66043c20a92b4906ca1
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${TERMUX_PKG_VERSION:0:3}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, librhash, make, clang"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON"

