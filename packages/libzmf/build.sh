TERMUX_PKG_HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libzmf"
TERMUX_PKG_DESCRIPTION="a library for import of Zoner drawing and bitmap files"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.2"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL="https://dev-www.libreoffice.org/src/libzmf/libzmf-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=27051a30cb057fdb5d5de65a1f165c7153dc76e27fe62251cbb86639eb2caf22
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libicu, libpng, librevenge, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, cppunit"

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
lib/libzmf-0.0.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
