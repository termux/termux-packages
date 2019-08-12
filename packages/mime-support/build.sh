TERMUX_PKG_HOMEPAGE=https://packages.debian.org/en/stretch/mime-support
TERMUX_PKG_DESCRIPTION="MIME type associations for file types"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_VERSION=3.62
TERMUX_PKG_SHA256=54e0a03e0cd63c7c9fe68a18ead0a2143fd3c327604215f989d85484d0409f4a
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/m/mime-support/mime-support_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/mime.types"
# etc/mime.types was previously in mutt:
TERMUX_PKG_CONFLICTS="mutt (<< 1.8.3-1)"

termux_step_make_install() {
	cp $TERMUX_PKG_SRCDIR/mime.types $TERMUX_PREFIX/etc
}
