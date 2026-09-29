TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/libwps/
TERMUX_PKG_DESCRIPTION="a Microsoft Works file word processor format import filter library"
TERMUX_PKG_LICENSE="LGPL-2.1, MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.14"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/project/libwps/libwps/libwps-${TERMUX_PKG_VERSION}/libwps-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=365b968e270e85a8469c6b160aa6af5619a4e6c995dbb04c1ecc1b4dd13e80de
TERMUX_PKG_DEPENDS="libwpd, librevenge"
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
lib/libwps-0.4.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
