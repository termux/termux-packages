TERMUX_PKG_HOMEPAGE=https://packages.debian.org/en/stretch/mime-support
TERMUX_PKG_DESCRIPTION="MIME type associations for file types"
TERMUX_PKG_VERSION=3.60
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/m/mime-support/mime-support_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f31d81f68dc007f56567cc14fb3b2effbd42d1dd087e414508e14e33d1a6a3a4
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
TERMUX_PKG_CONFFILES="etc/mime.types"
# etc/mime.types was previously in mutt:
TERMUX_PKG_CONFLICTS="mutt (<< 1.8.3-1)"

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/mime.types $TERMUX_PREFIX/etc
}
