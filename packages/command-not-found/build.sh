TERMUX_PKG_HOMEPAGE=https://github.com/termux/command-not-found
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION=3.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/termux/command-not-found/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5571c3107e3d42e046ca48d7ff46f59cafadd2ae98dde4b5fd8b1af662b14d22
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	export TERMUX_PREFIX
	export TERMUX_SCRIPTDIR
	termux_setup_nodejs
}
