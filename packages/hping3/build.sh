TERMUX_PKG_HOMEPAGE=http://www.hping.org
TERMUX_PKG_DESCRIPTION="hping is a command-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap"
TERMUX_PKG_SHA256=5992a89e8fdfcec255aeb07467423e9cdda0d4d61b3086776c74d5cdb7ff16ec
TERMUX_PKG_SRCURL=https://hax4us.github.io/hping/hping3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
