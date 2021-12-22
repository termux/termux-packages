TERMUX_PKG_HOMEPAGE=https://www.musicpd.org/clients/mpc/
TERMUX_PKG_DESCRIPTION="Minimalist command line interface for MPD"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.34
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.musicpd.org/download/mpc/${TERMUX_PKG_VERSION:0:1}/mpc-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=691e3f3654bc10d022bb0310234d0bc2d8c075a698f09924d9ebed8f506fda20
TERMUX_PKG_DEPENDS="libiconv, libmpdclient"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Diconv=enabled"

# There seems to be issues with sphinx-build when using concurrent builds:
TERMUX_MAKE_PROCESSES=1

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
