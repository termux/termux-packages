TERMUX_PKG_HOMEPAGE=https://github.com/termux/command-not-found
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION=3.4.1
TERMUX_PKG_SRCURL=https://github.com/termux/command-not-found/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8dfec3aeb340d2359bf8c0b220497128f4b17bcb3967e4fd64f7a46773b40a3e
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	export TERMUX_PREFIX
	export TERMUX_SCRIPTDIR
	termux_setup_nodejs
}
