TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
_MAJOR_VERSION=3.9
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SHA256=167701525183dbb722b9ffe69fb525aa2b81798cf12f5ce1c020c93394dfae0f
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${_MAJOR_VERSION}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, librhash"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON"

