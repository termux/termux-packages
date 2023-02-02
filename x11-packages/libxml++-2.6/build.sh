TERMUX_PKG_HOMEPAGE=https://libxmlplusplus.github.io/libxmlplusplus/
TERMUX_PKG_DESCRIPTION="A C++ wrapper for the libxml2 XML parser library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.42
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libxml++/${_MAJOR_VERSION}/libxml++-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a433987f54cc1ecaa84af26af047a62df9e884574e0d686e5ddc6f70441c152b
TERMUX_PKG_DEPENDS="libc++, libglibmm-2.4, libxml2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dvalidation=false
-Dbuild-examples=false
-Dbuild-tests=false
-Dmsvc14x-parallel-installable=false
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/${TERMUX_PKG_NAME}.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
