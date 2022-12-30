TERMUX_PKG_HOMEPAGE=https://github.com/rui314/chibicc
TERMUX_PKG_DESCRIPTION="A Small C Compiler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=90d1f7f199cc55b13c7fdb5839d1409806633fdb
TERMUX_PKG_VERSION=2020.12.07
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/rui314/chibicc
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="binutils-is-llvm | binutils, libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="aarch64, arm, i686"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin chibicc
}
