TERMUX_PKG_HOMEPAGE=https://github.com/opentoonz/iwawarper
TERMUX_PKG_DESCRIPTION="2D warping tool for animation production"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="../LICENSE.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.0"
TERMUX_PKG_SRCURL="https://github.com/opentoonz/iwawarper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=cf3e571a8c94cd029aeacc06fbeaa710f30a7d0170247b915c4eac863ac7fbba
TERMUX_PKG_DEPENDS="freeglut, glu, libc++, mesa, opentoonz, qt5-qtbase, qt5-qtsvg, qt5-qttools"
TERMUX_PKG_BUILD_DEPENDS="qt5-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_pre_configure() {
	termux_setup_cmake
	TERMUX_PKG_SRCDIR="${TERMUX_PKG_SRCDIR}/sources"
	CFLAGS+=" -DLINUX"
	CXXFLAGS+=" -DLINUX"
}
