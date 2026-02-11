TERMUX_PKG_HOMEPAGE=https://jpegxl.info/
TERMUX_PKG_DESCRIPTION="JPEG XL image format reference implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/libjxl/libjxl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ab38928f7f6248e2a98cc184956021acb927b16a0dee71b4d260dc040a4320ea
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
-DJPEGXL_ENABLE_PLUGIN_GIMP210=False
-DJPEGXL_BUNDLE_LIBPNG=False
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after RELEASE / SOVERSION is changed.
	local _SOVERSION=0.11

	for a in MAJOR SO_MINOR; do
		local _${a}=$(sed -En 's/^set\(JPEGXL_'"${a}"'_VERSION\s+([0-9]+).*/\1/p' \
				lib/CMakeLists.txt)
	done
	local v="${_MAJOR}"
	if [ "${_SO_MINOR}" != "0" ]; then
		v+=".${_SO_MINOR}"
	fi
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi

	./deps.sh
}
