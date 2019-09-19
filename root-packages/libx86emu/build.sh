TERMUX_PKG_HOMEPAGE=https://github.com/wfeldt/libx86emu
TERMUX_PKG_DESCRIPTION="x86 emulation library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.4
TERMUX_PKG_SRCURL=https://github.com/wfeldt/libx86emu/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cf538e657091234c1835cf0df1fdbc4b5d6afac133776ab112c4be81c15faaf5
TERMUX_PKG_BREAKS="libx86emu-dev"
TERMUX_PKG_REPLACES="libx86emu-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	echo 'touch changelog' > git2log
}
