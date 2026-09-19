TERMUX_PKG_HOMEPAGE=https://cyan4973.github.io/xxHash/
TERMUX_PKG_DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
TERMUX_PKG_LICENSE="BSD, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.4"
TERMUX_PKG_SRCURL=https://github.com/Cyan4973/xxHash/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5738270935e7c3d38a79b3adf7c9692566ce7895a25f67de43ad52ab504acd32
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libxxhash.so.0"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
