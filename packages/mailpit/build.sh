TERMUX_PKG_HOMEPAGE=https://mailpit.axllent.org
TERMUX_PKG_DESCRIPTION="An email and SMTP testing tool with API for developers"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.31.0"
TERMUX_PKG_SRCURL="https://github.com/axllent/mailpit/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=010629f1c47c5a7e05818d1a2e2661ced9a16840355f328a68b7f780a4e50d8c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	termux_setup_nodejs

	# Build the embedded web UI assets first (go:embed picks these up
	# from server/ui/dist at compile time).
	npm ci
	npm run package

	go build \
		-trimpath \
		-ldflags="-s -w -X github.com/axllent/mailpit/config.Version=v${TERMUX_PKG_VERSION}" \
		-o mailpit \
		.
}

termux_step_make_install() {
	install -Dm755 mailpit "$TERMUX_PREFIX/bin/mailpit"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	go run . completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/mailpit"
	go run . completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_mailpit"
	go run . completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/mailpit.fish"
}
