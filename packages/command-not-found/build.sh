TERMUX_PKG_HOMEPAGE=https://github.com/termux/command-not-found
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_SRCURL=https://github.com/termux/command-not-found/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=20b7c0f277bb393dbe8fd341692345d224a6fcdc17aae95d290961831e7ae702

termux_step_pre_configure() {
	export TERMUX_PREFIX
	export TERMUX_SCRIPTDIR
	termux_setup_nodejs
}
