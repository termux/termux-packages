TERMUX_PKG_HOMEPAGE=https://github.com/jthornber/thin-provisioning-tools
TERMUX_PKG_DESCRIPTION="A suite of tools for manipulating the metadata of the dm-thin, dm-cache and dm-era device-mapper targets."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/jthornber/thin-provisioning-tools/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a2508d9933ed8a3f6c8d302280d838d416668a1d914a83c4bd0fb01eaf0676e8
TERMUX_PKG_DEPENDS="libexpat, libaio, boost"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-optimisation=-O3"
TERMUX_PKG_AUTO_UPDATE=false

termux_step_pre_configure() {
	CFLAGS+=" -I$TERMUX_PREFIX/include"
	CXXFLAGS+=" -I$TERMUX_PREFIX/include"
	autoconf
}
