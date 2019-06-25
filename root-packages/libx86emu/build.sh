TERMUX_PKG_HOMEPAGE=https://github.com/wfeldt/libx86emu
TERMUX_PKG_DESCRIPTION="x86 emulation library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.3
TERMUX_PKG_SRCURL=https://github.com/wfeldt/libx86emu/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b9664d1099f1dfe496f362f4923a2815d3e5785a1ce71edf08011a858731c3fc
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	echo 'touch changelog' > git2log
}
