TERMUX_PKG_HOMEPAGE=https://www.libraw.org/
TERMUX_PKG_DESCRIPTION="Library for reading RAW files from digital cameras"
TERMUX_PKG_LICENSE="CDDL-1.0, LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT, LICENSE.CDDL, LICENSE.LGPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.3"
TERMUX_PKG_SRCURL=https://www.libraw.org/data/LibRaw-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dba34b7fc1143503942fa32ad9db43e94f714e62a4a856e91617f8f3e1e0aa5c
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
