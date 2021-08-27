TERMUX_PKG_HOMEPAGE="https://sourceware.org/elfutils/Debuginfod.html"
TERMUX_PKG_DESCRIPTION="A client/server in elfutils 0.178+ that automatically distributes elf/dwarf/source-code from servers to clients such as debuggers across HTTP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.185
TERMUX_PKG_SRCURL="https://sourceware.org/elfutils/ftp/${TERMUX_PKG_VERSION}/elfutils-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=dc8d3e74ab209465e7f568e1b3bb9a5a142f8656e2b57d10049a73da2ae6b5a6
#TERMUX_PKG_DEPENDS=""
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fiv
}
