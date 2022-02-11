TERMUX_PKG_HOMEPAGE=https://pagure.io/mailcap
TERMUX_PKG_DESCRIPTION="Modern mime.types file from mailcap"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=2.1.53
TERMUX_PKG_VERSION=1:${_VERSION}
TERMUX_PKG_SRCURL=https://pagure.io/mailcap/archive/r${_VERSION//./-}/mailcap-r${_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=4f4195e2b3c7ffb656fe36ae05038fa31d81cd87efc4067f130d060ecdc863b2
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_CONFFILES="etc/mime.types"
# etc/mime.types was previously in mutt:
TERMUX_PKG_CONFLICTS="mutt (<< 1.8.3-1)"

termux_step_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/mime.types $TERMUX_PREFIX/etc/mime.types
}
