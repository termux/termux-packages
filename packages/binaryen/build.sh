TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="133"
TERMUX_PKG_SRCURL="https://github.com/WebAssembly/binaryen/archive/refs/tags/version_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=2f3e3d9edc56751499571da073a8a81943ca3fcbc08a945d2c619a7a1d4eb88b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DBYN_ENABLE_LTO=ON
"
