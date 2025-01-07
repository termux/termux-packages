TERMUX_PKG_HOMEPAGE=https://github.com/google/zopfli
TERMUX_PKG_DESCRIPTION="New zlib compatible compressor library"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/google/zopfli/archive/zopfli-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e955a7739f71af37ef3349c4fa141c648e8775bceb2195be07e86f8e638814bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libzopfli-dev"
TERMUX_PKG_REPLACES="libzopfli-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DZOPFLI_BUILD_SHARED=ON"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=1

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
