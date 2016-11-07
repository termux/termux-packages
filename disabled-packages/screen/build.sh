TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/screen/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with VT100/ANSI terminal emulation"
TERMUX_PKG_VERSION=4.4.0
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/screen/screen-${TERMUX_PKG_VERSION}.tar.gz
# TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl"

termux_step_pre_configure () {
	# Run autoreconf since we have patched configure.ac
	cd $TERMUX_PKG_SRCDIR
	autoconf
}
