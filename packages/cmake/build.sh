TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
_MAJOR_VERSION=3.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${_MAJOR_VERSION}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da3072794eb4c09f2d782fcee043847b99bb4cf8d4573978d9b2024214d6e92d
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, librhash"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON"

