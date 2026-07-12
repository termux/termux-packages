TERMUX_PKG_HOMEPAGE=https://jpegxl.info/
TERMUX_PKG_DESCRIPTION="JPEG XL image format reference implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.0"
TERMUX_PKG_SRCURL=https://github.com/libjxl/libjxl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=03e9be69a30be4011f559da75328b6d7cea8ad921fabfbd551ce10bf45cdc992
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="brotli, giflib, glib, libc++, libffi, libiconv, libjpeg-turbo, libpng, zlib"
TERMUX_PKG_BUILD_DEPENDS="gdk-pixbuf, littlecms"
TERMUX_PKG_SUGGESTS="gdk-pixbuf"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DJPEGXL_ENABLE_JNI=False
-DJPEGXL_FORCE_SYSTEM_BROTLI=True
-DJPEGXL_ENABLE_PLUGINS=True
-DJPEGXL_ENABLE_PLUGIN_GDKPIXBUF=True
-DJPEGXL_BUNDLE_LIBPNG=False
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after RELEASE / SOVERSION is changed.
	local _SOVERSION=0.12

	for a in MAJOR SO_MINOR; do
		local _${a}=$(sed -En 's/^set\(JPEGXL_'"${a}"'_VERSION\s+([0-9]+).*/\1/p' \
				lib/CMakeLists.txt)
	done
	local v="${_MAJOR}"
	if [ "${_SO_MINOR}" != "0" ]; then
		v+=".${_SO_MINOR}"
	fi
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed. Expected ${_SOVERSION}, got ${v}."
	fi

	./deps.sh
}
