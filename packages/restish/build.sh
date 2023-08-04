TERMUX_PKG_HOMEPAGE="https://github.com/danielgtaylor/restish"
TERMUX_PKG_DESCRIPTION="A CLI for interacting with REST-ish HTTP APIs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.18.0"
TERMUX_PKG_SRCURL="https://github.com/danielgtaylor/restish/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b56a27712135acd26ab6242c20989f64ba39d90c781a0d8b703663fe4ac8f8df
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy

	go build
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" restish
}
