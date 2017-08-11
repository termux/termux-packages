TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="Bulgarian dictionary for GNU Aspell"
TERMUX_PKG_VERSION=4.1-0
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/dict/bg/aspell6-bg-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=74570005dc2be5a244436fa2b46a5f612be84c6843f881f0cb1e4c775f658aaa
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
