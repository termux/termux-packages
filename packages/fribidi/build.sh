TERMUX_PKG_HOMEPAGE=https://github.com/fribidi/fribidi/
TERMUX_PKG_DESCRIPTION="Implementation of the Unicode Bidirectional Algorithm"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.14"
TERMUX_PKG_SRCURL=https://github.com/fribidi/fribidi/releases/download/v$TERMUX_PKG_VERSION/fribidi-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=76ae204a7027652ac3981b9fa5817c083ba23114340284c58e756b259cd2259a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BREAKS="fribidi-dev"
TERMUX_PKG_REPLACES="fribidi-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-docs"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local a
	for a in INTERFACE_VERSION BINARY_AGE; do
		local _${a}=$(sed -En 's/^m4_define\(fribidi_'"${a,,}"',\s*([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _INTERFACE_VERSION - _BINARY_AGE ))
	if [ ! "${_INTERFACE_VERSION}" ] || [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
