TERMUX_PKG_HOMEPAGE=https://git.causal.agency/catgirl
TERMUX_PKG_DESCRIPTION="A TLS-only terminal IRC client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://git.causal.agency/catgirl/snapshot/catgirl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a68bfb82f625bcdf7bc5b7a6e1528fe3559bcded41f0d3c972f8b7e918bcee8e
TERMUX_PKG_DEPENDS="libandroid-support, libretls, ncurses, openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
"
TERMUX_PKG_EXTRA_MAKE_ARGS="catgirl"
