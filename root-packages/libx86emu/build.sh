TERMUX_PKG_HOMEPAGE=https://github.com/wfeldt/libx86emu
TERMUX_PKG_DESCRIPTION="x86 emulation library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/wfeldt/libx86emu/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=70b574ed84dcba2dc4f54a9a1c14539e84ddbe628842c638a2f98d987d879dac
TERMUX_PKG_BREAKS="libx86emu-dev"
TERMUX_PKG_REPLACES="libx86emu-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	echo 'touch changelog' > git2log
}
