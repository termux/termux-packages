TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Cgl
TERMUX_PKG_DESCRIPTION="An open-source cut generation library for COIN-OR projects"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.60.10"
TERMUX_PKG_SRCURL=https://github.com/coin-or/Cgl/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=41b7ac9402db883d9c487eb7101e59eb513cefd726e6e7a669dc94664d9385e6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="coinor-clp, libc++, libcoinor-osi, libcoinor-utils"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
