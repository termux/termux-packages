TERMUX_PKG_HOMEPAGE=http://www.hpng.org
TERMUX_PKG_DESCRIPTION="hping is a command-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap"
TERMUX_PKG_SHA256=c21fba23305e6ee8936e5fd2a95723afcafb62e33071b7bc1349231f7fadddcb
TERMUX_PKG_SRCURL=https://hax4us.github.io/hping/hping3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
