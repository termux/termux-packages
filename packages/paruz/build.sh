TERMUX_PKG_HOMEPAGE=https://github.com/joehillen/paruz
TERMUX_PKG_DESCRIPTION="A fzf terminal UI for paru or pacman"
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_SRCURL=https://github.com/joehillen/paruz/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1800e55136b2c17135a7139ae3f3f4706c60d23b957b9a92cb1d3bf2d5942123
TERMUX_PKG_DEPENDS="bash, fzf"
TERMUX_PKG_RECOMMENDS="pacman"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin paruz
}
