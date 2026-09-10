TERMUX_PKG_HOMEPAGE=https://github.com/gitleaks/gitleaks
TERMUX_PKG_DESCRIPTION="Detect secrets like passwords, API keys, and tokens in git repos and files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="8.30.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/gitleaks/gitleaks/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e90fb266d75837e75894c778bf594ab8e2787f12dce5a62651f21b893eaf9abb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o gitleaks \
		.
}

termux_step_make_install() {
	install -Dm755 gitleaks "$TERMUX_PREFIX/bin/gitleaks"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/gitleaks"
	go run . completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_gitleaks"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/gitleaks.fish"
}
