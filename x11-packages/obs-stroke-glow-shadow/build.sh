TERMUX_PKG_HOMEPAGE="https://github.com/FiniteSingularity/obs-stroke-glow-shadow"
TERMUX_PKG_DESCRIPTION="An OBS plugin to provide Stroke, Glow, and Shadow effect on masked sources"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.1"
TERMUX_PKG_SRCURL="https://github.com/FiniteSingularity/obs-stroke-glow-shadow/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3aec299b0d949c886564af707dbb0bc60c23dc6beb1c662d7104faaac8caa224
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="obs-studio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_OUT_OF_TREE=ON
-DCMAKE_CXX_SCAN_FOR_MODULES=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
