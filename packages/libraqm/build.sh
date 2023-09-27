TERMUX_PKG_HOMEPAGE=https://github.com/HOST-Oman/libraqm
TERMUX_PKG_DESCRIPTION="Raqm is a small library that encapsulates the logic for complex text layout and provides a convenient API"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.1"
TERMUX_PKG_SRCURL=https://github.com/HOST-Oman/libraqm/releases/download/v$TERMUX_PKG_VERSION/raqm-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=4d76a358358d67c5945684f2f10b3b08fb80e924371bf3ebf8b15cd2e321d05d
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
