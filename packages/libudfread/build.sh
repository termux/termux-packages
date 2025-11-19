TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/libudfread/
TERMUX_PKG_DESCRIPTION="A library for reading UDF"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/libudfread/-/archive/${TERMUX_PKG_VERSION}/libudfread-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=adcce1190925f9d35a477757c5e3f0e221315d14d3d45b4ae62540ea0925f877
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _GUARD_FILE="lib/libudfread.so.3"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
