TERMUX_PKG_HOMEPAGE=https://pagure.io/mailcap
TERMUX_PKG_DESCRIPTION="List of standard media types and their usual file extension"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="10.1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://salsa.debian.org/debian/media-types/-/archive/${TERMUX_PKG_VERSION}/media-types-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d24e54447bf7cdf6dcea4d55faeb74c8156b7aed0757b962f94a5b1f1ab0de5c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BREAKS="mime-support"
TERMUX_PKG_REPLACES="mime-support"
TERMUX_PKG_PROVIDES="mime-support"
TERMUX_PKG_CONFFILES="etc/mime.types"
# etc/mime.types was previously in mutt:
TERMUX_PKG_CONFLICTS="mutt (<< 1.8.3-1)"

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/mime.types $TERMUX_PREFIX/etc/mime.types
}
