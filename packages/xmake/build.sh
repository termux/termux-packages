TERMUX_PKG_HOMEPAGE=https://xmake.io/
TERMUX_PKG_DESCRIPTION="A cross-platform build utility based on Lua"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Ruki Wang @waruqi"
TERMUX_PKG_VERSION=2.3.4
TERMUX_PKG_SRCURL=https://github.com/xmake-io/xmake/releases/download/v${TERMUX_PKG_VERSION}/xmake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a03d52236bbe34e83a5f4a2182ffa3247a6c1d0c888c0c36271b3b378aad8541
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make build
}
termux_step_make_install() {
	make install PREFIX="${TERMUX_PREFIX}"
}
