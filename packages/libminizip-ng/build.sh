TERMUX_PKG_HOMEPAGE=https://github.com/zlib-ng/minizip-ng
TERMUX_PKG_DESCRIPTION="A zip manipulation library written in C"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.10"
TERMUX_PKG_SRCURL=https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c362e35ee973fa7be58cc5e38a4a6c23cc8f7e652555daf4f115a9eb2d3a6be7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2, libiconv, liblzma, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_INCLUDEDIR=include/minizip-ng
-DBUILD_SHARED_LIBS=ON
-DMZ_COMPAT=OFF
"
# ZSTD is disabled only because it breaks build of opencolorio when enabled.
# This may be resolved by building zstd with CMake, but that needs extra care
# such as SONAME change. I just cannot be bothered to do that for now.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DMZ_ZSTD=OFF"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=4

	local v=$(sed -En 's/^set\(SOVERSION\s+"?([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
