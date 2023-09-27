TERMUX_PKG_HOMEPAGE=http://www.canonware.com/jemalloc/
TERMUX_PKG_DESCRIPTION="General-purpose scalable concurrent malloc(3) implementation"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_SRCURL=https://github.com/jemalloc/jemalloc/releases/download/${TERMUX_PKG_VERSION}/jemalloc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256="214dbc74c3669b34219b0c5a55cb96f07cb12f44c834ed9ee64d1185ee6c3ef2"
TERMUX_PKG_BUILD_IN_SRC=true

CPPFLAGS+=" -D__GCC_HAVE_SYNC_COMPARE_AND_SWAP_4=1"
