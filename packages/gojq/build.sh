TERMUX_PKG_HOMEPAGE=https://github.com/itchyny/gojq
TERMUX_PKG_DESCRIPTION="Pure Go implementation of jq"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12.20"
TERMUX_PKG_SRCURL=https://github.com/itchyny/gojq/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7a52db203c779c88eea3ad70d6e7f10daac804e0def4198a5766a41bf6f00141
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
