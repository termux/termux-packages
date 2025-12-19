TERMUX_PKG_HOMEPAGE=https://libxmlplusplus.github.io/libxmlplusplus/
TERMUX_PKG_DESCRIPTION="A C++ wrapper for the libxml2 XML parser library (version 5.0)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION=5.6.0
TERMUX_PKG_SRCURL=https://github.com/libxmlplusplus/libxmlplusplus/releases/download/${TERMUX_PKG_VERSION}/libxml++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=cd01ad15a5e44d5392c179ddf992891fb1ba94d33188d9198f9daf99e1bc4fec
TERMUX_PKG_DEPENDS="libxml2, libiconv"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
