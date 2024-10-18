TERMUX_PKG_HOMEPAGE=https://xmake.io/
TERMUX_PKG_DESCRIPTION="A cross-platform build utility based on Lua"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Ruki Wang @waruqi"
TERMUX_PKG_VERSION="2.9.5"
TERMUX_PKG_SRCURL=https://github.com/xmake-io/xmake/releases/download/v${TERMUX_PKG_VERSION}/xmake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=03feb5787e22fab8dd40419ec3d84abd35abcd9f8a1b24c488c7eb571d6724c8
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure () {
	$TERMUX_PKG_SRCDIR/configure --prefix=$TERMUX_PREFIX
}
