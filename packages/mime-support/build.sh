TERMUX_PKG_HOMEPAGE=https://packages.debian.org/en/stretch/mime-support
TERMUX_PKG_DESCRIPTION="MIME type associations for file types"
TERMUX_PKG_VERSION=3.60
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/m/mime-support/mime-support_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_FOLDERNAME=mime-support

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/mime.types $TERMUX_PREFIX/etc
}
