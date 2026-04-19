TERMUX_PKG_HOMEPAGE=https://dev.lovelyhq.com/libburnia
TERMUX_PKG_DESCRIPTION="Library for reading, mastering and writing optical discs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.8"
TERMUX_PKG_SRCURL=https://files.libburnia-project.org/releases/libburn-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8e24dd99f5b7cafbecf0116d61b619ee89098e20263e6f47c793aaf4a98d6473
TERMUX_PKG_AUTO_UPDATE=true
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
