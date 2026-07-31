TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/libbluray/
TERMUX_PKG_DESCRIPTION="An open-source library designed for Blu-Ray Discs playback for media players"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.0"
TERMUX_PKG_SRCURL=https://downloads.videolan.org/pub/videolan/libbluray/${TERMUX_PKG_VERSION}/libbluray-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f676408e91a5d321abf8b8d4dfdae36205c297dab5c54c3ec519639025f474a2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, libudfread, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dbdj_jar=disabled
"

termux_step_pre_configure() {
	unset JDK_HOME
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _GUARD_FILE="lib/libbluray.so.4"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
