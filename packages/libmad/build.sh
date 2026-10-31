TERMUX_PKG_HOMEPAGE=http://www.underbit.com/products/mad/
TERMUX_PKG_DESCRIPTION="MAD is a high-quality MPEG audio decoder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://codeberg.org/tenacityteam/libmad/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e32320a010e3cc00bfa66e0cde523a969313cddfd81e07ec4e3ef06d10ad3fe0
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
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
