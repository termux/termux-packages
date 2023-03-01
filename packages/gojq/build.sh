TERMUX_PKG_HOMEPAGE=https://github.com/itchyny/gojq
TERMUX_PKG_DESCRIPTION="Pure Go implementation of jq"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.12"
TERMUX_PKG_SRCURL=https://github.com/itchyny/gojq/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a2d61dd8378bc4948a1b6a5b727b0d5bb34791da121221098bf0349bdc40cefe
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
