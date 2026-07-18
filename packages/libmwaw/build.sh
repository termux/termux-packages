TERMUX_PKG_HOMEPAGE="https://sourceforge.net/projects/libmwaw/"
TERMUX_PKG_DESCRIPTION="Import library for some old mac text documents."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.22
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/libmwaw/files/libmwaw/libmwaw-${TERMUX_PKG_VERSION}/libmwaw-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a1a39ffcea3ff2a7a7aae0c23877ddf4918b554bf82b0de5d7ce8e7f61ea8e32
TERMUX_PKG_DEPENDS="doxygen, librevenge"
TERMUX_PKG_BUILD_DEPENDS="librevenge"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"

	autoreconf -fi
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libmwaw-0.3.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
