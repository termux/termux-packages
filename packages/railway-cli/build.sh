TERMUX_PKG_HOMEPAGE=https://railway.app
TERMUX_PKG_DESCRIPTION="This is the command line interface for Railway"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.23.0"
TERMUX_PKG_SRCURL=https://github.com/railwayapp/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1cedab3257d2883d22ff79c923d07ff8bfd6e1bc400b30a3c2e4c913ff5544d0
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}
