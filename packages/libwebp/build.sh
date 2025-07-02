TERMUX_PKG_HOMEPAGE=https://github.com/webmproject/libwebp
TERMUX_PKG_DESCRIPTION="Library to encode and decode images in WebP format"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0-rc1"
TERMUX_PKG_SRCURL=https://github.com/webmproject/libwebp/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a8822fbd36e43fa1e5a83a7104d86c5be8692cee1e323d57030b5562ef884a8a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="giflib, libjpeg-turbo, libpng, libtiff, zlib"
TERMUX_PKG_BREAKS="libwebp-dev"
TERMUX_PKG_REPLACES="libwebp-dev"
TERMUX_PKG_FORCE_CMAKE=true
# "vwebp" is an X11 program and triggers a dependency on GLUT, which is in x11-packages
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DWEBP_BUILD_VWEBP=OFF
-DWEBP_BUILD_CWEBP=ON
-DWEBP_BUILD_DWEBP=ON
-DWEBP_BUILD_GIF2WEBP=ON
-DWEBP_BUILD_IMG2WEBP=ON
-DWEBP_BUILD_EXTRAS=ON
-DWEBP_ENABLE_SWAP_16BIT_CSP=ON
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=7

	local e=$(sed -En 's/^libwebp_la_LDFLAGS\s*=.*\s+-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			src/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
