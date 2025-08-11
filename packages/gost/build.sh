TERMUX_PKG_HOMEPAGE=https://github.com/ginuerzh/gost
TERMUX_PKG_DESCRIPTION="GO Simple Tunnel - a simple tunnel written in golang"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ian4hu"
TERMUX_PKG_VERSION="2.12.0"
TERMUX_PKG_SRCURL=https://github.com/ginuerzh/gost/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ed575807b0490411670556d4471338f418c326bb1ffe25f52977735012851765
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	export GOPATH=$TERMUX_PKG_BUILDDIR
	mkdir -p "$GOPATH/src/github.com/ginuerzh"
	ln -sf "$TERMUX_PKG_SRCDIR" "$GOPATH/src/github.com/ginuerzh/gost"
	cd "$GOPATH/src/github.com/ginuerzh/gost/cmd/gost"
	go build
}

termux_step_make_install() {
	install -Dm700 \
		"$GOPATH/src/github.com/ginuerzh/gost/cmd/gost/gost" \
		"$TERMUX_PREFIX/bin/"
}
