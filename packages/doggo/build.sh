TERMUX_PKG_HOMEPAGE=https://github.com/mr-karan/doggo
TERMUX_PKG_DESCRIPTION="Command-line DNS client for humans, supporting DoH, DoT, DoQ, and DNSCrypt"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_SRCURL=https://github.com/mr-karan/doggo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=877f047fe81185d4fbeec870d54233f7ebf7c707a41cb98d023c34e089f9a0c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w -X 'main.buildVersion=v${TERMUX_PKG_VERSION}' -X 'main.buildDate=$(date '+%Y-%m-%d %H:%M:%S')'" \
		-o doggo \
		./cmd/doggo
}

termux_step_make_install() {
	install -Dm755 doggo "$TERMUX_PREFIX/bin/doggo"
}
