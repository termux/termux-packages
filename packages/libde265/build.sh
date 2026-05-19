TERMUX_PKG_HOMEPAGE=https://github.com/strukturag/libde265
TERMUX_PKG_DESCRIPTION="H.265/HEVC video stream decoder library"
TERMUX_PKG_LICENSE="LGPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.19"
TERMUX_PKG_SRCURL="https://github.com/strukturag/libde265/releases/download/v$TERMUX_PKG_VERSION/libde265-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=bb19a0b485d2643e0eeb7e91f3ab32d1ad617e7c487dbedc91214ca3dbd8d7eb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v
	v=$(sed -En 's/^set\(DE265_SOVERSION ([0-9]+)\)$/\1/p' CMakeLists.txt)
	if [[ "${v:-}" != "${_SOVERSION}" ]]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
