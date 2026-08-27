TERMUX_PKG_HOMEPAGE=https://github.com/securego/gosec
TERMUX_PKG_DESCRIPTION="Golang security checker"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.txt"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.29.0"
TERMUX_PKG_SRCURL=https://github.com/securego/gosec/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=083422c2d64f311062e7fe36ff1bd22c98b029f0a4d69f3e81fd0a4724139092
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
