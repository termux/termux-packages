TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=107
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c09a7e0eb0fbfdfc807d13e8af9305e9805b8fdc499d9f886f5cf2e3fce5b5cf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
"
