TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="132"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/WebAssembly/binaryen/archive/refs/tags/version_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ede5e20f2f5148641bad31ceaef3c1fd4de4fb63b2d7b5081c605ba475483f6b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
-DBYN_ENABLE_LTO=ON
"
