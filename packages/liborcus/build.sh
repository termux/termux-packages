TERMUX_PKG_HOMEPAGE="https://gitlab.com/orcus/orcus/"
TERMUX_PKG_DESCRIPTION="File import filter library for spreadsheet documents."
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://gitlab.com/orcus/orcus/-/archive/${TERMUX_PKG_VERSION}/orcus-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3b4224cc28d280b0c45a2302aa024f9ad2a79781323ebf14c268819723cb00f1
TERMUX_PKG_DEPENDS="boost, libc++, libixion, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, mdds"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-python
--with-boost=$TERMUX_PREFIX
boost_cv_lib_system=yes
"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh

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
	local -a _SOVERSION_GUARD_FILES=(
		lib/liborcus-0.21.so
		lib/liborcus-parser-0.21.so
		lib/liborcus-mso-0.21.so
		lib/liborcus-spreadsheet-model-0.21.so
	)
	local f
	for f in "${_SOVERSION_GUARD_FILES[@]}"; do
		if [[ ! -e "${f}" ]]; then
			termux_error_exit "SOVERSION guard check failed."
		fi
	done
}
