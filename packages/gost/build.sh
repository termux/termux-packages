TERMUX_PKG_HOMEPAGE=https://github.com/go-gost/gost
TERMUX_PKG_DESCRIPTION="GO Simple Tunnel - a simple tunnel written in golang"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ian4hu"
TERMUX_PKG_VERSION="3.3.0"
TERMUX_PKG_SRCURL="https://github.com/go-gost/gost/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=2a65e2da14fef6b6da8d4e32a8bc62e39970dbb141db42bc6f5821f90ac1e9a3
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
