TERMUX_PKG_HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"
TERMUX_PKG_DESCRIPTION="a library that parses the file format of Aldus/Adobe PageMaker documents"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.0.4"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://dev-www.libreoffice.org/src/libpagemaker/libpagemaker-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=66adacd705a7d19895e08eac46d1e851332adf2e736c566bef1164e7a442519d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="librevenge"
TERMUX_PKG_BUILD_DEPENDS="boost"

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
lib/libpagemaker-0.0.so
"
	local f
	for f in ${_SOVERSION_GUARD_FILES}; do
		if [ ! -e "${f}" ]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
