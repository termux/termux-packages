TERMUX_PKG_HOMEPAGE=https://github.com/msgpack/msgpack-c/
TERMUX_PKG_DESCRIPTION="MessagePack implementation for C"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.0.0
TERMUX_PKG_SRCURL=https://github.com/msgpack/msgpack-c/releases/download/c-${TERMUX_PKG_VERSION}/msgpack-c-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=420fe35e7572f2a168d17e660ef981a589c9cbe77faa25eb34a520e1fcc032c8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BREAKS="libmsgpack-dev"
TERMUX_PKG_REPLACES="libmsgpack-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DMSGPACK_BUILD_EXAMPLES=OFF
-DMSGPACK_BUILD_TESTS=OFF
"

termux_pkg_auto_update() {
	# Get latest release tag:
	local tag
	tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	# check if this is not a c++ release:
	if grep -qP "^c-${TERMUX_PKG_UPDATE_VERSION_REGEXP}\$" <<<"$tag"; then
		termux_pkg_upgrade_version "$tag"
	else
		echo "WARNING: Skipping auto-update: Not a C release($tag)"
	fi
}

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=2

	local v=$(sed -En 's/^\s*SET_TARGET_PROPERTIES\s*\(msgpackc\s+.*\s+SOVERSION\s+([0-9]+).*/\1/p' \
			CMakeLists.txt)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
