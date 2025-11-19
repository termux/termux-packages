TERMUX_PKG_HOMEPAGE=https://github.com/LuRsT/hr
TERMUX_PKG_DESCRIPTION="A horizontal ruler for your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=d4bb6e8495a8adaf7a70935172695d06943b4b10efcbfe4f8fcf6d5fe97ca251
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
