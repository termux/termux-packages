TERMUX_PKG_HOMEPAGE=https://caddyserver.com/
TERMUX_PKG_DESCRIPTION="Fast, cross-platform HTTP/2 web server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.11.4
TERMUX_PKG_SHA256=5f95c5dc8e0d6a63ae067bdfa42f78a4ca467cfff5407934582f1133ffcda532
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
