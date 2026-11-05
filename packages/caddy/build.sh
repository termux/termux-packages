TERMUX_PKG_HOMEPAGE=https://caddyserver.com/
TERMUX_PKG_DESCRIPTION="Fast, cross-platform HTTP/2 web server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.11.9"
TERMUX_PKG_SRCURL=https://github.com/caddyserver/caddy/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fefbe1f72b7a7e244f348c20eba377bb1e6964f51594229d2f38c49eaa2aa9a4
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	# Use System CA Certs. See https://github.com/NixOS/nixpkgs/pull/576534
	rm "$TERMUX_PKG_SRCDIR/cmd/x509rootsfallback.go"

	mkdir -p $GOPATH/src/github.com/caddyserver/
	cp -a $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/caddyserver/caddy

	cd $GOPATH/src/github.com/caddyserver/caddy/cmd/caddy
	export GO111MODULE=on
	go build -v .
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $GOPATH/src/github.com/caddyserver/caddy/cmd/caddy/caddy
}
