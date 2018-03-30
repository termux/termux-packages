TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
TERMUX_PKG_VERSION=3.11.0
TERMUX_PKG_SHA256=c313bee371d4d255be2b4e96fd59b11d58bc550a7c78c021444ae565709a656b
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${TERMUX_PKG_VERSION:0:4}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, librhash, make, clang"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON"

