TERMUX_PKG_HOMEPAGE=https://libxmlplusplus.github.io/libxmlplusplus/
TERMUX_PKG_DESCRIPTION="A C++ wrapper for the libxml2 XML parser library (version 5.0)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION="5.6.1"
TERMUX_PKG_SRCURL=https://github.com/libxmlplusplus/libxmlplusplus/releases/download/${TERMUX_PKG_VERSION}/libxml++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4996e8a73995e8a4cd656c8591dce38181146edfc30cb47c97d1db3c56990ad7
TERMUX_PKG_DEPENDS="libxml2, libiconv"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
