TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="leptonica-license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.87.0"
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fa2b40c5caea96d1bb93a97486262aed8731b69ce25a84a6bf5d25323e33f631
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="giflib, libjpeg-turbo, libpng, libtiff, libwebp, openjpeg, zlib"
TERMUX_PKG_BREAKS="leptonica-dev"
TERMUX_PKG_REPLACES="leptonica-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=6

	local v=$(sed -En 's/^.*SOVERSION ([0-9]+).*$/\1/p' src/CMakeLists.txt)
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	# Silence tmpfile warnings:
	find src -name '*.c' | xargs -n 1 \
		sed -i 's/L_INFO("work-around: writing to a temp file\\n", __func__)/((void)0)/'

	./autogen.sh
}
