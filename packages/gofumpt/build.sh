TERMUX_PKG_HOMEPAGE=https://github.com/mvdan/gofumpt
TERMUX_PKG_DESCRIPTION="A stricter gofmt, backwards compatible drop-in replacement"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL=https://github.com/mvdan/gofumpt/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9151983838fa3fbca5a83e3b302e81c68c61e393cb9d3b7e4c297df311bbf394
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o gofumpt \
		.
}

termux_step_make_install() {
	install -Dm755 gofumpt "$TERMUX_PREFIX/bin/gofumpt"
}
