TERMUX_PKG_HOMEPAGE=http://www.hping.org
TERMUX_PKG_DESCRIPTION="hping is a command-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap, tcl"
TERMUX_PKG_SHA256=ea9cc31dc3efb0c89180d5dedaa84ec1b7f738e088ac32dba5d1d077ea62c83b
TERMUX_PKG_SRCURL=https://hax4us.github.io/hping/hping3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
