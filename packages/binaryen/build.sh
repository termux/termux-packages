TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="127"
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/refs/tags/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=58550480a939a24d473f7850d7b7fe7098738d4aeb7eecb835b572d013acaed1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DBYN_ENABLE_LTO=ON
"
