TERMUX_PKG_HOMEPAGE=https://golangci-lint.run/
TERMUX_PKG_DESCRIPTION="Fast linters runner for Go, aggregating many Go linters into one tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.13.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/golangci/golangci-lint/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a79a7a1faad9c1538e3f7f8b32843a53bbeedfa9ead45d9e8ca3bb210d55ece0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

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

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run ./cmd/golangci-lint completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/golangci-lint"
	go run ./cmd/golangci-lint completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_golangci-lint"
	go run ./cmd/golangci-lint completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/golangci-lint.fish"
}
