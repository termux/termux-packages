TERMUX_PKG_HOMEPAGE=https://github.com/asciimoo/wuzz
TERMUX_PKG_DESCRIPTION="Interactive command line tool for HTTP inspection"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/asciimoo/wuzz/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=721ea7343698e9f3c69e09eab86b9b1fef828057655f7cebc1de728c2f75151e
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH"/src/github.com/asciimoo
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH"/src/github.com/asciimoo/wuzz

	cd "$GOPATH"/src/github.com/asciimoo/wuzz
	go mod download github.com/BurntSushi/toml
	go get github.com/asciimoo/wuzz
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH"/src/github.com/asciimoo/wuzz/wuzz \
		"$TERMUX_PREFIX"/bin/wuzz
}
