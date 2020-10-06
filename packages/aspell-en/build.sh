TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="English dictionary for GNU Aspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_VERSION=2019.10.06-0
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=24334b4daac6890a679084f4089e1ce7edbe33c442ace776fa693d8e334f51fd

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
