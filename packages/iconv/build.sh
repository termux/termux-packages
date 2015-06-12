TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/libiconv/
TERMUX_PKG_DESCRIPTION="Utility converting between different character encodings"
TERMUX_PKG_VERSION=1.14
TERMUX_PKG_SRCURL=http://ftp.gnu.org/pub/gnu/libiconv/libiconv-${TERMUX_PKG_VERSION}.tar.gz
# Only install the binary, not the library since we use libandroid-support for iconv functions:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-static --disable-shared"

termux_step_make_install () {
	make -C lib install # this installs libiconv.{a,la} which the below install task needs:
	make -C src install
        rm $TERMUX_PREFIX/lib/libiconv.{a,la}
        # .. and the man page:
        cp $TERMUX_PKG_SRCDIR/man/iconv.1 $TERMUX_PREFIX/share/man/man1/
}
