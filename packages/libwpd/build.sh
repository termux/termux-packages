TERMUX_PKG_HOMEPAGE=https://libwpd.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Library for importing WordPerfect (tm) documents"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.3"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/sourceforge/libwpd/libwpd-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=2465b0b662fdc5d4e3bebcdc9a79027713fb629ca2bff04a3c9251fdec42dd09
TERMUX_PKG_DEPENDS="librevenge"
TERMUX_PKG_BUILD_DEPENDS="boost"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"

	autoreconf -fi
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libwpd-0.10.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
