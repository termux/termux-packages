TERMUX_PKG_HOMEPAGE=http://xmake.io/
TERMUX_PKG_DESCRIPTION="A cross-platform build utility based on Lua"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Ruki Wang @waruqi"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/xmake-io/xmake/releases/download/v${TERMUX_PKG_VERSION}/xmake-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c927efad5412c3bdb8bad1be5b1b2ea40a998dff2a252edb443782865b7472b9
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="clang, make, readline"

termux_step_make() {
	make build
}
termux_step_make_install() {
	make install PREFIX="${TERMUX_PREFIX}"
}
