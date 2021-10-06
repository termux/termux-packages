TERMUX_PKG_HOMEPAGE=https://github.com/mvdan/sh
TERMUX_PKG_DESCRIPTION="A shell parser and formatter"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mvdan/sh/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0eb593457df63c5a98597f6235b1ff558fadd18aed54653604731906790a9c90
TERMUX_PKG_AUTO_UPDATE=true

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
