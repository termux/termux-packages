TERMUX_PKG_HOMEPAGE=https://github.com/InioX/matugen
TERMUX_PKG_DESCRIPTION="A material you color generation tool with templates"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_SRCURL=https://github.com/InioX/matugen/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f00b7bd284ef6184a0c94d54cb745230c6e58f26012491eaf7f7bcea0f3a489b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
