TERMUX_PKG_HOMEPAGE="https://wiki.documentfoundation.org/Libexttextcat"
TERMUX_PKG_DESCRIPTION="N-Gram-Based Text Categorization library primarily intended for language guessing"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.4.9"
TERMUX_PKG_SRCURL=https://dev-www.libreoffice.org/src/libexttextcat-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=71e9a3cc6c4a270efd61d76281664341e1fb0412b591f1939516413a992d1e87
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libexttextcat-2.0.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
