TERMUX_PKG_HOMEPAGE=https://libimobiledevice.org
TERMUX_PKG_DESCRIPTION="A small portable C library to handle Apple Property List files in binary or XML format"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.LESSER"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.0"
TERMUX_PKG_SRCURL=https://github.com/libimobiledevice/libplist/releases/download/${TERMUX_PKG_VERSION}/libplist-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b1f59f7634c58b2481325a23ff4e3bf51574a42d868cbe466d2b39b04550752a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-cython
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=12

	local e=$(sed -En 's/^LIBPLIST_SO_VERSION="?([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
				configure.ac)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	sed -e 's|#if _MSC_VER|#if defined(_MSC_VER)|' -i include/plist/plist.h
	autoreconf -fi
}
