TERMUX_PKG_HOMEPAGE=https://xmake.io/
TERMUX_PKG_DESCRIPTION="A cross-platform build utility based on Lua"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Ruki Wang @waruqi"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_SRCURL=https://github.com/xmake-io/xmake/releases/download/v${TERMUX_PKG_VERSION}/xmake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=851e01256c89cb9c86b6bd7327831b45809a3255daa234d3162b1db061ca44ae
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make build
}
termux_step_make_install() {
	make install PREFIX="${TERMUX_PREFIX}"
}
