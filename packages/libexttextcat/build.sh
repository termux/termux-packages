TERMUX_PKG_HOMEPAGE="https://wiki.documentfoundation.org/Libexttextcat"
TERMUX_PKG_DESCRIPTION="N-Gram-Based Text Categorization library primarily intended for language guessing"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://dev-www.libreoffice.org/src/libexttextcat-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=df0a59d413a5b202573d8d4f5159e33a8538da4f8e8e60979facc64d6290cebd
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
