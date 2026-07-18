TERMUX_PKG_HOMEPAGE=https://wiki.documentfoundation.org/DLP/Libraries/libcdr
TERMUX_PKG_DESCRIPTION="CorelDraw file format importer library for LibreOffice"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.8"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://dev-www.libreoffice.org/src/libcdr/libcdr-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=ced677c8300b29c91d3004bb1dddf0b99761bf5544991c26c2ee8f427e87193c
TERMUX_PKG_DEPENDS="libicu, librevenge, libxml2, littlecms, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, libwpg, cppunit"

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
lib/libcdr-0.1.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
