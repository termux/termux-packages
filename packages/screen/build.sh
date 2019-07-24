TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/screen/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with VT100/ANSI terminal emulation"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=4.6.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=1b6922520e6a0ce5e28768d620b0f640a6631397f95ccb043b70b91bb503fa3a
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/screen/screen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, libcrypt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-socket-dir
--enable-colors256
--with-ssl=openssl
"

termux_step_pre_configure() {
	# Run autoreconf since we have patched configure.ac
	autoconf
	CFLAGS+=" -DGETUTENT"
	LDFLAGS+=" -llog -lcrypt"
}

termux_step_post_configure() {
	echo '#define HAVE_SVR4_PTYS 1' >> $TERMUX_PKG_BUILDDIR/config.h
	echo 'mousetrack on' > "$TERMUX_PREFIX/etc/screenrc"
}
