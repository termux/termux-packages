TERMUX_PKG_HOMEPAGE=https://github.com/LuRsT/hr
TERMUX_PKG_DESCRIPTION="A horizontal ruler for your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=decaf6e09473cb5792ba606f761786d8dce3587a820c8937a74b38b1bf5d80fb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS=bash
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make() {
	return
}

termux_step_make_install() {
	local bin="$(basename $TERMUX_PKG_HOMEPAGE)"
	install -D "$bin" -t "$TERMUX_PREFIX/bin"
	install -D "$bin.1" -t "$TERMUX_PREFIX/share/man/man1"
}
