TERMUX_PKG_HOMEPAGE="https://github.com/danielgtaylor/restish"
TERMUX_PKG_DESCRIPTION="A CLI for interacting with REST-ish HTTP APIs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.0-cifix"
TERMUX_PKG_SRCURL="https://github.com/danielgtaylor/restish/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=76796bc3403fbebf7f8ee7ea35c8d04f9a54015ae8af0d2830e374c2aede586f
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
