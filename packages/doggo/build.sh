TERMUX_PKG_HOMEPAGE=https://github.com/mr-karan/doggo
TERMUX_PKG_DESCRIPTION="Command-line DNS client for humans, supporting DoH, DoT, DoQ, and DNSCrypt"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.4.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/mr-karan/doggo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d707bd7948cd560c290298ba623f70681e93862eed2c8555b09b7b90f5610c9c
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
