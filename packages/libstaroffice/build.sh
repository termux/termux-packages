TERMUX_PKG_HOMEPAGE="https://github.com/fosnola/libstaroffice"
TERMUX_PKG_DESCRIPTION="filter for old StarOffice documents(.sdc, .sdw, ...) based on librevenge"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.8"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/fosnola/libstaroffice/releases/download/${TERMUX_PKG_VERSION}/libstaroffice-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bbca92882e96c55bd1527670866d6bc7529ccb12786da55a2398b60a063378da
TERMUX_PKG_DEPENDS="librevenge, zlib"
TERMUX_PKG_AUTO_UPDATE=true

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
lib/libstaroffice-0.0.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
