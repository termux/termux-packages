TERMUX_PKG_HOMEPAGE=https://github.com/InioX/matugen
TERMUX_PKG_DESCRIPTION="A material you color generation tool with templates"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.0"
TERMUX_PKG_SRCURL=https://github.com/InioX/matugen/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=82044ab8ac3e793b2b94f8f75917b348b4038585133a77c07f5de59c88d65244
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
