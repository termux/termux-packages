TERMUX_PKG_HOMEPAGE=https://github.com/exeldro/obs-move-transition
TERMUX_PKG_DESCRIPTION="Move transition for OBS Studio"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2.1"
TERMUX_PKG_SRCURL="https://github.com/exeldro/obs-move-transition/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=676259c4346832eac964301166b97ac12c2914a874ee53c4b91e31a613859c36
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="obs-studio"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_OUT_OF_TREE=ON
"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
