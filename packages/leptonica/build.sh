TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="leptonica-license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.85.0"
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c01376bce0379d4ea4bc2ec5d5cbddaa49e2f06f88242619ab8c059e21adf233
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="giflib, libjpeg-turbo, libpng, libtiff, libwebp, openjpeg, zlib"
TERMUX_PKG_BREAKS="leptonica-dev"
TERMUX_PKG_REPLACES="leptonica-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=6

	local v=$(sed -En 's/^.*set_target_properties\s*\(leptonica PROPERTIES SOVERSION ([0-9]+).*$/\1/p' \
			src/CMakeLists.txt)
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
