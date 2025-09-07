TERMUX_PKG_HOMEPAGE=http://abook.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://git.code.sf.net/p/abook/git
TERMUX_PKG_GIT_BRANCH=ver_${TERMUX_PKG_VERSION//./_}
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"

termux_step_pre_configure() {
	aclocal
	automake --add-missing
	autoreconf
}
