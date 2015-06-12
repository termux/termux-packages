TERMUX_PKG_HOMEPAGE=http://www.nano-editor.org/
TERMUX_PKG_DESCRIPTION="Small, free and friendly text editor"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=2.4.1
TERMUX_PKG_SRCURL=http://www.nano-editor.org/dist/v2.4/nano-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support,libandroid-glob,ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-utf8 --disable-libmagic"
TERMUX_PKG_RM_AFTER_INSTALL="bin/rnano share/man/man1/rnano.1 share/nano/man-html"

LDFLAGS+=" -landroid-glob"

termux_step_post_make_install () {
	# Configure nano to use syntax highlighting:
	NANORC=$TERMUX_PREFIX/etc/nanorc
	echo include \"$TERMUX_PREFIX/share/nano/\*nanorc\" > $NANORC
}
