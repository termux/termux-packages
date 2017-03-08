TERMUX_PKG_HOMEPAGE=http://jemalloc.net/
TERMUX_PKG_DESCRIPTION="General-purpose scalable concurrent malloc(3) implementation"
TERMUX_PKG_VERSION=4.5.0
TERMUX_PKG_SRCURL=https://github.com/jemalloc/jemalloc/releases/download/$TERMUX_PKG_VERSION/jemalloc-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=9409d85664b4f135b77518b0b118c549009dc10f6cba14557d170476611f6780
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syscall"