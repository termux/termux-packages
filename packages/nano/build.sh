TERMUX_PKG_HOMEPAGE=https://www.nano-editor.org/
TERMUX_PKG_DESCRIPTION="Small, free and friendly text editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="8.7.1"
TERMUX_PKG_SRCURL=https://nano-editor.org/dist/latest/nano-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=76f0dcb248f2e2f1251d4ecd20fd30fb400a360a3a37c6c340e0a52c2d1cdedf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_glob_h=no
ac_cv_header_pwd_h=no
gl_cv_func_strcasecmp_works=yes
--disable-libmagic
--enable-utf8
--with-wordbounds
"
TERMUX_PKG_CONFFILES="etc/nanorc"
TERMUX_PKG_RM_AFTER_INSTALL="bin/rnano share/man/man1/rnano.1 share/nano/man-html"

termux_step_post_make_install() {
	# Configure nano to use syntax highlighting:
	NANORC=$TERMUX_PREFIX/etc/nanorc
	echo "include \"$TERMUX_PREFIX/share/nano/*nanorc\"" > "$NANORC"
}
