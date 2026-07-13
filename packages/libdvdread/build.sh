TERMUX_PKG_HOMEPAGE=https://code.videolan.org/videolan/libdvdread
TERMUX_PKG_DESCRIPTION="A library that allows easy use of sophisticated DVD navigation features"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.1.0"
TERMUX_PKG_SRCURL=https://code.videolan.org/videolan/libdvdread/-/archive/${TERMUX_PKG_VERSION}/libdvdread-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=35fb76448fbf9a6a5145a9e4241dfd2ddcf05e8dfac68fa6307ebf99defefe41
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag

termux_step_pre_configure() {
	export TERMUX_MESON_ENABLE_SOVERSION=1
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _GUARD_FILE="lib/libdvdread.so.8"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
