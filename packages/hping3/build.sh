TERMUX_PKG_HOMEPAGE=http://www.hping.org
TERMUX_PKG_DESCRIPTION="hping is a command-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap, tcl"
TERMUX_PKG_SHA256=636c04e4546dddc07e8c0d38c0151baa9b0de701290c87976792cac2ca27d2b0
TERMUX_PKG_SRCURL=https://hax4us.github.io/hping/hping3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
