TERMUX_PKG_HOMEPAGE=https://github.com/securego/gosec
TERMUX_PKG_DESCRIPTION="Golang security checker"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.30.0"
TERMUX_PKG_SRCURL="https://github.com/securego/gosec/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=58ad3a584453ad31f0b646818bcd1cc005afd20ef507d71cd41821fbba506332
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o gosec \
		./cmd/gosec
}

termux_step_make_install() {
	install -Dm755 gosec "$TERMUX_PREFIX/bin/gosec"
}
