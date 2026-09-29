TERMUX_PKG_HOMEPAGE="https://github.com/Numbertext/libnumbertext"
TERMUX_PKG_DESCRIPTION="Number to number name and money text conversion library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.11
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Numbertext/libnumbertext/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=80aad7cab123edc614f904d9f145d1d15cf465084a1a15fca2117525dc746034
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -vfi

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
lib/libnumbertext-1.0.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
