TERMUX_PKG_HOMEPAGE=http://www.hpng.org
TERMUX_PKG_DESCRIPTION="hping is a commad-line oriented TCP/IP packet assembler/analyzer."
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_BUILD_IN_SRC="yes"
TERMUX_PKG_DEPENDS="libandroid-shmem, libpcap"
TERMUX_PKG_SHA256=22a8e6ecb23989c822f96680122d0485e496d446bad47ebf75f9cd1710a2ae6a
TERMUX_PKG_SRCURL=https://hax4us.github.io/hping/hping3-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-tcl"
