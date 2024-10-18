TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Clp
TERMUX_PKG_DESCRIPTION="An open-source linear programming solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:1.17.10"
TERMUX_PKG_SRCURL=https://github.com/coin-or/Clp/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=0d79ece896cdaa4a3855c37f1c28e6c26285f74d45f635046ca0b6d68a509885
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++, libcoinor-osi, libcoinor-utils"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
