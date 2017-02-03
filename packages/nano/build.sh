TERMUX_PKG_HOMEPAGE=https://www.nano-editor.org/
TERMUX_PKG_DESCRIPTION="Small, free and friendly text editor"
_MAJOR_VERSION=2.7
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=https://www.nano-editor.org/dist/v${_MAJOR_VERSION}/nano-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=23ffc2de52d687739fed6dc2fc94df36aa7da7bb52c8740c523fdd7336fdbc8c
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-utf8 --disable-libmagic"
TERMUX_PKG_RM_AFTER_INSTALL="bin/rnano share/man/man1/rnano.1 share/nano/man-html"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install () {
	# Configure nano to use syntax highlighting:
	NANORC=$TERMUX_PREFIX/etc/nanorc
	echo include \"$TERMUX_PREFIX/share/nano/\*nanorc\" > $NANORC
}
