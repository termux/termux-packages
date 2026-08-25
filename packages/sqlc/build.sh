TERMUX_PKG_HOMEPAGE=https://sqlc.dev
TERMUX_PKG_DESCRIPTION="Generate type-safe code from SQL"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.31.1"
TERMUX_PKG_SRCURL=https://github.com/sqlc-dev/sqlc/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
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
}
