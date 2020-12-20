TERMUX_PKG_HOMEPAGE=https://github.com/asciimoo/wuzz
TERMUX_PKG_DESCRIPTION="Interactive command line tool for HTTP inspection"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/asciimoo/wuzz/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=acf8e82481740d1403b744c58918b9089128d91c3c6edc15b76b6e1c97ead645

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/asciimoo
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/asciimoo/wuzz

	cd "$GOPATH"/src/github.com/asciimoo/wuzz
	go get -d -v github.com/asciimoo/wuzz
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/asciimoo/wuzz/wuzz \
		"$TERMUX_PREFIX"/bin/wuzz
}
