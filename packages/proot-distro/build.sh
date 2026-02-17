TERMUX_PKG_HOMEPAGE=https://github.com/termux/proot-distro
TERMUX_PKG_DESCRIPTION="Termux official utility for managing proot'ed Linux distributions"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.38.0"
TERMUX_PKG_SRCURL=https://github.com/termux/proot-distro/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=10ddabe1df5f3b433e9add0d6c6460ece607ea39b3decb338ccde78c86c80aec
TERMUX_PKG_DEPENDS="bash, bzip2, coreutils, curl, file, findutils, gzip, ncurses-utils, proot (>= 5.1.107-32), sed, tar, termux-tools, unzip, util-linux, xz-utils"
TERMUX_PKG_SUGGESTS="bash-completion, termux-api"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_make_install() {
	env TERMUX_APP_PACKAGE="$TERMUX_APP_PACKAGE" \
		TERMUX_PREFIX="$TERMUX_PREFIX" \
		TERMUX_ANDROID_HOME="$TERMUX_ANDROID_HOME" \
		./install.sh
}
