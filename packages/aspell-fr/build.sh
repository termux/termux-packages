TERMUX_PKG_HOMEPAGE=http://aspell.net/
TERMUX_PKG_DESCRIPTION="French dictionary for aspell"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2:0.50-3
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-${TERMUX_PKG_VERSION:2}.tar.bz2
TERMUX_PKG_SHA256=f9421047519d2af9a7a466e4336f6e6ea55206b356cd33c8bd18cb626bf2ce91
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
