TERMUX_PKG_HOMEPAGE=https://github.com/hyperrealm/libconfig
TERMUX_PKG_DESCRIPTION="C/C++ Configuration File Library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_SRCURL=https://github.com/hyperrealm/libconfig/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e95798d2992a66ecd547ce3651d7e10642ff2211427c43a7238186ff4c372627
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libconfig-dev"
TERMUX_PKG_REPLACES="libconfig-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=15

	local e=$(sed -En 's/^VERINFO\s*=\s*-version-info\s+([0-9]+):([0-9]+):([0-9]+).*/\1-\3/p' \
			lib/Makefile.am)
	if [ ! "${e}" ] || [ "${_SOVERSION}" != "$(( "${e}" ))" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	autoreconf -fi

	# ld.lld: error: non-exported symbol '__aeabi_d2lz' is referenced by 'libconfig++.so'
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
