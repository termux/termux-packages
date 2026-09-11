TERMUX_PKG_HOMEPAGE=https://k6.io
TERMUX_PKG_DESCRIPTION="Modern load-testing tool for developers and testers"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SRCURL="https://github.com/grafana/k6/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c7dee72fc5fe54c3230fb5cdd67e9b9668bd98784cde057a92294fc2093a45aa
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go build -trimpath -o k6 .
}

termux_step_make_install() {
	install -Dm755 k6 "${TERMUX_PREFIX}/bin/k6"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/k6"
	go run . completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_k6"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/k6.fish"
}
