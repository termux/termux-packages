TERMUX_PKG_HOMEPAGE=https://github.com/thom311/libnl
TERMUX_PKG_DESCRIPTION="Collection of libraries providing APIs to netlink protocol based Linux kernel interfaces"
TERMUX_PKG_LICENSE="LGPL-2.1, GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.7.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/thom311/libnl/releases/download/libnl${TERMUX_PKG_VERSION//./_}/libnl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9fe43ccbeeea72c653bdcf8c93332583135cda46a79507bfd0a483bb57f65939
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_BREAKS="libnl-dev"
TERMUX_PKG_REPLACES="libnl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pthreads
--enable-cli
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after RELEASE / SOVERSION is changed.
	local _RELEASE=3
	local _SOVERSION=200

	for a in MAJOR_VERSION LT_CURRENT LT_AGE; do
		local _${a}=$(sed -En 's/^m4_define\(\[libnl_'"${a,,}"'\],\s*\[([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _LT_CURRENT - _LT_AGE ))
	if [ "${_RELEASE}" != "${_MAJOR_VERSION}" ] || \
		[ ! "${_LT_CURRENT}" ] || [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	CFLAGS+=" -Dsockaddr_storage=__kernel_sockaddr_storage"
}
