TERMUX_PKG_HOMEPAGE=https://jpegxl.info/
TERMUX_PKG_DESCRIPTION="JPEG XL image format reference implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL=https://github.com/libjxl/libjxl/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d83bbe188d8fa9725bb75109c922c37fcff8c3b802808f3a6c2c14aaf8337d9f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="brotli, libc++"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DJPEGXL_ENABLE_JNI=False
-DJPEGXL_FORCE_SYSTEM_BROTLI=True
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after RELEASE / SOVERSION is changed.
	local _SOVERSION=0.9

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

	patch -p1 < $TERMUX_PKG_BUILDER_DIR/fix-deps.diff

	./deps.sh
}
