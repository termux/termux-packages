TERMUX_PKG_HOMEPAGE=https://github.com/strukturag/libheif
TERMUX_PKG_DESCRIPTION="HEIF (HEIC/AVIF) image encoding and decoding library"
TERMUX_PKG_LICENSE="LGPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.2"
TERMUX_PKG_SRCURL=https://github.com/strukturag/libheif/releases/download/v${TERMUX_PKG_VERSION}/libheif-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d016905e247d6952cd7ee4f9b90957350b6a6caa466bc76fdfe6eb302b6d088c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libaom, libc++, libdav1d, librav1e, libde265, libx265"

termux_step_pre_configure() {
	# SOVERSION suffix is needed for SONAME of shared libs to avoid conflict
	# with system ones (in /system/lib64 or /system/lib):
	sed -i 's/^\(linux\*android\)\*)/\1-notermux)/' configure

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}

termux_step_post_massage() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="lib/libheif.so.1"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done

	# Check if SONAME is properly set:
	if ! readelf -d lib/libheif.so | grep -q '(SONAME).*\[libheif\.so\.'; then
		termux_error_exit "SONAME for libheif.so is not properly set."
	fi
}
