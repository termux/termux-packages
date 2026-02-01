TERMUX_PKG_HOMEPAGE=https://libwpg.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Library for importing and converting Corel WordPerfect(tm) Graphics images."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.4"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/libwpg/libwpg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b55fda9440d1e070630eb2487d8b8697cf412c214a27caee9df69cec7c004de3
TERMUX_PKG_DEPENDS="libwpd, perl, librevenge"
TERMUX_PKG_BUILD_DEPENDS="boost"

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
lib/libwpg-0.3.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
