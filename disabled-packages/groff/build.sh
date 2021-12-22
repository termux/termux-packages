TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/groff/
TERMUX_PKG_DESCRIPTION="GNU troff text-formatting program"
TERMUX_PKG_VERSION=1.22.3
TERMUX_PKG_SRCURL=http://ftp.gnu.org/gnu/groff/groff-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-doc=no --without-gs --without-x"
