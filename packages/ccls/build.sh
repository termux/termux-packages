TERMUX_PKG_HOMEPAGE=https://github.com/MaskRay/ccls
TERMUX_PKG_DESCRIPTION="C/C++/ObjC language server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=48f1a006b78944a944cdc0c98fb4b447e19fce7d
_COMMIT_DATE=2024.12.06
TERMUX_PKG_VERSION=0.${_COMMIT_DATE//./}
TERMUX_PKG_SRCURL=git+https://github.com/MaskRay/ccls.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_AUTO_UPDATE=false
# clang is for libclang-cpp.so
TERMUX_PKG_DEPENDS="clang, libc++, libllvm"
TERMUX_PKG_BUILD_DEPENDS="rapidjson, libllvm-static"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_SYSTEM_RAPIDJSON=ON
"

termux_step_pre_configure() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$_COMMIT_DATE" ]; then
		echo -n "ERROR: The specified commit date \"$_COMMIT_DATE\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi

	touch $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/bin/{clang-import-test,clang-offload-wrapper}
}
