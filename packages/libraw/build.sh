TERMUX_PKG_HOMEPAGE=https://www.libraw.org/
TERMUX_PKG_DESCRIPTION="Library for reading RAW files from digital cameras"
TERMUX_PKG_LICENSE="CDDL-1.0, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT, LICENSE.CDDL, LICENSE.LGPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.0"
TERMUX_PKG_SRCURL=https://www.libraw.org/data/LibRaw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1071e6e8011593c366ffdadc3d3513f57c90202d526e133174945ec1dd53f2a1
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
