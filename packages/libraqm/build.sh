TERMUX_PKG_HOMEPAGE=https://github.com/HOST-Oman/libraqm
TERMUX_PKG_DESCRIPTION="Raqm is a small library that encapsulates the logic for complex text layout and provides a convenient API"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.3"
TERMUX_PKG_SRCURL=https://github.com/HOST-Oman/libraqm/releases/download/v$TERMUX_PKG_VERSION/raqm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=34c4d0340a18d62a6962ea36c76b06c2bc00bd2017b2d8952a85bb673cfcfcfa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, harfbuzz, fribidi"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}
