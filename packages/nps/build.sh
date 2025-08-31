TERMUX_PKG_HOMEPAGE=https://github.com/ehang-io
TERMUX_PKG_DESCRIPTION="a lightweight, high-performance, powerful intranet penetration proxy server, with a powerful web management terminal."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@ian4hu"
TERMUX_PKG_VERSION=0.26.10
TERMUX_PKG_SRCURL=https://github.com/ehang-io/nps/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1b2fe9d251f55105d65027a1cee464f65d2f6ab3bd4a20e4655e5135db68aee7
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go mod tidy

	go build -o bin/nps cmd/nps/nps.go
	go build -o bin/npc cmd/npc/npc.go
}

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX/bin/"
	install -Dm700 \
		"$TERMUX_PKG_BUILDDIR/bin/nps" \
		"$TERMUX_PREFIX/bin/"
	install -Dm700 \
		"$TERMUX_PKG_BUILDDIR/bin/npc" \
		"$TERMUX_PREFIX/bin/"
}
