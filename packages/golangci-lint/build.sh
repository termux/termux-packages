TERMUX_PKG_HOMEPAGE=https://golangci-lint.run/
TERMUX_PKG_DESCRIPTION="Fast linters runner for Go, aggregating many Go linters into one tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=2.13.1
TERMUX_PKG_SRCURL=https://github.com/golangci/golangci-lint/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e132dc546c90611af81eede4c213018a542ff33e4c10eadab5d964854e0d9ae
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="golang"

termux_step_make() {
	termux_setup_golang

	go build \
		-trimpath \
		-ldflags="-s -w -X main.version=${TERMUX_PKG_VERSION} -X main.commit=v${TERMUX_PKG_VERSION}" \
		-o golangci-lint \
		./cmd/golangci-lint
}

termux_step_make_install() {
	install -Dm755 golangci-lint "$TERMUX_PREFIX/bin/golangci-lint"
	install -Dm644 README.md "$TERMUX_PREFIX/share/doc/golangci-lint/README.md"
}
