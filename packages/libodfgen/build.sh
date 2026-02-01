TERMUX_PKG_HOMEPAGE=https://sourceforge.net/p/libwpd/wiki/libodfgen/
TERMUX_PKG_DESCRIPTION="Library for generating documents in Open Document Format"
TERMUX_PKG_LICENSE="LGPL-2.1, MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.1.8"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/libwpd/files/libodfgen/libodfgen-${TERMUX_PKG_VERSION}/libodfgen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=55200027fd46623b9bdddd38d275e7452d1b0ff8aeddcad6f9ae6dc25f610625
TERMUX_PKG_DEPENDS="libxml2, librevenge, liblangtag, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, libwpg, libetonyek"

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
lib/libodfgen-0.1.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
