TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/bc/
TERMUX_PKG_DESCRIPTION="Arbitrary precision numeric processing language"
TERMUX_PKG_VERSION=1.06.95
TERMUX_PKG_SRCURL=http://alpha.gnu.org/gnu/bc/bc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="readline,flex"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-readline --mandir=$TERMUX_PREFIX/share/man"
