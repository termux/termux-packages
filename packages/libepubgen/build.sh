TERMUX_PKG_HOMEPAGE="https://sourceforge.net/projects/libepubgen/"
TERMUX_PKG_DESCRIPTION="an EPUB generator for librevenge"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.2"
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/libepubgen/files/libepubgen-${TERMUX_PKG_VERSION}/libepubgen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=196c4bf9380463a3b40eb82c7dbf8a8b6a954987b4abbefe55467c215996eb7e
TERMUX_PKG_DEPENDS="librevenge"
TERMUX_PKG_BUILD_DEPENDS="boost, cppunit, libxml2"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libepubgen-0.1.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
