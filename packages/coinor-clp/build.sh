TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/Clp
TERMUX_PKG_DESCRIPTION="An open-source linear programming solver"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:1.17.11"
TERMUX_PKG_SRCURL=https://github.com/coin-or/Clp/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=2c078e174dc1a7a308e091b6256fb34b4017897fc140ea707ba207b2913ea46d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++, libcoinor-osi, libcoinor-utils"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
