TERMUX_PKG_HOMEPAGE=https://github.com/termux/command-not-found
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_REVISION=16
TERMUX_PKG_SRCURL=https://github.com/termux/command-not-found/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fb9fd13995a0b4ce3e72c4a679c25cb525d973f6d3eb480f5bb68807e26bd3b9
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	export TERMUX_PREFIX
	export TERMUX_SCRIPTDIR
	termux_setup_nodejs
}
