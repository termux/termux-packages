TERMUX_PKG_HOMEPAGE=https://github.com/InioX/matugen
TERMUX_PKG_DESCRIPTION="A material you color generation tool with templates"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.1.0"
TERMUX_PKG_SRCURL=https://github.com/InioX/matugen/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b46507be24d01a6233597077512501f21075fe4ce19b60b410354f439f569ddf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
