TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="English dictionary for aspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2019.10.06
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-${TERMUX_PKG_VERSION:2}-0.tar.bz2
TERMUX_PKG_SHA256=24334b4daac6890a679084f4089e1ce7edbe33c442ace776fa693d8e334f51fd
TERMUX_PKG_DEPENDS="aspell"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_configure() {
	cat > $TERMUX_PKG_SRCDIR/Makefile <<- EOF
	ASPELL = `which aspell`
	ASPELL_FLAGS = 
	PREZIP = `which prezip`
	DESTDIR =
	dictdir = $TERMUX_PREFIX/lib/aspell-0.60
	datadir = $TERMUX_PREFIX/lib/aspell-0.60
	EOF
	cat $TERMUX_PKG_SRCDIR/Makefile.pre >> $TERMUX_PKG_SRCDIR/Makefile
}
