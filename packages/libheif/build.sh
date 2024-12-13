TERMUX_PKG_HOMEPAGE=https://github.com/strukturag/libheif
TERMUX_PKG_DESCRIPTION="HEIF (HEIC/AVIF) image encoding and decoding library"
TERMUX_PKG_LICENSE="LGPL-3.0, MIT"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.19.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/strukturag/libheif/releases/download/v${TERMUX_PKG_VERSION}/libheif-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d3cf0a76076115a070f9bc87cf5259b333a1f05806500045338798486d0afbaf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, libaom, libc++, libdav1d, libde265, librav1e, libx265"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_PLUGIN_LOADING=OFF
"

termux_step_pre_configure() {
	# SOVERSION suffix is needed for SONAME of shared libs to avoid conflict
	# with system ones (in /system/lib64 or /system/lib):
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_SYSTEM_NAME=Linux"
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
