TERMUX_PKG_HOMEPAGE=http://www.underbit.com/products/mad/
TERMUX_PKG_DESCRIPTION="MAD is a high-quality MPEG audio decoder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.4"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://codeberg.org/tenacityteam/libmad/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f4eb229452252600ce48f3c2704c9e6d97b789f81e31c37b0c67dd66f445ea35
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libmad-dev"
TERMUX_PKG_REPLACES="libmad-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DCMAKE_SYSTEM_NAME=Linux
"

termux_step_post_massage() {
	local _GUARD_FILE="lib/libmad.so.0"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
