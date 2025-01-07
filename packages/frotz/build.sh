TERMUX_PKG_HOMEPAGE=https://gitlab.com/DavidGriffith/frotz
TERMUX_PKG_DESCRIPTION="Interpreter for Infocom and other Z-machine interactive fiction (IF) games"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# frotz does not depend on dialog or curl, but the zgames script we bundle below in termux_step_make_install() do.
TERMUX_PKG_VERSION=2.54
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.com/DavidGriffith/frotz/-/archive/${TERMUX_PKG_VERSION}/frotz-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a5ffc284ba9073382a604c21ef9d876c366c4964eeaebb6459ac830dd183bd98
TERMUX_PKG_DEPENDS="ncurses, dialog, curl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure () {
	export CURSES_CFLAGS="-I$TERMUX_PREFIX/include"
	export SYSCONFDIR="$TERMUX_PREFIX/include"
	export SOUND_TYPE="none"
}

termux_step_post_make_install () {
	install -m755 $TERMUX_PKG_BUILDER_DIR/zgames $TERMUX_PREFIX/bin/zgames
}
