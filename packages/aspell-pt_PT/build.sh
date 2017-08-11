TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="Portuguese dictionary for GNU Aspell"
TERMUX_PKG_VERSION=20070510-0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/dict/pt_PT/aspell6-pt_PT-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b8b7a71a480f2a6659a3ab1e6069d4be7a9a929fc520e4a1364f51ce484ad9d6
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
    # aspell configure doesn't play nicely with cross-compile but it's so trivial
    # we can easily replace it.
    cat > $TERMUX_PKG_SRCDIR/Makefile <<EOF
ASPELL = `which aspell`
ASPELL_FLAGS = 
PREZIP = `which prezip`
DESTDIR =
dictdir = $TERMUX_PREFIX/lib/aspell-0.60
datadir = $TERMUX_PREFIX/lib/aspell-0.60

EOF
    cat $TERMUX_PKG_SRCDIR/Makefile.pre >> $TERMUX_PKG_SRCDIR/Makefile
}
