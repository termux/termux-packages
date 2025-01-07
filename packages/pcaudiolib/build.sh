TERMUX_PKG_HOMEPAGE=https://github.com/espeak-ng/pcaudiolib
TERMUX_PKG_DESCRIPTION="Portable C Audio Library"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3"
TERMUX_PKG_SRCURL=https://github.com/espeak-ng/pcaudiolib/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=86edb75048eec7fcd8d74f9568f051d50b4781982215095b96ba9c2c9c7c159b
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
