TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Clp
TERMUX_PKG_DESCRIPTION="An open-source linear programming solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.17.9
TERMUX_PKG_SRCURL=https://github.com/coin-or/Clp/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=b02109be54e2c9c6babc9480c242b2c3c7499368cfca8c0430f74782a694a49f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++, libcoinor-osi, libcoinor-utils"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
