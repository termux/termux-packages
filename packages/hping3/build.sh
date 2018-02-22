TERMUX_PKG_HOMEPAGE=http://www.hpng.org
TERMUX_PKG_DESCRIPTION="hping is a commad-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap"
TERMUX_PKG_SHA256=fc8a3bed442782c890fb2c1144d82a90c6f9c8617022ede3cd180fe2a33c3f39
TERMUX_PKG_SRCURL=https://hax4us.github.io/hping/hping3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
