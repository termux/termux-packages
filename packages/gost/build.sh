TERMUX_PKG_HOMEPAGE=https://github.com/go-gost/gost
TERMUX_PKG_DESCRIPTION="GO Simple Tunnel - a simple tunnel written in golang"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ian4hu"
TERMUX_PKG_VERSION="3.3.1"
TERMUX_PKG_SRCURL="https://github.com/go-gost/gost/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=3b5241edbc69d9578a37b3e950cf02ca7a7dc2aa2f688457affc63d966b93012
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go mod tidy

	go build --ldflags="-s -w" -a -o bin/gost cmd/gost/*.go
}

termux_step_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_BUILDDIR/bin/gost" \
		"$TERMUX_PREFIX/bin/"
}
