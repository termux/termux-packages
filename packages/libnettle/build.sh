TERMUX_PKG_HOMEPAGE=https://www.lysator.liu.se/~nisse/nettle/
TERMUX_PKG_DESCRIPTION="Cryptographic library that is designed to fit easily in more or less any context"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0+really3.10.2"
TERMUX_PKG_SRCURL="https://mirrors.kernel.org/gnu/nettle/nettle-${TERMUX_PKG_VERSION#*really}.tar.gz"
TERMUX_PKG_SHA256=fe9ff51cb1f2abb5e65a6b8c10a92da0ab5ab6eaf26e7fc2b675c45f1fb519b5
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libgmp"
TERMUX_PKG_BREAKS="libnettle-dev"
TERMUX_PKG_REPLACES="libnettle-dev"

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES=(
		'lib/libhogweed.so.6'
		'lib/libnettle.so.8'
	)

	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		[ -e "${f}" ] || termux_error_exit "SOVERSION guard check failed."
	done
}
