TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.21.0
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=55d3ed0971fc5fcc95a42938d461d70bbc09d3a790419e45d90168bf19bbd454
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, file, findutils, gzip, ncurses-utils, proot (>= 5.1.107-32), sed, tar, termux-tools, util-linux, xz-utils"
TERMUX_PKG_SUGGESTS="bash-completion, termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	env TERMUX_APP_PACKAGE="$TERMUX_APP_PACKAGE" \
		TERMUX_PREFIX="$TERMUX_PREFIX" \
		TERMUX_ANDROID_HOME="$TERMUX_ANDROID_HOME" \
		./install.sh
}
