TERMUX_PKG_HOMEPAGE=https://github.com/wfeldt/libx86emu
TERMUX_PKG_DESCRIPTION="x86 emulation library"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE_INFO"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5
TERMUX_PKG_SRCURL=https://github.com/wfeldt/libx86emu/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=91da55f5da55017d5a80e2364de30f9520aa8df2744ff587a09ba58d6e3536c8
TERMUX_PKG_BREAKS="libx86emu-dev"
TERMUX_PKG_REPLACES="libx86emu-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	echo 'touch changelog' > git2log
}
