TERMUX_PKG_HOMEPAGE=https://packages.debian.org/en/stretch/mime-support
TERMUX_PKG_DESCRIPTION="MIME type associations for file types"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_VERSION=3.63
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/m/mime-support/mime-support_$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8a97f4ffabf4a7dd34e6e21425b0b4a8926be6046678d851888d045b3935b643
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/mime.types"
# etc/mime.types was previously in mutt:
TERMUX_PKG_CONFLICTS="mutt (<< 1.8.3-1)"

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/mime.types $TERMUX_PREFIX/etc/mime.types
}
