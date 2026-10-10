TERMUX_PKG_HOMEPAGE=https://github.com/direnv/direnv
TERMUX_PKG_DESCRIPTION="Environment switcher for shell"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.38.1"
TERMUX_PKG_SRCURL=https://github.com/direnv/direnv/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3bd0d49c163204543db8f22f55af8985121db24fe6b21c5b749695e4fbdbb1fe
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
}
