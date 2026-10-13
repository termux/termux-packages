TERMUX_PKG_HOMEPAGE=https://github.com/mvdan/sh
TERMUX_PKG_DESCRIPTION="A shell parser and formatter"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.14.1"
TERMUX_PKG_SRCURL="https://github.com/mvdan/sh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=ec4bdb88ab6c95686be3a4eeb4ad77d2b49d33d2ed7b0a65035cd52d2d87c443
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

	mkdir -p "$TERMUX_PREFIX/share/man/man1"
	scdoc < cmd/shfmt/shfmt.1.scd > "$TERMUX_PREFIX/share/man/man1/shfmt.1"
}
