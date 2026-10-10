TERMUX_PKG_HOMEPAGE=https://github.com/msgpack/msgpack-c/
TERMUX_PKG_DESCRIPTION="MessagePack implementation for C"
TERMUX_PKG_LICENSE="BSL-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0.2"
TERMUX_PKG_SRCURL=https://github.com/msgpack/msgpack-c/releases/download/c-${TERMUX_PKG_VERSION}/msgpack-c-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6ae50f69612871aa01de76bec904165cd2a2fc30ff9f653f2f60a663c5c1a86c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="c-\d+\.\d+\.\d+"
TERMUX_PKG_BREAKS="libmsgpack-dev"
TERMUX_PKG_REPLACES="libmsgpack-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DMSGPACK_BUILD_EXAMPLES=OFF
-DMSGPACK_BUILD_TESTS=OFF
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local v=$(sed -En 's/^\s*SET_TARGET_PROPERTIES\s*\(msgpack-c\s+.*\s+SOVERSION\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
