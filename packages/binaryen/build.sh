TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="126"
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/refs/tags/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f1c53762abae21cb6bc3e55d4e96d4ca4ea261f83a51d2aa47abc75d60e683e7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DBYN_ENABLE_LTO=ON
"
