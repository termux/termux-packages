TERMUX_PKG_HOMEPAGE=https://www.nano-editor.org/
TERMUX_PKG_DESCRIPTION="Small, free and friendly text editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_SHA256=86bde596a038d6fde619b49d785c0ebf0b3eaa7001a39dbe9316bd5392d221d0
TERMUX_PKG_SRCURL=https://nano-editor.org/dist/latest/nano-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_pwd_h=no
--disable-libmagic
--enable-utf8
--with-wordbounds
"
TERMUX_PKG_CONFFILES="etc/nanorc"
TERMUX_PKG_RM_AFTER_INSTALL="bin/rnano share/man/man1/rnano.1 share/nano/man-html"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	if [ "$TERMUX_DEBUG" == "true" ]; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.termux-build/_lib/16-aarch64-21-v3/bin/../sysroot/usr/include/bits/fortify/string.h:79:26: error: use of undeclared identifier '__USE_FORTIFY_LEVEL'
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}

termux_step_post_make_install() {
	# Configure nano to use syntax highlighting:
	NANORC=$TERMUX_PREFIX/etc/nanorc
	echo include \"$TERMUX_PREFIX/share/nano/\*nanorc\" > $NANORC
}
