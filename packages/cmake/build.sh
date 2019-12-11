TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=3.16.1
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${TERMUX_PKG_VERSION:0:4}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a275b3168fa8626eca4465da7bb159ff07c8c6cb0fb7179be59e12cbdfa725fd
TERMUX_PKG_DEPENDS="libarchive, libc++, libcurl, libexpat, jsoncpp, libuv, rhash, make, clang, zlib"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON -DBUILD_CursesDialog=ON"
