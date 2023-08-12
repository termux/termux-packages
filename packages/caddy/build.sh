TERMUX_PKG_HOMEPAGE=https://caddyserver.com/
TERMUX_PKG_DESCRIPTION="Fast, cross-platform HTTP/2 web server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/caddyserver/caddy/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ff73a9bd9968d63cae3d9f804d83e67759836a5331c9b13d04b30ebe86369722
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p $GOPATH/src/github.com/caddyserver/
	cp -a $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/caddyserver/caddy

	cd $GOPATH/src/github.com/caddyserver/caddy/cmd/caddy
	export GO111MODULE=on
	go build -v .
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $GOPATH/src/github.com/caddyserver/caddy/cmd/caddy/caddy
}
