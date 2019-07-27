TERMUX_PKG_HOMEPAGE=https://invisible-island.net/dialog/
TERMUX_PKG_DESCRIPTION="Application used in shell scripts which displays text user interface widgets"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION="1.3-20190724"
TERMUX_PKG_SRCURL=https://invisible-mirror.net/archives/dialog/dialog-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_SHA256=38c0855b3f59281a44ff15bfa2150070d89daa3a4e2cda1139f6399eeeeca924
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ncursesw --enable-widec --with-pkg-config"

termux_step_pre_configure() {
	# Put a temporary link for libtinfo.so
	ln -s -f $TERMUX_PREFIX/lib/libncursesw.so $TERMUX_PREFIX/lib/libtinfo.so
}

termux_step_post_make_install() {
	rm $TERMUX_PREFIX/lib/libtinfo.so
	cd $TERMUX_PREFIX/bin
	ln -f -s dialog whiptail
}
