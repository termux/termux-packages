TERMUX_PKG_HOMEPAGE=http://nginx.localdomain.pl/wiki/FcgiWrap
TERMUX_PKG_DESCRIPTION="A simple server for running CGI applications over FastCGI"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/gnosek/fcgiwrap/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4c7de0db2634c38297d5fcef61ab4a3e21856dd7247d49c33d9b19542bd1c61f
TERMUX_PKG_DEPENDS="fcgi"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=/share/man"

termux_step_pre_configure() {
	CFLAGS+=" -Wno-error=implicit-fallthrough"
	autoreconf -i
}
