TERMUX_PKG_HOMEPAGE=https://github.com/exeldro/obs-move-transition
TERMUX_PKG_DESCRIPTION="Move transition for OBS Studio"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.2"
TERMUX_PKG_SRCURL="https://github.com/exeldro/obs-move-transition/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e48847541d70709975e582257188635903b1525adac9715e6103ea8925015833
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="obs-studio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_OUT_OF_TREE=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
