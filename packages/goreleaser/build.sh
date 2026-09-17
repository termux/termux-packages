TERMUX_PKG_HOMEPAGE=https://goreleaser.com
TERMUX_PKG_DESCRIPTION="Deliver Go binaries as fast and easily as possible"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.18.2"
TERMUX_PKG_SRCURL="https://github.com/goreleaser/goreleaser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=aec0dee0c28739166cee8b81ef6f970cd90c02cf51687481a0c2ccc168f247f1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cp LICENSE.md LICENSE
}

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o goreleaser \
		.
}

termux_step_make_install() {
	install -Dm755 goreleaser "$TERMUX_PREFIX/bin/goreleaser"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/goreleaser"
	go run . completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_goreleaser"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/goreleaser.fish"
}
