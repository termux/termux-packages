TERMUX_PKG_HOMEPAGE=https://jonas.github.io/tig/
TERMUX_PKG_DESCRIPTION="Ncurses-based text-mode interface for git"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.10"
TERMUX_PKG_SRCURL=https://github.com/jonas/tig/releases/download/tig-$TERMUX_PKG_VERSION/tig-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f655cc1366fc10058a2bd505bb88ca78e653ff7526c1b81774c44b9d841210e3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libiconv, ncurses, git, libandroid-support"

termux_step_post_make_install() {
	make -j 1 install-doc
}
