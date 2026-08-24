TERMUX_PKG_HOMEPAGE=https://goreleaser.com
TERMUX_PKG_DESCRIPTION="Deliver Go binaries as fast and easily as possible"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.18.0"
TERMUX_PKG_SRCURL=https://github.com/goreleaser/goreleaser/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=844b775db6a4473f96559d89b046db4adb96f78282ca64de6c6d4181ce7db336
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
}
