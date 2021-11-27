TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gnushogi/
TERMUX_PKG_DESCRIPTION="Program that plays the game of Shogi, also known as Japanese Chess"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gnushogi/gnushogi-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ecc48a866303c63652552b325d685e7ef5e9893244080291a61d96505d52b29
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_lib_curses_clrtoeol=yes --with-curses"
TERMUX_PKG_RM_AFTER_INSTALL="info/gnushogi.info"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_HOSTBUILD=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -fcommon"
}

termux_step_post_configure () {
	cp $TERMUX_PKG_HOSTBUILD_DIR/gnushogi/pat2inc $TERMUX_PKG_BUILDDIR/gnushogi/pat2inc
	# Update timestamps so that the binaries does not get rebuilt:
	touch -d "next hour" $TERMUX_PKG_BUILDDIR/gnushogi/pat2inc
}
