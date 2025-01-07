TERMUX_PKG_HOMEPAGE=https://github.com/been-jamming/rubiks_cube
TERMUX_PKG_DESCRIPTION="A rubik's cube that runs in your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=git+https://github.com/been-jamming/rubiks_cube
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin rubiks_cube
}
