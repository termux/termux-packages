TERMUX_PKG_HOMEPAGE=https://xmake.io/
TERMUX_PKG_DESCRIPTION="A cross-platform build utility based on Lua"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Ruki Wang @waruqi"
TERMUX_PKG_VERSION=2.3.6
TERMUX_PKG_SRCURL=https://github.com/xmake-io/xmake/releases/download/v${TERMUX_PKG_VERSION}/xmake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d9b9dd8b357fab9e426a667a47381b5db54622cd2c5452584e4b960b410272d
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make build
}
termux_step_make_install() {
	make install PREFIX="${TERMUX_PREFIX}"
}
