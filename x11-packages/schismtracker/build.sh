TERMUX_PKG_HOMEPAGE=https://schismtracker.org/
TERMUX_PKG_DESCRIPTION="A free and open-source reimplementation of Impulse Tracker, a program used to create high quality music"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="20240630"
TERMUX_PKG_SRCURL=https://github.com/schismtracker/schismtracker/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=55822248685eb6f3d99f95536a93969198eae92dda41cbde7f39fa1384bc758a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libflac, libx11, libxv, sdl2"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_WINDRES=
ac_cv_prog_ac_ct_WINDRES=
"

termux_step_pre_configure() {
	autoreconf -fi -I$TERMUX_PREFIX/share/aclocal
}

termux_step_post_configure() {
	mkdir -p auto
}
