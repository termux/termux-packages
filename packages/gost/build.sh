TERMUX_PKG_HOMEPAGE=https://github.com/ginuerzh/gost
TERMUX_PKG_DESCRIPTION="GO Simple Tunnel - a simple tunnel written in golang"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ian4hu"
TERMUX_PKG_VERSION="2.12.0"
TERMUX_PKG_SRCURL=https://github.com/ginuerzh/gost/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ed575807b0490411670556d4471338f418c326bb1ffe25f52977735012851765
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
