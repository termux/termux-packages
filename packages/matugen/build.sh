TERMUX_PKG_HOMEPAGE=https://github.com/InioX/matugen
TERMUX_PKG_DESCRIPTION="A material you color generation tool with templates"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.0"
TERMUX_PKG_SRCURL=https://github.com/InioX/matugen/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f8c9c698dc85c0168cb3d41098f235eb4e2ba39d7d66a5c494c6f76cc806992b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
