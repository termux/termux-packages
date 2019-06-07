TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=3.14.5
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${TERMUX_PKG_VERSION:0:4}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=505ae49ebe3c63c595fa5f814975d8b72848447ee13b6613b0f8b96ebda18c06
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, rhash, make, clang, zlib"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON -DBUILD_CursesDialog=ON"
