TERMUX_PKG_HOMEPAGE=http://software.schmorp.de/pkg/libev.html
TERMUX_PKG_DESCRIPTION="Full-featured and high-performance event loop library"
TERMUX_PKG_VERSION=4.22
TERMUX_PKG_SRCURL=http://dist.schmorp.de/libev/libev-${TERMUX_PKG_VERSION}.tar.gz

CFLAGS+=" -Dfd_mask=int"
