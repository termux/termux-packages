TERMUX_PKG_HOMEPAGE=https://libexif.github.io/
TERMUX_PKG_DESCRIPTION="Library for reading and writing EXIF image metadata"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.24
TERMUX_PKG_SRCURL=https://github.com/libexif/libexif/archive/libexif-0_6_22-release.tar.gz
TERMUX_PKG_SHA256=46498934b7b931526fdee8fd8eb77a1dddedd529d5a6dbce88daf4384baecc54
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_BREAKS="libexif-dev"
TERMUX_PKG_REPLACES="libexif-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=12

	local a
	for a in LIBEXIF_CURRENT LIBEXIF_AGE; do
		local _${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LIBEXIF_CURRENT - _LIBEXIF_AGE ))
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi
}
