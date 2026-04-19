TERMUX_PKG_HOMEPAGE=https://dev.lovelyhq.com/libburnia
TERMUX_PKG_DESCRIPTION="Library for reading, mastering and writing optical discs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://files.libburnia-project.org/releases/libburn-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7295491b4be5eeac5e7a3fb2067e236e2955ffdc6bbd45f546466edee321644b
TERMUX_PKG_BREAKS="libburn-dev"
TERMUX_PKG_REPLACES="libburn-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local a
	for a in LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
