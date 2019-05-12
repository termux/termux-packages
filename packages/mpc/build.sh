TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpc/
TERMUX_PKG_DESCRIPTION="Minimalist command line interface for MPD"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_DEPENDS="libmpdclient"
TERMUX_PKG_VERSION=0.31
TERMUX_PKG_SHA256=62373e83a8a165b2ed43967975efecd3feee530f4557d6b861dd08aa89d52b2d
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/mpc/${TERMUX_PKG_VERSION:0:1}/mpc-$TERMUX_PKG_VERSION.tar.xz
# There seems to be issues with sphinx-build when using concurrent builds:
TERMUX_MAKE_PROCESSES=1
