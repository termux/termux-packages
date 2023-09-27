TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Clp
TERMUX_PKG_DESCRIPTION="An open-source linear programming solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.17.8
TERMUX_PKG_SRCURL=https://github.com/coin-or/Clp/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=f9931b5ba44f0daf445c6b48fc2c250dc12e667e59ace8ea7b025f158fe31556
TERMUX_PKG_DEPENDS="libc++, libcoinor-osi, libcoinor-utils"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
