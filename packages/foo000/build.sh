TERMUX_PKG_HOMEPAGE=http://termux.invalid/
TERMUX_PKG_DESCRIPTION="An invalid package for testing"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/lib/clang/14/lib/linux/foo
	touch $TERMUX_PREFIX/lib/clang/14/lib/linux/foo/.placeholder

	mkdir -p $TERMUX_PREFIX/share/$TERMUX_PKG_NAME
	touch $TERMUX_PREFIX/share/$TERMUX_PKG_NAME/.installed
}
