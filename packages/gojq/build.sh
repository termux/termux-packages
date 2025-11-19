TERMUX_PKG_HOMEPAGE=https://github.com/itchyny/gojq
TERMUX_PKG_DESCRIPTION="Pure Go implementation of jq"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.17"
TERMUX_PKG_SRCURL=https://github.com/itchyny/gojq/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=86b8393d04cb40db09a8de96199f358c1e49bbd7d1ace5c95496cc7cc4102b3b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go mod tidy
	go build -o gojq ./cmd/gojq
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" gojq
}
