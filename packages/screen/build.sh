TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/screen/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with VT100/ANSI terminal emulation"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.9.0
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/screen/screen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f9335281bb4d1538ed078df78a20c2f39d3af9a4e91c57d084271e0289c730f4
TERMUX_PKG_DEPENDS="ncurses, libcrypt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-socket-dir
--enable-colors256
"

termux_step_pre_configure() {
	# Run autoreconf since we have patched configure.ac
	autoreconf -fi
	CFLAGS+=" -DGETUTENT"
	export LIBS="-lcrypt"
}

termux_step_post_configure() {
	echo '#define HAVE_SVR4_PTYS 1' >> $TERMUX_PKG_BUILDDIR/config.h
	echo 'mousetrack on' > "$TERMUX_PREFIX/etc/screenrc"
}
