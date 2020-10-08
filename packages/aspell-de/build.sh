TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="German dictionary for GNU Aspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_VERSION=20161207-7-0
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c2125d1fafb1d4effbe6c88d4e9127db59da9ed92639c7cbaeae1b7337655571

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
