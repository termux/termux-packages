TERMUX_PKG_HOMEPAGE=https://www.fltk.org/
TERMUX_PKG_DESCRIPTION="Graphical user interface toolkit for X"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
# Revbump reverse dependencies after updating
TERMUX_PKG_VERSION="1.4.5"
TERMUX_PKG_SRCURL=https://github.com/fltk/fltk/releases/download/release-${TERMUX_PKG_VERSION}/fltk-${TERMUX_PKG_VERSION}-source.tar.gz
TERMUX_PKG_SHA256=eede1fb2b8e9c2e581e77082e15252145855c79aad30070ee3b24aabe2f926f1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib, glu, libc++, libcairo, libjpeg-turbo, libpng, libwayland, libx11, libxcursor, libxfixes, libxinerama, libxkbcommon, libxrender, opengl, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-shared
--enable-threads
--enable-xinerama
--enable-xft
--enable-xfixes
--enable-xcursor
--enable-xrender
--disable-test
--enable-wayland
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper

	sed -i 's/x-fluid.desktop/fluid.desktop/' -i fluid/Makefile

	export LIBS="$LDFLAGS"
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libfltk.so.1.4"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
