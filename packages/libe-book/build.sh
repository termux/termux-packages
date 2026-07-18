TERMUX_PKG_HOMEPAGE="https://sourceforge.net/projects/libebook/"
TERMUX_PKG_DESCRIPTION="Library for import of reflowable e-book formats."
TERMUX_PKG_LICENSE="LGPL-2.1, MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.3"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/libebook/files//libe-book-${TERMUX_PKG_VERSION}/libe-book-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7e8d8ff34f27831aca3bc6f9cc532c2f90d2057c778963b884ff3d1e34dfe1f9
TERMUX_PKG_DEPENDS="libicu, liblangtag, librevenge, libxml2, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, cppunit, gperf"

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
lib/libe-book-0.1.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
