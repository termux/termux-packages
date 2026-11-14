TERMUX_PKG_HOMEPAGE=https://github.com/MaskRay/ccls
TERMUX_PKG_DESCRIPTION="C/C++/ObjC language server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20261004
TERMUX_PKG_SRCURL="https://github.com/MaskRay/ccls/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8e022718ac8d54aef36cd728a177ad036994d7abf535941b948ae14d1a9085dd
# clang is for libclang-cpp.so
TERMUX_PKG_DEPENDS="clang, libc++, libllvm"
TERMUX_PKG_BUILD_DEPENDS="rapidjson, libllvm-static"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_SYSTEM_RAPIDJSON=ON
"

termux_step_pre_configure() {
	touch "$TERMUX_PREFIX/bin"/{clang-import-test,clang-offload-wrapper}
}

termux_step_post_make_install() {
	rm "$TERMUX_PREFIX/bin"/{clang-import-test,clang-offload-wrapper}
}
