TERMUX_PKG_HOMEPAGE=https://schismtracker.org/
TERMUX_PKG_DESCRIPTION="A free and open-source reimplementation of Impulse Tracker, a program used to create high quality music"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20240426"
TERMUX_PKG_SRCURL=https://github.com/schismtracker/schismtracker/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e1e6d0dd356f5747b46fe52113e2348705f7d813fc534e1236e66a94ba47b497
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libflac, libx11, libxv, sdl2"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_SDL_CONFIG=$TERMUX_PREFIX/bin/sdl2-config
ac_cv_prog_WINDRES=
ac_cv_prog_ac_ct_WINDRES=
"

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_configure() {
	mkdir -p auto
}
