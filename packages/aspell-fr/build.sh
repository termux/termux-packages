TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="French dictionary for GNU Aspell"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="Copyright"
TERMUX_PKG_VERSION=0.50-3
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f9421047519d2af9a7a466e4336f6e6ea55206b356cd33c8bd18cb626bf2ce91

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
