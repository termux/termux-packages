TERMUX_PKG_HOMEPAGE=https://www.gap-system.org/
TERMUX_PKG_DESCRIPTION="GAP is a system for computational discrete algebra, with particular emphasis on Computational Group Theory"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.11.0
TERMUX_PKG_SHA256=6fda7af23394708aeb3b4bca8885f5fdcb7c3ae4419639dfb2d9f67d3f590abb
TERMUX_PKG_SRCURL=https://www.gap-system.org/pub/gap/gap-${TERMUX_PKG_VERSION:0:4}/tar.gz/gap-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="readline, libgmp, zlib"
TERMUX_PKG_BREAKS="gap-dev"
TERMUX_PKG_REPLACES="gap-dev"

termux_step_post_make_install() {
	ln -sf $TERMUX_PREFIX/bin $TERMUX_PREFIX/share/gap/
}
