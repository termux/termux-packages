TERMUX_PKG_HOMEPAGE=https://sqlc.dev
TERMUX_PKG_DESCRIPTION="Generate type-safe code from SQL"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.31.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/sqlc-dev/sqlc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=de82593a200e4130dc2a0413a808f93fc30fdc7b5ecd402913ed08a8fea06c4a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	export CGO_CFLAGS="-D_GNU_SOURCE"

	go build \
		-trimpath \
		-ldflags="-s -w" \
		-o sqlc \
		./cmd/sqlc
}

termux_step_make_install() {
	install -Dm755 sqlc "$TERMUX_PREFIX/bin/sqlc"

	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"

	unset GOOS GOARCH CGO_LDFLAGS
	unset CC CXX CFLAGS CXXFLAGS LDFLAGS
	export CGO_CFLAGS="-D_GNU_SOURCE"
	go run ./cmd/sqlc completion bash > "${TERMUX_PREFIX}/share/bash-completion/completions/sqlc"
	go run ./cmd/sqlc completion zsh  > "${TERMUX_PREFIX}/share/zsh/site-functions/_sqlc"
	go run ./cmd/sqlc completion fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/sqlc.fish"
}
