TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="129"
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/refs/tags/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=326f03e3a8b9eddc63cd9d6ff943bee86dae6f736c9f217e58530350381b011a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DBYN_ENABLE_LTO=ON
"
