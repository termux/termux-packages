TERMUX_PKG_HOMEPAGE=http://www.nongnu.org/cvs/
TERMUX_PKG_DESCRIPTION="Concurrent Versions System"
TERMUX_PKG_VERSION=1.11.23
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/non-gnu/cvs/source/stable/${TERMUX_PKG_VERSION}/cvs-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=400f51b59d85116e79b844f2d5dbbad4759442a789b401a94aa5052c3d7a4aa9
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-server"
TERMUX_PKG_RM_AFTER_INSTALL="bin/cvsbug share/man/man8/cvsbug.8"
