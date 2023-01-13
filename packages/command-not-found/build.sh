TERMUX_PKG_HOMEPAGE=https://github.com/termux/command-not-found
TERMUX_PKG_DESCRIPTION="Suggest installation of packages in interactive shell sessions"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.0
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/termux/command-not-found/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e8fe565d7385a682074e42960a04c4a76d10998fab1638e4b8971a8f8060c026
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	export TERMUX_PREFIX
	export TERMUX_SCRIPTDIR
	termux_setup_nodejs
}
