TERMUX_PKG_HOMEPAGE=https://www.libraw.org/
TERMUX_PKG_DESCRIPTION="Library for reading RAW files from digital cameras"
TERMUX_PKG_LICENSE="CDDL-1.0, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT, LICENSE.CDDL, LICENSE.LGPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.5"
TERMUX_PKG_SRCURL=https://www.libraw.org/data/LibRaw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a74a2e68303d3b9219f82318f935b28c5c4abd7f2c9f7dbf8faa4997c9038305
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libjasper, libjpeg-turbo, littlecms, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-openmp
"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
