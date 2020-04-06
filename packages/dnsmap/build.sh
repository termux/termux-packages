TERMUX_PKG_HOMEPAGE=https://github.com/resurrecting-open-source-projects/dnsmap
TERMUX_PKG_DESCRIPTION="Subdomain Bruteforcing Tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Rabby Sheikh @xploitednoob"
TERMUX_PKG_VERSION=0.35
TERMUX_PKG_SRCURL=https://github.com/resurrecting-open-source-projects/dnsmap/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6c8d28e461530721ed19314a6788f756a46c98356b5d66fa8b54294778c1f193

termux_step_pre_configure() {
	./autogen.sh
}
