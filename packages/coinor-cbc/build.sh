TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Cbc
TERMUX_PKG_DESCRIPTION="An open-source mixed integer linear programming solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.13"
TERMUX_PKG_SRCURL=https://github.com/coin-or/Cbc/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=62fde44dcf6f3d05c5cd291d7435cdd1b7e8acd3c78ec481dd39fe49cbc40399
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="coinor-clp, libc++, libcoinor-cgl, libcoinor-osi, libcoinor-utils"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
