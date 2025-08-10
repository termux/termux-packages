TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.27.0
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d4d5e7962c80cfc980d95da207abd8eb03377590edc2ba68c5ab96fe66db6c7b
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
