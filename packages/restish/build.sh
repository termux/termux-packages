TERMUX_PKG_HOMEPAGE="https://github.com/rest-sh/restish"
TERMUX_PKG_DESCRIPTION="A CLI for interacting with REST-ish HTTP APIs"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.2"
TERMUX_PKG_SRCURL="https://github.com/rest-sh/restish/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=56234eb8442c2badacda10ebfe24fcac7a07e0125b7f741321f3004bd25bb52d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy

	go build \
		-ldflags="-s -w -X github.com/rest-sh/restish/v2/internal/cli.Version=${TERMUX_PKG_VERSION}" \
		./cmd/restish
}

termux_step_make_install() {
	install -Dm755 -t "${TERMUX_PREFIX}/bin" restish
}
