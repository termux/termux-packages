TERMUX_PKG_HOMEPAGE=https://github.com/espeak-ng/pcaudiolib
TERMUX_PKG_DESCRIPTION="Portable C Audio Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/espeak-ng/pcaudiolib/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=44b9d509b9eac40a0c61585f756d76a7b555f732e8b8ae4a501c8819c59c6619
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="pulseaudio"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local a
	for a in CURRENT AGE; do
		local _LT_${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' \
				Makefile.am)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ ! "${_LT_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	./autogen.sh
}
