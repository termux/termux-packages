TERMUX_PKG_HOMEPAGE=https://github.com/libhangul/libhangul
TERMUX_PKG_DESCRIPTION="A library to support hangul input method logic"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.0"
TERMUX_PKG_SRCURL=https://github.com/libhangul/libhangul/releases/download/libhangul-${TERMUX_PKG_VERSION}/libhangul-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea04e6a0cf4840a2a3b5641c1761068c78691036db839d0838f4e7a6553a5120
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/libhangul-//"
TERMUX_PKG_DEPENDS="libandroid-glob, libexpat, libiconv"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local a
	for a in LIBHANGUL_CURRENT LIBHANGUL_AGE; do
		local _${a}=$(sed -En 's/^'"${a}"'=([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LIBHANGUL_CURRENT - _LIBHANGUL_AGE ))
	if [ ! "${_LIBHANGUL_CURRENT}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	# prefer autotools
	rm CMakeLists.txt

	LDFLAGS+=" -landroid-glob"
}
