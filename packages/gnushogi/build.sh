TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gnushogi/
TERMUX_PKG_DESCRIPTION="Program that plays the game of Shogi, also known as Japanese Chess"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=5bb0b5b2f6953b3250e965c7ecaf108215751a74
TERMUX_PKG_VERSION=2014.11.19
TERMUX_PKG_SRCURL=git+https://git.savannah.gnu.org/git/gnushogi.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_SHA256=3d3e4c0d7ce29cd0c18bcd2020a7330dd7d4b15b18b08ec493fffa13cc92a5f9
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_curses_clrtoeol=yes --with-curses"
TERMUX_PKG_RM_AFTER_INSTALL="info/gnushogi.info"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_GROUPS="games"

termux_step_host_build() {
	cd "$TERMUX_PKG_SRCDIR"
	cross_compiling=yes ./autogen.sh
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -fcommon"
}
