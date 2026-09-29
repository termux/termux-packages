TERMUX_PKG_HOMEPAGE=https://github.com/x-motemen/ghq
TERMUX_PKG_DESCRIPTION="Manage remote repository clones, like go get does"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.11.0"
TERMUX_PKG_SRCURL=https://github.com/x-motemen/ghq/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4a95d38e7d89f2c1508d01d8933ced225eb4e6c31343304fa812fa69d002fa69
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build \
		-trimpath \
		-ldflags="-s -w -X main.revision=v${TERMUX_PKG_VERSION}" \
		-o ghq \
		.
}

termux_step_make_install() {
	install -Dm755 ghq "$TERMUX_PREFIX/bin/ghq"
}
