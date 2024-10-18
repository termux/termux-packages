TERMUX_PKG_HOMEPAGE=https://libjpeg-turbo.virtualgl.org
TERMUX_PKG_DESCRIPTION="Library for reading and writing JPEG image files"
TERMUX_PKG_LICENSE="IJG, BSD 3-Clause, ZLIB"
TERMUX_PKG_LICENSE_FILE="README.ijg, LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.4"
TERMUX_PKG_SRCURL=https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/${TERMUX_PKG_VERSION}/libjpeg-turbo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=99130559e7d62e8d695f2c0eaeef912c5828d5b84a0537dcb24c9678c9d5b76b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libjpeg-turbo-dev"
TERMUX_PKG_REPLACES="libjpeg-turbo-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITH_JPEG8=1"

termux_step_pre_configure() {
	# SOVERSION suffix is needed for SONAME of shared libs to avoid conflict
	# with system ones (in /system/lib64 or /system/lib):
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_SYSTEM_NAME=Linux"
}

termux_step_post_massage() {
	# Check if SONAME is properly set:
	if ! readelf -d lib/libjpeg.so | grep -q '(SONAME).*\[libjpeg\.so\.'; then
		termux_error_exit "SONAME for libjpeg.so is not properly set."
	fi

	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION_GUARD_FILES="
lib/libjpeg.so.8
lib/libturbojpeg.so.0
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
