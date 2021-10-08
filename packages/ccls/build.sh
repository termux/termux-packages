TERMUX_PKG_HOMEPAGE=https://github.com/MaskRay/ccls
TERMUX_PKG_DESCRIPTION="C/C++/ObjC language server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.20210330
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/MaskRay/ccls/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=28c228f49dfc0f23cb5d581b7de35792648f32c39f4ca35f68ff8c9cb5ce56c2
TERMUX_PKG_DEPENDS="libllvm"
TERMUX_PKG_BUILD_DEPENDS="rapidjson, libllvm-static"

termux_step_pre_configure() {
	touch $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}
