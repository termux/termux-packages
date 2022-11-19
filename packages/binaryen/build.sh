TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="111"
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c518b1146713bc2406dd09a1a1b18f31a283f8ac1fe200efa38834dbd95a1997
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
"
