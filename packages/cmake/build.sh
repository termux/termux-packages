TERMUX_PKG_HOMEPAGE=https://cmake.org/
TERMUX_PKG_DESCRIPTION="Family of tools designed to build, test and package software"
_MAJOR_VERSION=3.9
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SHA256=954a5801a456ee48e76f01107c9a4961677dd0f3e115275bbd18410dc22ba3c1
TERMUX_PKG_SRCURL=https://www.cmake.org/files/v${_MAJOR_VERSION}/cmake-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libarchive, libcurl, libexpat, jsoncpp, libuv, librhash, make, clang"
TERMUX_PKG_FORCE_CMAKE=yes
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DKWSYS_LFS_WORKS=ON"

