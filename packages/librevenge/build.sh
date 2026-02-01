TERMUX_PKG_HOMEPAGE=https://sf.net/p/libwpd/librevenge/
TERMUX_PKG_DESCRIPTION="library for REVerses ENGineered formats filters"
TERMUX_PKG_LICENSE="LGPL-2.1, MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.5"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/libwpd/files/librevenge/librevenge-${TERMUX_PKG_VERSION}/librevenge-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=106d0c44bb6408b1348b9e0465666fa83b816177665a22cd017e886c1aaeeb34
TERMUX_PKG_DEPENDS="boost, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
"

termux_step_pre_configure() {
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
lib/librevenge-0.0.so
lib/librevenge-generators-0.0.so
lib/librevenge-stream-0.0.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
