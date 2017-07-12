TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/screen/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with VT100/ANSI terminal emulation"
TERMUX_PKG_VERSION=4.6.1
TERMUX_PKG_SHA256=aba9af66cb626155d6abce4703f45cce0e30a5114a368bd6387c966cbbbb7c64
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/screen/screen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses, libcrypt, libutil"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-socket-dir
--enable-colors256
--with-ssl=openssl
"

termux_step_pre_configure () {
	# Run autoreconf since we have patched configure.ac
	autoconf
	CFLAGS+=" -DGETUTENT"
	LDFLAGS+=" -llog -lcrypt"
}

termux_step_post_configure() {
	echo '#define HAVE_SVR4_PTYS 1' >> $TERMUX_PKG_BUILDDIR/config.h
	echo 'mousetrack on' > "$TERMUX_PREFIX/etc/screenrc"
}
