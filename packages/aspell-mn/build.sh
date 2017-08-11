TERMUX_PKG_HOMEPAGE=http://aspell.net
TERMUX_PKG_DESCRIPTION="Mongolian dictionary for GNU Aspell"
TERMUX_PKG_VERSION=0.06-2
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/aspell/dict/mn/aspell6-mn-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2f1b6edd48b82cd9b99b9262d5635f72271c062ef4e772b90388dfc48a4f1294
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
