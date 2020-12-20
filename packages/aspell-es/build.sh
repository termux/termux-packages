TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="Spanish dictionary for aspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.11
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/aspell/dict/es/aspell6-es-${TERMUX_PKG_VERSION:2}-2.tar.bz2
TERMUX_PKG_SHA256=ad367fa1e7069c72eb7ae37e4d39c30a44d32a6aa73cedccbd0d06a69018afcc
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
