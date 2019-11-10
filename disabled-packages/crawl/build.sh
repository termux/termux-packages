# Currently fails at:
# Makefile:101: recipe for target 'tiledef-dngn.h' failed
# make[1]: *** [tiledef-dngn.h] Segmentation fault (core dumped)

TERMUX_PKG_HOMEPAGE=https://crawl.develz.org/
TERMUX_PKG_DESCRIPTION="Roguelike adventure through dungeons filled with dangerous monsters"
TERMUX_PKG_VERSION=0.17.1
TERMUX_PKG_SRCURL=https://crawl.develz.org/release/stone_soup-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_MAKE_ARGS="V=1"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export CROSSHOST=$TERMUX_HOST_PLATFORM
	TERMUX_PKG_BUILDDIR=$TERMUX_PKG_SRCDIR/source
}
