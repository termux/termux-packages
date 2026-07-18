TERMUX_PKG_HOMEPAGE="https://github.com/tdf/libcmis"
TERMUX_PKG_DESCRIPTION="a C/C++ client library for the CMIS protocol"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1, MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.3"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/tdf/libcmis/releases/download/v${TERMUX_PKG_VERSION}/libcmis-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e2e151fdd47a345b6ef72cae1d8ecf3099bb90420f276761f2793ec317809307
TERMUX_PKG_DEPENDS="boost, curl, libxml2"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-man
--disable-static
--disable-tests
--disable-werror
--with-boost=$TERMUX_PREFIX
boost_cv_lib_tag=
"

termux_step_pre_configure() {
	autoreconf -fiv

	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libcmis-0.6.so
lib/libcmis-c-0.6.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
