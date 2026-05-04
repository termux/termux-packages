# Contributor: @waruqi
TERMUX_PKG_HOMEPAGE=https://xmake.io/
TERMUX_PKG_DESCRIPTION="A cross-platform build utility based on Lua"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Ruki Wang @waruqi"
TERMUX_PKG_VERSION="3.0.8"
TERMUX_PKG_SRCURL=https://github.com/xmake-io/xmake/releases/download/v${TERMUX_PKG_VERSION}/xmake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73da077440d1327e24bc74da2888c418e589dc28966e6e6b5bd6e889721b2d07
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure () {
	"$TERMUX_PKG_SRCDIR"/configure --prefix="$TERMUX_PREFIX"
}
