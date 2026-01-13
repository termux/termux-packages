TERMUX_PKG_HOMEPAGE=https://railway.app
TERMUX_PKG_DESCRIPTION="This is the command line interface for Railway"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.23.2"
TERMUX_PKG_SRCURL=https://github.com/railwayapp/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6155cd2577fe2be525c2c109d439e4c6d57ffbcd4d0eefee027bc5d1929aec3e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}
