TERMUX_PKG_HOMEPAGE=https://libsodium.org/
TERMUX_PKG_DESCRIPTION="Network communication, cryptography and signaturing library"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.22"
TERMUX_PKG_SRCURL=https://github.com/jedisct1/libsodium/archive/refs/tags/${TERMUX_PKG_VERSION}-RELEASE.tar.gz
TERMUX_PKG_SHA256=b97e76fb560940a2499e253c45ffee96526f741ef3b378be3bb7e587fe2fd494
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+(?=-RELEASE)"
TERMUX_PKG_BREAKS="libsodium-dev"
TERMUX_PKG_REPLACES="libsodium-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=26

	local e=$(sed -En 's/^SODIUM_LIBRARY_VERSION=([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		export CFLAGS_ARMCRYPTO="-march=armv8-a+crypto+aes"
	fi
}
