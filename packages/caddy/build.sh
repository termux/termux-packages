TERMUX_PKG_HOMEPAGE=https://caddyserver.com/
TERMUX_PKG_DESCRIPTION="Fast, cross-platform HTTP/2 web server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_SRCURL=https://github.com/mholt/caddy/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c1c7b337a5008d28c1956fd4f057104a78d0e24b74c30867cea988369b61fed3

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p $GOPATH/src/github.com/mholt/
	cp -a $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/mholt/caddy

	cd $GOPATH/src/github.com/mholt/caddy/caddy
	export GO111MODULE=on
	go build
}

termux_step_make_install() {
	install -Dm700 $GOPATH/src/github.com/mholt/caddy/caddy/caddy \
		$TERMUX_PREFIX/bin/caddy
}
