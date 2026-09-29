TERMUX_PKG_HOMEPAGE=https://github.com/MaskRay/ccls
TERMUX_PKG_DESCRIPTION="C/C++/ObjC language server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20250815.1
TERMUX_PKG_SRCURL=git+https://github.com/MaskRay/ccls.git
TERMUX_PKG_GIT_BRANCH="$TERMUX_PKG_VERSION"
TERMUX_PKG_AUTO_UPDATE=false
# clang is for libclang-cpp.so
TERMUX_PKG_DEPENDS="clang, libc++, libllvm"
TERMUX_PKG_BUILD_DEPENDS="rapidjson, libllvm-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_SYSTEM_RAPIDJSON=ON
"

termux_step_pre_configure() {
	touch $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}
