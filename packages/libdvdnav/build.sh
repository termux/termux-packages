TERMUX_PKG_HOMEPAGE=https://www.videolan.org/developers/libdvdnav.html
TERMUX_PKG_DESCRIPTION="A library that allows easy use of sophisticated DVD navigation features"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0.0"
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/libdvdnav/-/archive/${TERMUX_PKG_VERSION}/libdvdnav-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=15d28086937647a95c3d6b083f0a86678cd4dd428914e319c64adf52cadec786
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libdvdread"

termux_step_pre_configure() {
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _GUARD_FILE="lib/libdvdnav.so.4"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
