TERMUX_PKG_HOMEPAGE="http://git.linux-nfs.org/?p=steved/libtirpc.git"
TERMUX_PKG_DESCRIPTION="Transport Independent RPC library"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.2.6
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sourceforge/libtirpc/libtirpc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4278e9a5181d5af9cd7885322fdecebc444f9a3da87c526e7d47f7a12a37d1cc
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gssapi"
