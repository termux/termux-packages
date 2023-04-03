TERMUX_PKG_HOMEPAGE=https://libsodium.org/
TERMUX_PKG_DESCRIPTION="Network communication, cryptography and signaturing library"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.18
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/jedisct1/libsodium/archive/${TERMUX_PKG_VERSION}-RELEASE.tar.gz
TERMUX_PKG_SHA256=b7292dd1da67a049c8e78415cd498ec138d194cfdb302e716b08d26b80fecc10
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BREAKS="libsodium-dev"
TERMUX_PKG_REPLACES="libsodium-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=23

	local e=$(sed -En 's/^SODIUM_LIBRARY_VERSION=([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
