TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Osi
TERMUX_PKG_DESCRIPTION="An abstract base class to a generic linear programming (LP) solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.108.7
TERMUX_PKG_SRCURL=https://github.com/coin-or/Osi/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=f1bc53a498585f508d3f8d74792440a30a83c8bc934d0c8ecf8cd8bc0e486228
TERMUX_PKG_DEPENDS="libc++, libcoinor-utils"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
