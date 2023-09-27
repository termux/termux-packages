TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="English dictionary for aspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2020.12.07
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-${TERMUX_PKG_VERSION:2}-0.tar.bz2
TERMUX_PKG_SHA256=4c8f734a28a088b88bb6481fcf972d0b2c3dc8da944f7673283ce487eac49fb3
TERMUX_PKG_DEPENDS="aspell"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
	cat > $TERMUX_PKG_SRCDIR/Makefile <<- EOF
	ASPELL = `command -v aspell`
	ASPELL_FLAGS = 
	PREZIP = `command -v prezip`
	DESTDIR =
	dictdir = $TERMUX_PREFIX/lib/aspell-0.60
	datadir = $TERMUX_PREFIX/lib/aspell-0.60
	EOF
	cat $TERMUX_PKG_SRCDIR/Makefile.pre >> $TERMUX_PKG_SRCDIR/Makefile
}
