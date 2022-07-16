TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-elf-cleaner
TERMUX_PKG_DESCRIPTION="Cleaner of ELF files for Android"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please update checksum in termux_step_start_build.sh as well if
# updating the package.
TERMUX_PKG_VERSION=2.1.1
TERMUX_PKG_SRCURL=https://github.com/termux/termux-elf-cleaner/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=104231f91ef6662f80694fc4a59c6bfeae50da21c4fc22adac3c9a5aac00ba98
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -vfi
}
