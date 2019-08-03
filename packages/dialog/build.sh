TERMUX_PKG_HOMEPAGE=https://invisible-island.net/dialog/
TERMUX_PKG_DESCRIPTION="Application used in shell scripts which displays text user interface widgets"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION="1.3-20190728"
TERMUX_PKG_SRCURL=https://invisible-mirror.net/archives/dialog/dialog-$TERMUX_PKG_VERSION.tgz
TERMUX_PKG_SHA256=e5eb0eaaef9cae8c822887bd998e33c2c3b94ebadd37b4f6aba018c0194a2a87
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
