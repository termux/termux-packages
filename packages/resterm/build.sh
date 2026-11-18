TERMUX_PKG_HOMEPAGE=https://resterm.app
TERMUX_PKG_DESCRIPTION="API client for the terminal with HTTP, GraphQL, gRPC and WebSocket support"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@unkn0wn-root"
TERMUX_PKG_VERSION="1.18.1"
TERMUX_PKG_SRCURL=https://github.com/unkn0wn-root/resterm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=618932c49c9aedf16bbb004e6de2bb069da78cecc1e034483d7fc90a6e7cb1f6
TERMUX_PKG_DEPENDS="ca-certificates"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	GOTOOLCHAIN=local go build \
		-trimpath \
		-mod=readonly \
		-ldflags="-s -w -X main.version=v${TERMUX_PKG_VERSION}" \
		-o resterm ./cmd/resterm
}

termux_step_make_install() {
	install -Dm700 resterm "$TERMUX_PREFIX/bin/resterm"
}
