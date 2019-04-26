TERMUX_PKG_HOMEPAGE=https://caddyserver.com/
TERMUX_PKG_DESCRIPTION="Fast, cross-platform HTTP/2 web server"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=1c8b435a79e21b9832c7a8a88c44e70bc80434ca3719853d2b1092ffbbbbff7d
TERMUX_PKG_SRCURL=https://github.com/mholt/caddy/archive/v$TERMUX_PKG_VERSION.tar.gz

termux_step_make() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_BUILDDIR

	mkdir -p $GOPATH/src/github.com/mholt/
	cp -a $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/mholt/caddy

	cd $GOPATH/src/github.com/mholt/caddy/caddy
	export GO111MODULE=on
	go build

	# Fix folders without write permissions preventing which fails repeating builds:
	cd $TERMUX_PKG_BUILDDIR
	find . -type d -exec chmod u+w {} \;
}

termux_step_make_install() {
	install -Dm700 $GOPATH/src/github.com/mholt/caddy/caddy/caddy \
		$TERMUX_PREFIX/bin/caddy
}
