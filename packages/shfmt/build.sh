TERMUX_PKG_HOMEPAGE=https://github.com/mvdan/sh
TERMUX_PKG_DESCRIPTION="A shell parser and formatter"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=3.2.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mvdan/sh/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6755f587fcb6f037f819b96a322b0273d0ab6ecb5911c005b9aae74292c4a819

termux_step_make_install() {
	cd "$TERMUX_PKG_SRCDIR"

	termux_setup_golang

	export GOPATH="$TERMUX_PKG_BUILDDIR"
	mkdir -p "$GOPATH/src/github.com/mvdan"
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH/src/github.com/mvdan/sh"

	go build -modcacherw \
		-ldflags "-X main.version=$TERMUX_PKG_VERSION" \
		-o "$TERMUX_PREFIX/bin/shfmt" \
		./cmd/shfmt
}
