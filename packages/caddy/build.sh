TERMUX_PKG_HOMEPAGE=https://caddyserver.com/
TERMUX_PKG_DESCRIPTION="Fast, cross-platform HTTP/2 web server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mholt/caddy/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=82dde471af56db86f96a2dffc0631c4e0a9eea19debe966605a73b89fbb945b4

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p $GOPATH/src/github.com/mholt/
	cp -a $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/mholt/caddy

	cd $GOPATH/src/github.com/mholt/caddy/cmd/caddy
	export GO111MODULE=on
	go build -v .
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $GOPATH/src/github.com/mholt/caddy/cmd/caddy/caddy
}
