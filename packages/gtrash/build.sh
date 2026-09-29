TERMUX_PKG_HOMEPAGE=https://github.com/umlx5h/gtrash
TERMUX_PKG_DESCRIPTION="A featureful trash CLI manager, alternative to rm and trash-cli"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.0.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/umlx5h/gtrash/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=66003276073d9da03cbb4347a4b161f89c81f3706012b77c3e91a154c91f3586
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o gtrash \
		.
}

termux_step_make_install() {
	install -Dm755 gtrash "$TERMUX_PREFIX/bin/gtrash"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/gtrash"
	go run . completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_gtrash"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/gtrash.fish"
}
