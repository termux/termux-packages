TERMUX_PKG_HOMEPAGE=https://caddyserver.com/
TERMUX_PKG_DESCRIPTION="Fast, cross-platform HTTP/2 web server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.11.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=ab2dc210bc7089fa7d041e702663e592b480945aa99f14b348090091103b7ec5
TERMUX_PKG_SRCURL=https://github.com/mholt/caddy/archive/v$TERMUX_PKG_VERSION.tar.gz

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p $GOPATH/src/github.com/mholt/
	cp -a $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/mholt/caddy

	cd $GOPATH/src/github.com/mholt/caddy/caddy
	go build
}

termux_step_make_install() {
	install -Dm700 $GOPATH/src/github.com/mholt/caddy/caddy/caddy \
		$TERMUX_PREFIX/bin/caddy
}
