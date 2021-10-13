TERMUX_PKG_HOMEPAGE=https://github.com/resurrecting-open-source-projects/dnsmap
TERMUX_PKG_DESCRIPTION="Subdomain Bruteforcing Tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.36
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/resurrecting-open-source-projects/dnsmap/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f52d6d49cbf9a60f601c919f99457f108d51ecd011c63e669d58f38d50ad853c
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	./autogen.sh
}
