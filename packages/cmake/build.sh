TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# When updating version here, please update termux_setup_cmake.sh as well.
TERMUX_PKG_VERSION=3.21.1
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${TERMUX_PKG_VERSION:0:4}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fac3915171d4dff25913975d712f76e69aef44bf738ba7b976793a458b4cfed4
TERMUX_PKG_DEPENDS="libarchive, libc++, libcurl, libexpat, jsoncpp, libuv, rhash, make, clang, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON -DBUILD_CursesDialog=ON"
