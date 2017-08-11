TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="Bengali dictionary for GNU Aspell"
TERMUX_PKG_VERSION=0.01.1-1
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/dict/bn/aspell6-bn-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b03f9cc4feb00df9bfd697b032f4f4ae838ad5a6bb41db798eefc5639a1480d9
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
