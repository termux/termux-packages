TERMUX_PKG_HOMEPAGE=https://github.com/MaskRay/ccls
TERMUX_PKG_DESCRIPTION="C/C++/ObjC language server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20220729
TERMUX_PKG_SRCURL=https://github.com/MaskRay/ccls/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=af19be36597c2a38b526ce7138c72a64c7fb63827830c4cff92256151fc7a6f4
TERMUX_PKG_DEPENDS="libc++, libllvm"
TERMUX_PKG_BUILD_DEPENDS="rapidjson, libllvm-static"

termux_step_pre_configure() {
	touch $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}
