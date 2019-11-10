TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpc/
TERMUX_PKG_DESCRIPTION="Minimalist command line interface for MPD"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Matthew Klein @mklein994"
TERMUX_PKG_VERSION=0.32
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/mpc/${TERMUX_PKG_VERSION:0:1}/mpc-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=7961d95b7ce019996beab281cf957e905667c989c53fffd13ade5e62fea331c7
TERMUX_PKG_DEPENDS="libiconv, libmpdclient"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Diconv=enabled"

# There seems to be issues with sphinx-build when using concurrent builds:
TERMUX_MAKE_PROCESSES=1

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
