TERMUX_PKG_HOMEPAGE=https://jonas.github.io/tig/
TERMUX_PKG_DESCRIPTION="Ncurses-based text-mode interface for git"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.1"
TERMUX_PKG_SRCURL=https://github.com/jonas/tig/releases/download/tig-$TERMUX_PKG_VERSION/tig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5adeabdcd93aa0423d618da8b878b53482bef6e0e9e1fe224acc0f18031fe91e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="git, libandroid-support, libiconv, ncurses, pcre2"

termux_step_post_make_install() {
	make -j 1 install-doc
}
