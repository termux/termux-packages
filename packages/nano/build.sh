TERMUX_PKG_HOMEPAGE=https://www.nano-editor.org/
TERMUX_PKG_DESCRIPTION="Small, free and friendly text editor"
TERMUX_PKG_VERSION=2.8.7
TERMUX_PKG_SHA256=a49a888c20f09a17c7f1049d1fda619472c92eedcb25fd4be5f088a51cc392a5
TERMUX_PKG_SRCURL=https://www.nano-editor.org/dist/v${TERMUX_PKG_VERSION:0:3}/nano-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-libmagic
--enable-utf8
--with-wordbounds
"
TERMUX_PKG_RM_AFTER_INSTALL="bin/rnano share/man/man1/rnano.1 share/nano/man-html"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install () {
	# Configure nano to use syntax highlighting:
	NANORC=$TERMUX_PREFIX/etc/nanorc
	echo include \"$TERMUX_PREFIX/share/nano/\*nanorc\" > $NANORC
}
