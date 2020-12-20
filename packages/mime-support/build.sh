TERMUX_PKG_HOMEPAGE=https://packages.debian.org/en/stretch/mime-support
TERMUX_PKG_DESCRIPTION="MIME type associations for file types"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.64
TERMUX_PKG_SRCURL=http://http.debian.net/debian/pool/main/m/mime-support/mime-support_$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=587f35aabd25e9cabd9be485ce94539fb783d5b8d23492798dbec320ee6b1e88
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/mime.types"
# etc/mime.types was previously in mutt:
TERMUX_PKG_CONFLICTS="mutt (<< 1.8.3-1)"

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/mime.types $TERMUX_PREFIX/etc/mime.types
}
